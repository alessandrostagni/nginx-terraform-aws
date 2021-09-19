from dateutil import parser
from flask import Flask, request, jsonify


app = Flask(__name__)

TIMESTAMP_PREFIX = 'Timestamp: '
LOG_SEPARATOR = '---\n'


def search_logs(start_date, end_date):
    record = []
    results = []

    # By default we load rows in memory until we parse the date
    discard = False
    # Read log
    with open('/home/ec2-user/nginx-container/resource.log') as log:
        for row in log:
            # If separator is encountered, save records to results.
            if row == LOG_SEPARATOR:
                if not discard:
                    results.append(record)
                record = []
                discard = False
            elif row.startswith(TIMESTAMP_PREFIX):
                # Parse time when encountered,
                # and check whether it matches the query
                date = parser.parse(row.replace(TIMESTAMP_PREFIX, ''))
                if date >= start_date and date <= end_date:
                    record.append(row.strip())
                else:
                    discard = True
            elif not discard:
                # Keep record entry in memory if it matches the query
                record.append(row.strip())
    return results


@app.route('/search/', methods=['GET'])
def search():
    # Parse startdate and enddate of query
    try:
        start_date = parser.parse(request.args.get('startdate'))
        end_date = parser.parse(request.args.get('enddate'))
    except Exception:
        return "Invalid query.", 400

    # Get matching records and return them in JSON format
    records = search_logs(start_date, end_date)
    return jsonify(records)


app.run(host='0.0.0.0', port=8000)
