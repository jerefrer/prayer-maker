import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "AIzaSyDTQM6ej1wDDEH3sGpXxli4-vyDU6uyNHY",
  authDomain: "prayer-maker.firebaseapp.com",
  projectId: "prayer-maker",
  storageBucket: "prayer-maker.appspot.com",
  messagingSenderId: "541420320752",
  appId: "1:541420320752:web:6460ff194c8504569b8f35",
};
const app = initializeApp(firebaseConfig);
export const firestore = getFirestore(app);
export const auth = getAuth(app);