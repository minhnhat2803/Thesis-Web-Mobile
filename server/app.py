
from flask import Flask
from config import DEBUG, HOST, PORT, SECRET_KEY
from routes.Router import Router
from flask_cors import CORS

app = Flask(__name__)  
CORS(app)

@app.route('/')
def index():
    return '<h1>Rest API with Python Flask</h1>'

Router.run(app)

if __name__ == '__main__':
    app.run(host = HOST, port = PORT, debug = DEBUG)
