import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

import { getFirestore } from "firebase/firestore";
const firebaseConfig = {
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
