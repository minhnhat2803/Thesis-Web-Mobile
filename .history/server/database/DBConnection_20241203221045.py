import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate('/Users/nguyenhuuminhnhat/Downloads/iot-smart-parking-72f94-firebase-adminsdk-6ubd4-d58e51b6e7.json') 
#bỏ dấu chú thích ở dòng trên
#chỗ trong ngoặc kép thì lên firebase tạo file json chứa thông tin chứng chỉ rồi tạo đường dẫn của file json đã tải xuống dẫn vào đây
firebase_admin.initialize_app(cred, {'storageBucket': 'iot-smart-parking-72f94.appspot.com'})

def DBConnection(collectionName):
    client = firestore.client()
    db = client.collection(collectionName)
    return db
