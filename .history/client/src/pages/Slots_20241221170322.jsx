import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import styles from "../styles/pages/Slots.module.css";

const Slots = () => {
    const [slots, setSlots] = useState([]);
    const [selectedSlot, setSelectedSlot] = useState(null); // State to hold the selected slot info
    const [isImageZoomed, setIsImageZoomed] = useState(false); // State to handle zoomed image

    // Fetch data from Firestore
    const fetchData = async () => {
        try {
            const slotSnapshot = await getDocs(collection(db, "parking_slots"));
            const slotData = slotSnapshot.docs.map((doc) => ({
                id: doc.id,
                ...doc.data(),
            }));

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

            const mergedData = slotData.map((slot) => {
                const plateInfo = licenseData.find(
                    (plate) => plate.slotID === slot.id
                );
                return {
                    ...slot,
                    status: plateInfo ? "Occupied" : "Available",
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

    const handleSlotClick = (slot) => {
        setSelectedSlot(slot);
        setIsImageZoomed(false); // Reset zoom on new slot click
    };

    const closePopup = () => {
        setSelectedSlot(null);
        setIsImageZoomed(false); // Reset zoom state when closing the popup
    };

    const handleImageClick = () => {
        setIsImageZoomed(!isImageZoomed); // Toggle zoom state
    };

    return (
        <div className={styles.container}>
            <header className={styles.header}>
                <h1>Parking Lot Overview</h1>
            </header>

            <div className={styles.legend}>
                <div className={styles.legendItem}>
                    <span className={styles.legendOccupied}></span> Occupied
                </div>
                <div className={styles.legendItem}>
                    <span className={styles.legendAvailable}></span> Available
                </div>
            </div>

            <div className={styles.parkingLot}>
                <div className={styles.parkingLotGrid}>
                    {slots.map((slot) => (
                        <div
                            key={slot.id}
                            className={`${styles.slot} ${
                                slot.status === "Occupied"
                                    ? styles.occupied
                                    : styles.available
                            }`}
                            onClick={() => handleSlotClick(slot)}
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
                                    className={`${styles.vehicleImage} ${
                                        isImageZoomed ? styles.zoomed : ""
                                    }`}
                                    onClick={handleImageClick}
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
