import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin import credentials

cred = credentials.Certificate('./database/serviceAccountKey.json')
firebase_admin.initialize_app(cred, {'storageBucket': 'iot-project-course.appspot.com'})

def DBConnection(collectionName):
  client = firestore.client()
  db = client.collection(collectionName)
  return db
