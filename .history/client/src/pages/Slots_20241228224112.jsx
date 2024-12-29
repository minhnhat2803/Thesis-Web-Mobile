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
    const [selectedSlots, setSelectedSlots] = useState([]);

    const fetchData = async () => {
        try {
            const slotSnapshot = await getDocs(collection(db, "parkingSlots"));
            const licenseSnapshot = await getDocs(collection(db, "licensePlates"));

            const slotData = slotSnapshot.docs.map((doc) => ({
                id: doc.id,
                ...doc.data(),
            }));

            const licenseData = licenseSnapshot.docs.map((doc) => doc.data());

            const mergedData = slotData.map((slot) => {
                const plateInfo = licenseData.find(
                    (plate) => plate.slotID === slot.id
                );
                return {
                    ...slot,
                    status: plateInfo ? "Unavailable" : "Available",
                    licensePlate: plateInfo?.licensePlate || "N/A",
                };
            });

            setSlots(mergedData);
        } catch (error) {
            console.error("Error fetching data: ", error);
        }
    };

    const addSlot = async () => {
        if (!newSlotID.trim()) return;
        try {
            await addDoc(collection(db, "parkingSlots"), { id: newSlotID });
            setNewSlotID("");
            fetchData();
        } catch (error) {
            console.error("Error adding slot: ", error);
        }
    };

    const deleteSelectedSlots = async () => {
        try {
            for (const slotID of selectedSlots) {
                const slotRef = doc(db, "parkingSlots", slotID);
                await deleteDoc(slotRef);
            }
            setSelectedSlots([]);
            fetchData();
        } catch (error) {
            console.error("Error deleting selected slots: ", error);
        }
    };

    const handleSlotClick = (slotID) => {
        setSelectedSlots((prevSelected) =>
            prevSelected.includes(slotID)
                ? prevSelected.filter((id) => id !== slotID)
                : [...prevSelected, slotID]
        );
    };

    const toggleDarkMode = () => {
        const currentMode = document.body.classList.contains('dark-mode');
        if (currentMode) {
            document.body.classList.remove('dark-mode');
        } else {
            document.body.classList.add('dark-mode');
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
                    onClick={deleteSelectedSlots}
                    disabled={selectedSlots.length === 0}
                >
                    Delete Selected Slots
                </button>
                <button className={styles.darkModeBtn} onClick={toggleDarkMode}>
                    Toggle Dark Mode
                </button>
            </div>

            <div className={styles.parkingLot}>
                <div className={styles.parkingLotGrid}>
                    {slots.map((slot) => (
                        <div
                            key={slot.id}
                            className={`${styles.slot} ${
                                slot.status === "Unavailable"
                                    ? styles.unavailable
                                    : styles.available
                            } ${selectedSlots.includes(slot.id) ? styles.selected : ""}`}
                            onClick={() => handleSlotClick(slot.id)}
                        >
                            <p>{slot.id}</p>
                            <span className={styles.status}>
                                {slot.status === "Unavailable"
                                    ? `License Plate: ${slot.licensePlate}`
                                    : "Available"}
                            </span>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default Slots;
