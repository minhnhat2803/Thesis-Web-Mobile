import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate('/Users/nguyenhuuminhnhat/Downloads/IoT_Smart_Parking/server/database/firebase_credentials.json') 
firebase_admin.initialize_app(cred, {'storageBucket': 'iot-smart-parking-72f94.appspot.com'})

def DBConnection(collectionName):
    client = firestore.client()
    db = client.collection(collectionName)
    return db
