import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import styles from "../styles/pages/Slots.module.css";

const Slots = () => {
    const [slots, setSlots] = useState([]);
    const [selectedSlot, setSelectedSlot] = useState(null); // State to hold the selected slot info

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
            const licenseCollection = collection(db, "license_plates");
            const licenseSnapshot = await getDocs(licenseCollection);
            const licenseData = licenseSnapshot.docs.map((doc, index) => {
                const data = doc.data();
                return {
                    index: index + 1,
                    slotID: data.slot_id || "N/A",
                    licensePlate: data.license_plate || "N/A",
                    timeIn: data.entry_time || "N/A",
                    imageUrl: data.image_url || "",
                };
            });

            // Merge slot data with license plate information
            const mergedData = slotData.map((slot) => {
                const plateInfo = licenseData.find(
                    (plate) => plate.slotID === slot.id
                );
                return {
                    ...slot,
                    status: plateInfo ? "Occupied" : "Available", // Set status based on license plate info
                    plateInfo, // Add plateInfo to the slot data
                };
            });

            setSlots(mergedData);
        } catch (error) {
            console.error("Error fetching data: ", error);
        }
    };

    // Fetch data when component mounts
    useEffect(() => {
        fetchData();
    }, []);

    // Function to handle clicking on a slot
    const handleSlotClick = (slot) => {
        setSelectedSlot(slot); // Set the selected slot data for popup
    };

    // Close the popup
    const closePopup = () => {
        setSelectedSlot(null); // Reset the selected slot
    };

    return (
        <div className={styles.container}>
            <header className={styles.header}>
                <h1>Parking Lot Overview</h1>
            </header>

            {/* Display the legend for Occupied and Available statuses */}
            <div className={styles.legend}>
                <div className={styles.legendItem}>
                    <span className={styles.legendOccupied}></span> Occupied
                </div>
                <div className={styles.legendItem}>
                    <span className={styles.legendAvailable}></span> Available
                </div>
            </div>

            <div className={styles.parkingLot}>
                {/* Display all slots, using grid layout */}
                <div className={styles.parkingLotGrid}>
                    {slots.map((slot) => (
                        <div
                            key={slot.id}
                            className={`${styles.slot} ${
                                slot.status === "Occupied"
                                    ? styles.occupied
                                    : styles.available
                            }`}
                            onClick={() => handleSlotClick(slot)} // Handle click to open popup
                        >
                            <p>{slot.id}</p>
                        </div>
                    ))}
                </div>
            </div>

            {/* Popup to display vehicle info */}
            {selectedSlot && (
                <div className={styles.popup}>
                    <div className={styles.popupContent}>
                        <button
                            className={styles.closeBtn}
                            onClick={closePopup}
                        >
                            X
                        </button>
                        <h2>{selectedSlot.id} - Vehicle Info</h2>
                        {selectedSlot.status === "Occupied" ? (
                            <>
                                <p>
                                    <strong>License Plate:</strong>{" "}
                                    {selectedSlot.plateInfo.licensePlate}
                                </p>
                                <p>
                                    <strong>Entry Time:</strong>{" "}
                                    {selectedSlot.plateInfo.timeIn}
                                </p>
                                <img
                                    src={selectedSlot.plateInfo.imageUrl}
                                    alt="Vehicle"
                                    className={styles.vehicleImage}
                                />
                            </>
                        ) : (
                            <p>No vehicle in this slot.</p>
                        )}
                    </div>
                </div>
            )}
        </div>
    );
};

export default Slots;
