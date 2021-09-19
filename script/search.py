from dateutil import parser
from flask import Flask, request, jsonify


app = Flask(__name__)

TIMESTAMP_PREFIX = 'Timestamp: '


def search_logs(start_date, end_date):
    record = ''
    results = []

    # By default we load rows in memory until we parse the date
    discard = False
    with open('/var/log/nginx-container/resource.log') as log:
        for row in log:
            if row == '---\n':
                if not discard:
                    results.append(record)
                record = ''
                discard = False
            elif row.startswith(TIMESTAMP_PREFIX):
                date = parser.parse(row.replace(TIMESTAMP_PREFIX, ''))
                if date >= start_date and date <= end_date:
                    record += row
                else:
                    discard = True
            elif not discard:
                record += row
    return results


@app.route('/search/', methods=['GET'])
def search():
    start_date = parser.parse(request.args.get('startdate'))
    end_date = parser.parse(request.args.get('enddate'))
    records = search_logs(start_date, end_date)
    return jsonify(records)


app.run(host='0.0.0.0', port=8000)
