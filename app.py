
from flask import Flask
from config import DEBUG, HOST, PORT, SECRET_KEY
from routes.Router import Router

app = Flask(__name__)  
app.secret_key = SECRET_KEY

@app.route('/')
def index():
    return 'Rest API with Python Flask'

Router.run(app)

if __name__ == '__main__':
    app.run(host = HOST, port = PORT, debug = DEBUG)
