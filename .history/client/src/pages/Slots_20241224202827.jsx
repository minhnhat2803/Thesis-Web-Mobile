import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import {
    collection,
    getDocs,
    addDoc,
    deleteDoc,
    doc,
} from "firebase/firestore";
import styles from "../styles/pages/Slots.module.css";

const Slots = () => {
    const [slots, setSlots] = useState([]);
    const [newSlotID, setNewSlotID] = useState("");

    const fetchData = async () => {
        try {
            const slotSnapshot = await getDocs(collection(db, "parkingSlots"));
            const slotData = slotSnapshot.docs.map((doc) => ({
                id: doc.id,
                ...doc.data(),
            }));
            setSlots(slotData);
        } catch (error) {
            console.error("Error fetching data: ", error);
        }
    };

    const addSlot = async () => {
        if (!newSlotID.trim()) return;
        try {
            await addDoc(collection(db, "parkingSlots"), { id: newSlotID });
            setNewSlotID(""); // Clear input
            fetchData(); // Refresh slot list
        } catch (error) {
            console.error("Error adding slot: ", error);
        }
    };

    const deleteSlot = async (slotID) => {
        try {
            const slotRef = doc(db, "parkingSlots", slotID);
            await deleteDoc(slotRef);
            fetchData(); // Refresh slot list
        } catch (error) {
            console.error("Error deleting slot: ", error);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    return (
        <div className={styles.container}>
            <header className={styles.header}>
                <h1>Parking Slot Management</h1>
            </header>

            <div className={styles.actions}>
                <input
                    type="text"
                    placeholder="Enter Slot ID"
                    className={styles.input}
                    value={newSlotID}
                    onChange={(e) => setNewSlotID(e.target.value)}
                />
                <button className={styles.addBtn} onClick={addSlot}>
                    Add Slot
                </button>
                <button
                    className={styles.deleteBtn}
                    onClick={() =>
                        slots.length
                            ? deleteSlot(slots[slots.length - 1].id)
                            : null
                    }
                >
                    Delete Last Slot
                </button>
            </div>

            <div className={styles.parkingLot}>
                <div className={styles.parkingLotGrid}>
                    {slots.map((slot) => (
                        <div key={slot.id} className={styles.slot}>
                            <p>{slot.id}</p>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default Slots;
