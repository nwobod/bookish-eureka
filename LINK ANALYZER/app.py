from flask import Flask, request, jsonify, abort
import subprocess
import json

app = Flask(__name__)

@app.route('/analyze', methods=['POST'])
def analyze_link():
    try:
        link = request.form['link']
        if not link.startswith('http://') and not link.startswith('https://'):
            abort(400, 'Invalid link format')
        output = subprocess.check_output(['bash', 'link_analyzer.sh', link])
        data = json.loads(output.decode('utf-8'))
        return jsonify(data)
    except subprocess.CalledProcessError as e:
        abort(500, 'Failed to analyze link')
    except json.JSONDecodeError as e:
        abort(500, 'Failed to parse JSON output')
    except Exception as e:
        abort(500, 'Internal server error')

if __name__ == '__main__':
    app.run(debug=True)