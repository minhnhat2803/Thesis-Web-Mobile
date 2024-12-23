import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import styles from "../styles/pages/Slots.module.css";

const Slots = () => {
    const [slots, setSlots] = useState([]);
    const [selectedSlot, setSelectedSlot] = useState(null); 
    const [isImageZoomed, setIsImageZoomed] = useState(false); 
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

    const handleSlotClick = (slot) => {
        setSelectedSlot(slot);
    };

    const closePopup = () => {
        setSelectedSlot(null);
    };

    const handleImageClick = (imageUrl) => {
        setZoomedImageUrl(imageUrl); 
    };

    const closeZoomedImage = () => {
        setZoomedImageUrl(""); 
    };

    return (
        <div className={styles.container}>
            <header className={styles.header}>
                <h1>Parking Slots Management</h1>
            </header>

            <div className={styles.parkingLot}>
                <div className={styles.parkingLotLayout}>
                    <div className={styles.entryExit}>
                        <div className={styles.entry}>
                            <h3>Entry</h3>
                            <div className={styles.camera}></div>
                        </div>
                        <div className={styles.exit}>
                            <h3>Exit</h3>
                            <div className={styles.camera}></div>
                        </div>
                    </div>
                    
                    <div className={styles.slotContainer}>
                        {slots.map((slot) => (
                            <div
                                key={slot.id}
                                className={`${styles.slot} ${
                                    slot.status === "Unavailable"
                                        ? styles.unavailable
                                        : styles.available
                                }`}
                                onClick={() => handleSlotClick(slot)}
                            >
                                <p>{slot.id}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </div>

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
                        {selectedSlot.status === "Unavailable" ? (
                            <>
                                <p>
                                    <strong>License Plate:</strong>{" "}
                                    {selectedSlot.plateInfo.licensePlate}
                                </p>
                                <p>
                                    <strong>Entry Time:</strong>{" "}
                                    {selectedSlot.plateInfo.timeIN}
                                </p>
                                <img
                                    src={selectedSlot.plateInfo.imageUrl}
                                    alt="Vehicle"
                                    className={styles.vehicleImage}
                                    onClick={() =>
                                        handleImageClick(
                                            selectedSlot.plateInfo.imageUrl
                                        )
                                    }
                                />
                            </>
                        ) : (
                            <p>No vehicle in this slot.</p>
                        )}
                    </div>
                </div>
            )}
            {zoomedImageUrl && (
                <div className={styles.popup} onClick={closeZoomedImage}>
                    <div className={styles.popupContent}>
                        <img
                            src={zoomedImageUrl}
                            alt="Zoomed Vehicle"
                            className={styles.popupImage}
                        />
                    </div>
                </div>
            )}
        </div>
    );
};

export default Slots;
