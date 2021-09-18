from dateutil import parser
from flask import Flask, request


app = Flask(__name__, debu)


def search_logs(start_date, end_date):
    record = []
    results = []

    # By default we load rows in memory until we parse the date
    discard = False
    with open('/log') as log:
        for row in log:
            if row == '\n':
                if not discard:
                    results.append(record)
                record = []
                discard = False
            elif row.startswith('Date:'):
                date = parser.parse(row.replace('Date: ', ''))
                if date >= start_date and date <= end_date:
                    record.append(row)
                else:
                    discard = True
            elif not discard:
                record.append(row)
    return results


@app.route('/search/', methods=['GET'])
def search():
    start_date = parser.parse(request.args.get('startdate'))
    end_date = parser.parse(request.args.get('enddate'))
    records = search_logs(start_date, end_date)
    print(records)


app.run(host='0.0.0.0', port=8000)
