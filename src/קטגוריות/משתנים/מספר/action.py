# line_service.py
import flask
from flask import request, jsonify

app = flask.Flask(__name__)

lines = []  # רשימה לאחסון קווים

@app.route('/add_line', methods=['POST'])
def add_line():
    line_data = request.json
    lines.append(line_data)
    return jsonify({'status': 'success', 'lines': lines})

@app.route('/get_lines', methods=['GET'])
def get_lines():
    return jsonify(lines)

if __name__ == '__main__':
    app.run(port=5000)
