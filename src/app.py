#'/api/v1/details'
#'/api/v1/healthz'

from flask import Flask, jsonify
import datetime
import socket

#create a flask app 
app = Flask(__name__)

#create a route for the root endpoint

@app.route('/')
def hellow_world():
    return jsonify({
        "message": "Hello, World!"
    })

#create a route for the details endpoint
@app.route('/api/v1/details')
def details():
    return jsonify({
        'timestamp': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'hostname': socket.gethostname(),
    }),200

#create a route for the healthz endpoint
@app.route('/api/v1/healthz')
def healthz():
    return jsonify({
        "message": "This is the healthz endpoint"
    }), 200

#run the app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    

