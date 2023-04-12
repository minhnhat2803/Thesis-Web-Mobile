from firebase_admin import credentials, firestore, initialize_app

cred = credentials.Certificate('./database/serviceAccountKey.json')
initialize_app(cred)

def DBConnection(collectionName):
  client = firestore.client()
  db = client.collection(collectionName)
  return db

