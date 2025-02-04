import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import {
  collection,
  getDocs,
  setDoc,
  deleteDoc,
  doc,
  onSnapshot,
} from "firebase/firestore";
import styles from "../styles/pages/Slots.module.css";

const Slots = () => {
  const [slots, setSlots] = useState([]);
  const [newSlotID, setNewSlotID] = useState("");
  const [selectedSlots, setSelectedSlots] = useState([]);

  useEffect(() => {
    const unsubscribe = onSnapshot(collection(db, "parkingSlots"), (snapshot) => {
      const slotData = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      setSlots(slotData);
    });

    return () => unsubscribe();
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const licenseSnapshot = await getDocs(collection(db, "licensePlates"));
        const licenseData = licenseSnapshot.docs.map((doc) => doc.data());

        const mergedData = slots.map((slot) => {
          const license = licenseData.find((license) => license.slotID === slot.id);
          return {
            ...slot,
            licensePlate: license ? license.plateNumber : null,
          };
        });

        setSlots(mergedData);
      } catch (error) {
        console.error("Error fetching data: ", error);
      }
    };

    fetchData();
  }, [slots]);

  const handleAddSlot = async () => {
    if (newSlotID.trim() === "") return;

    try {
      await setDoc(doc(db, "parkingSlots", newSlotID), { occupied: false });
      setNewSlotID("");
    } catch (error) {
      console.error("Error adding slot: ", error);
    }
  };

  const handleDeleteSlot = async (id) => {
    try {
      await deleteDoc(doc(db, "parkingSlots", id));
    } catch (error) {
      console.error("Error deleting slot: ", error);
    }
  };

  const handleSelectSlot = (id) => {
    setSelectedSlots((prevSelectedSlots) =>
      prevSelectedSlots.includes(id)
        ? prevSelectedSlots.filter((slotID) => slotID !== id)
        : [...prevSelectedSlots, id]
    );
  };

  return (
    <div className={styles.slotsContainer}>
      <div className={styles.addSlotContainer}>
        <input
          type="text"
          value={newSlotID}
          onChange={(e) => setNewSlotID(e.target.value)}
          placeholder="Enter new slot ID"
        />
        <button onClick={handleAddSlot}>Add Slot</button>
      </div>
      <div className={styles.slotList}>
        {slots.map((slot) => (
          <div
            key={slot.id}
            className={`${styles.slotItem} ${
              selectedSlots.includes(slot.id) ? styles.selected : ""
            }`}
            onClick={() => handleSelectSlot(slot.id)}
          >
            <p>Slot ID: {slot.id}</p>
            <p>Occupied: {slot.occupied ? "Yes" : "No"}</p>
            <p>License Plate: {slot.licensePlate || "N/A"}</p>
            <button onClick={() => handleDeleteSlot(slot.id)}>Delete</button>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Slots;