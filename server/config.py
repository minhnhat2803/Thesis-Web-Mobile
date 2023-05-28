import os

SECRET_KEY = os.urandom(32)

HOST = '192.168.1.16'
PORT = 8080

DEBUG = True

MONGO_URI = 'mongodb://localhost:27017'
DATABASENAME = 'netflix'
USER_COLLECTION = 'users'

