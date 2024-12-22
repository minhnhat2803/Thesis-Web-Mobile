import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import styles from "../styles/pages/Slots.module.css";

const Slots = () => {
    const [slots, setSlots] = useState([]);
    const [licensePlates, setLicensePlates] = useState([]);
    const [selectedSlot, setSelectedSlot] = useState(null); // State to hold the selected slot info
    const [isLoading, setIsLoading] = useState(true); // State to manage loading

    // Fetch data from Firestore
    const fetchData = async () => {
        try {
            // Fetch parking slot data (statuses)
            const slotSnapshot = await getDocs(collection(db, "parking_slots"));
            const slotData = slotSnapshot.docs.map((doc) => ({
                id: doc.id,
                ...doc.data(),
            }));

            // Fetch license plate data
            const licensePlateSnapshot = await getDocs(
                collection(db, "license_plates")
            );
            const licensePlateData = licensePlateSnapshot.docs.map((doc) => ({
                slotId: doc.data().slot_id,
                license_plate: doc.data().license_plate,
                image_url: doc.data().image_url,
            }));

            console.log("Slots Data:", slotData);
            console.log("License Plates Data:", licensePlateData);

            setSlots(slotData);
            setLicensePlates(licensePlateData);
        } catch (error) {
            console.error("Error fetching slot data: ", error);
        } finally {
            // Ensure loading state is set to false after 2 seconds
            setTimeout(() => {
                setIsLoading(false);
            }, 2000);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleSlotClick = (slot) => {
        const slotLicensePlate = licensePlates.find(
            (plate) => plate.slotId === slot.id
        );
        console.log("Selected Slot:", slot);
        console.log("Slot License Plate:", slotLicensePlate);
        setSelectedSlot({
            ...slot,
            license_plate: slotLicensePlate
                ? slotLicensePlate.license_plate
                : null,
            image_url: slotLicensePlate ? slotLicensePlate.image_url : null,
        });

        // Reset animation for all available slots
        const availableSlots = document.querySelectorAll(
            `.${styles.slot}.available`
        );
        availableSlots.forEach((el) => {
            el.style.animation = "none";
            el.offsetHeight; // Trigger reflow
            el.style.animation = "";
        });
    };

    return (
        <div
            className={`${styles.slotsContainer} ${
                isLoading ? styles.loadingBackground : styles.defaultBackground
            }`}
        >
            {isLoading ? (
                <div className={styles.wrapper}>
                    <div className={styles.circle}></div>
                    <div className={styles.circle}></div>
                    <div className={styles.circle}></div>
                    <div className={styles.shadow}></div>
                    <div className={styles.shadow}></div>
                    <div className={styles.shadow}></div>
                </div>
            ) : (
                <>
                    <h1>Parking Slots</h1>
                    <div className={styles.boothContainer}>
                        <div className={styles.booth}>
                            <p>Booth - Entry/Exit</p>
                        </div>
                    </div>
                    <div className={styles.slotsGrid}>
                        {slots.map((slot) => (
                            <div
                                key={slot.id}
                                className={`${styles.slot} ${
                                    slot.status === "available"
                                        ? styles.available
                                        : styles.occupied
                                } ${
                                    selectedSlot && selectedSlot.id === slot.id
                                        ? styles.selected
                                        : ""
                                }`}
                                onClick={() => handleSlotClick(slot)}
                            >
                                {slot.id}
                            </div>
                        ))}
                    </div>
                    {selectedSlot && (
                        <div className={styles.slotDetails}>
                            <h2>Slot Details</h2>
                            <p>ID: {selectedSlot.id}</p>
                            <p>Status: {selectedSlot.status}</p>
                            {selectedSlot.license_plate && (
                                <p>
                                    License Plate: {selectedSlot.license_plate}
                                </p>
                            )}
                            {selectedSlot.image_url && (
                                <img
                                    src={selectedSlot.image_url}
                                    alt="Vehicle"
                                />
                            )}
                        </div>
                    )}
                </>
            )}
        </div>
    );
};

export default Slots;
