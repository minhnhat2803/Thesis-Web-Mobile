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

        // Lắng nghe thay đổi trong collection "parkingSlots"
        const unsubscribe = onSnapshot(collection(db, "parkingSlots"), () => {
            fetchData();
        });

        // Cleanup listener khi component unmount
        return () => unsubscribe();
    }, []);

    const addSlot = async () => {
        if (!newSlotID.trim()) return;
        try {
            await setDoc(doc(db, "parkingSlots", newSlotID), {
                activity: "available", 
                licensePlate: null, 
            });
            setNewSlotID("");
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
            </div>

            <div className={styles.parkingLot}>
                <div className={styles.entryExit}>
                    <div className={styles.exit}>
                        <span className={styles.arrow}>↑</span> Exit
                    </div>
                    <div className={styles.entry}>
                        Entry <span className={styles.arrow}>↓</span>
                    </div>
                </div>
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
                <div className={styles.cameras}>
                    <div className={styles.camera}>Camera 1</div>
                    <div className={styles.camera}>Camera 2</div>
                </div>
            </div>
        </div>
    );
};

export default Slots;