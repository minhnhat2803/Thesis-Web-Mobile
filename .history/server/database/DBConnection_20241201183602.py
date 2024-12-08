import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate('/Users/nguyenhuuminhnhat/Downloads/IoT_Smart_Parking/iot-smart-parking-72f94-firebase-adminsdk-6ubd4-b625b8ac08.json') 
#chỗ trong ngoặc kép thì lên firebase tạo file json chứa thông tin chứng chỉ rồi tạo đường dẫn của file json đã tải xuống dẫn vào đây
firebase_admin.initialize_app(cred, {'storageBucket': 'iot-smart-parking-72f94.appspot.com'})

def DBConnection(collectionName):
    client = firestore.client()
    db = client.collection(collectionName)
    return db