// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
// const firebaseConfig = {
//   apiKey: "AIzaSyBL6smHyIPLYk8AsCLDpU_Xcr4zFFii8rM",
//   authDomain: "iot-smart-parking-72f94.firebaseapp.com",
//   projectId: "iot-smart-parking-72f94",
//   storageBucket: "iot-smart-parking-72f94.appspot.com",
//   messagingSenderId: "144827756125",
//   appId: "1:144827756125:web:6a4ce29fb31f48d54ae7b4",
//   measurementId: "G-6L53JE2ZJF"
// };
const firebaseConfig = {
    apiKey: "AIzaSyCu7e0PT6FZu02VN8MntyMf4wkEagug7No",
    authDomain: "thesis-f3e40.firebaseapp.com",
    // databaseURL:
    //     "https://thesis-f3e40-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "thesis-f3e40",
    storageBucket: "thesis-f3e40.firebasestorage.app",
    messagingSenderId: "804795711136",
    appId: "1:804795711136:web:ee2c5ba7bb1a52d6ed93c5",
    measurementId: "G-K9WRRGM3FR",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
