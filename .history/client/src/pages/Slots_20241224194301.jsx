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
    const [newSlotName, setNewSlotName] = useState("");
    const [selectedSlot, setSelectedSlot] = useState(null);
    const [zoomedImageUrl, setZoomedImageUrl] = useState("");

    const fetchData = async () => {
        try {
            const slotSnapshot = await getDocs(collection(db, "parkingSlots"));
            const slotData = slotSnapshot.docs.map((doc) => ({
                id: doc.id,
                ...doc.data(),
            }));

            const licenseCollection = collection(db, "licensePlates");
            const licenseSnapshot = await getDocs(licenseCollection);
            const licenseData = licenseSnapshot.docs.map((doc, index) => {
                const data = doc.data();
                return {
                    index: index + 1,
                    slotID: data.slotID || "N/A",
                    licensePlate: data.licensePlate || "N/A",
                    timeIN: data.timeIN || "N/A",
                    imageUrl: data.imageUrl || "",
                };
            });

            const mergedData = slotData.map((slot) => {
                const plateInfo = licenseData.find(
                    (plate) => plate.slotID === slot.id
                );
                return {
                    ...slot,
                    status: plateInfo ? "Unavailable" : "Available",
                    plateInfo,
                };
            });

            setSlots(mergedData);
        } catch (error) {
            console.error("Error fetching data: ", error);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleAddSlot = async () => {
        if (!newSlotName.trim()) {
            alert("Slot name cannot be empty.");
            return;
        }
        try {
            await addDoc(collection(db, "parkingSlots"), { name: newSlotName });
            setNewSlotName("");
            fetchData();
        } catch (error) {
            console.error("Error adding slot: ", error);
        }
    };

    const handleDeleteSlot = async (slotId) => {
        if (window.confirm("Are you sure you want to delete this slot?")) {
            try {
                await deleteDoc(doc(db, "parkingSlots", slotId));
                fetchData();
            } catch (error) {
                console.error("Error deleting slot: ", error);
            }
        }
    };

    return (
        <div className={styles.container}>
            <header className={styles.header}>
                <h1>Parking Slots Management</h1>
            </header>

            <div className={styles.actions}>
                <input
                    type="text"
                    placeholder="New slot name"
                    value={newSlotName}
                    onChange={(e) => setNewSlotName(e.target.value)}
                    className={styles.input}
                />
                <button onClick={handleAddSlot} className={styles.addBtn}>
                    Add Slot
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
                            }`}
                        >
                            <p>{slot.id}</p>
                            <button
                                onClick={() => handleDeleteSlot(slot.id)}
                                className={styles.deleteBtn}
                            >
                                Delete
                            </button>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default Slots;
