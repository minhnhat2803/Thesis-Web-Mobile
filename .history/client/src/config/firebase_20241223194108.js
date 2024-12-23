// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = { //Firebase của Nhật
    apiKey: "AIzaSyBL6smHyIPLYk8AsCLDpU_Xcr4zFFii8rM",
    authDomain: "iot-smart-parking-72f94.firebaseapp.com",
    projectId: "iot-smart-parking-72f94",
    storageBucket: "iot-smart-parking-72f94.appspot.com",
    messagingSenderId: "144827756125",
    appId: "1:144827756125:web:6a4ce29fb31f48d54ae7b4",
    measurementId: "G-6L53JE2ZJF",
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
