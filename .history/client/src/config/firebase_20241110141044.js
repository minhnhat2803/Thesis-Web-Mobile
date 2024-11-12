// config/firebase.js

// Kiểm tra xem đang ở môi trường server hay client
const isServer = typeof window === "undefined";

let firebaseAdmin, firebaseApp, firestoreClient, storageClient, authClient;

if (isServer) {
  // Cấu hình Firebase Admin SDK (chỉ trên server)
  const firebaseAdmin = require("firebase-admin");
  const serviceAccount = {
    type: "service_account",
    project_id: "iot-smart-parking-72f94",
    private_key_id: "435656757049f82801be1e932e74e53e89be5f0d",
    private_key: "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkq...SU+DFJfBL3Ws/1UaC+y\n-----END PRIVATE KEY-----\n",
    client_email: "firebase-adminsdk-6ubd4@iot-smart-parking-72f94.iam.gserviceaccount.com",
    client_id: "117564580450737501517",
    auth_uri: "https://accounts.google.com/o/oauth2/auth",
    token_uri: "https://oauth2.googleapis.com/token",
    auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs",
    client_x509_cert_url: "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-6ubd4%40iot-smart-parking-72f94.iam.gserviceaccount.com",
    universe_domain: "googleapis.com"
  };

  // Khởi tạo Firebase Admin SDK
  if (!firebaseAdmin.apps.length) {
    firebaseAdmin.initializeApp({
      credential: firebaseAdmin.credential.cert(serviceAccount),
      storageBucket: "iot-smart-parking-72f94.appspot.com",
    });
  }
  
  firestoreClient = firebaseAdmin.firestore();
  storageClient = firebaseAdmin.storage();
} else {
  // Cấu hình Firebase Client SDK (chỉ trên client)
  import { initializeApp } from "firebase/app";
  import { getAuth } from "firebase/auth";
  import { getFirestore } from "firebase/firestore";
  import { getStorage } from "firebase/storage";

  const firebaseConfig = {
    apiKey: "AIzaSyBL6smHyIPLYk8AsCLDpU_Xcr4zFFii8rM",
    authDomain: "iot-smart-parking-72f94.firebaseapp.com",
    projectId: "iot-smart-parking-72f94",
    storageBucket: "iot-smart-parking-72f94.appspot.com",
    messagingSenderId: "144827756125",
    appId: "1:144827756125:web:6a4ce29fb31f48d54ae7b4",
    measurementId: "G-6L53JE2ZJF",
  };

  // Khởi tạo Firebase Client SDK
  if (!firebaseApp) {
    firebaseApp = initializeApp(firebaseConfig);
  }

  firestoreClient = getFirestore(firebaseApp);
  storageClient = getStorage(firebaseApp);
  authClient = getAuth(firebaseApp);
}

// Xuất ra các đối tượng dựa trên môi trường
export const db = firestoreClient;
export const storage = storageClient;
export const auth = isServer ? null : authClient;
