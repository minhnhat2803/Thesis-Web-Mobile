import os

SECRET_KEY = os.urandom(32)

HOST = 'localhost'
PORT = 8080

DEBUG = True

MONGO_URI = 'mongodb://localhost:27017'
DATABASENAME = 'netflix'
USER_COLLECTION = 'users'

