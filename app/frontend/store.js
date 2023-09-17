import { writable } from "svelte/store";
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";


const app = initializeApp(firebaseConfig);
const db = getFirestore(app);


export const cloudStore = writable({});

let { subscribe, set } = writable({});

// Custom Store
export const customStore = () => {
  return {
    updateAmount: (value) => {
      set(value);
      debouncedCloudStoreSet(value);
    },
    subscribe: subscribe
  }
}

let debounceTimer;
const debouncedCloudStoreSet = value => {
  clearTimeout(debounceTimer);
  debounceTimer = setTimeout(() => {
    cloudStore.set(value);
  }, 750);
}
