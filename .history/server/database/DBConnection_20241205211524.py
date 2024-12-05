import firebase_admin
from firebase_admin import credentials, firestore

# Đường dẫn đến tệp JSON chứng chỉ
SERVICE_ACCOUNT_PATH = '/Users/nguyenhuuminhnhat/Downloads/iot-smart-parking-72f94-firebase-adminsdk-6ubd4-0005edfa28.json'

def initialize_firebase():
    """
    Khởi tạo Firebase Admin SDK.
    """
    try:
        # Khởi tạo Firebase Admin với chứng chỉ JSON
        cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
        firebase_admin.initialize_app(cred)
        print("Firebase initialized successfully.")
    except Exception as e:
        print(f"Error initializing Firebase: {e}")

def get_firestore_collection(collection_name):
    """
    Kết nối và trả về tham chiếu đến một collection trong Firestore.
    """
    try:
        db = firestore.client()
        collection_ref = db.collection(collection_name)
        print(f"Connected to collection: {collection_name}")
        return collection_ref
    except Exception as e:
        print(f"Error connecting to Firestore collection: {e}")
        return None

# Ví dụ sử dụng
if __name__ == "__main__":
    # Khởi tạo Firebase
    initialize_firebase()
    
    # Kết nối đến collection 'license-plate'
    license_plate_collection = get_firestore_collection('license-plate')
    
    # Lấy dữ liệu từ Firestore
    if license_plate_collection:
        docs = license_plate_collection.stream()
        for doc in docs:
            print(f"{doc.id} => {doc.to_dict()}")
