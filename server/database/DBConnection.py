import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate('E:\My study\Thesis\thesis-f3e40-firebase-adminsdk-c2c2i-0355b1bdf3.json') 
#bỏ dấu chú thích ở dòng trên và thay đường dẫn file json của bạn vào đây
#chỗ trong ngoặc kép thì lên firebase tạo file json chứa thông tin chứng chỉ rồi tạo đường dẫn của file json đã tải xuống dẫn vào đây
firebase_admin.initialize_app(cred, {'storageBucket': 'thesis-f3e40.firebasestorage.app'})

def DBConnection(collectionName):
    client = firestore.client()
    db = client.collection(collectionName)
    return db
