import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import { collection, getDocs, onSnapshot } from "firebase/firestore";
import styles from "../styles/pages/Slots.module.css";
import { FiSearch } from "react-icons/fi";

const Slots = () => {
    const [slots, setSlots] = useState([]);
    const [licensePlates, setLicensePlates] = useState([]);
    const [selectedSlot, setSelectedSlot] = useState(null); // State to hold the selected slot info
    const [isLoading, setIsLoading] = useState(true); // State to manage loading
    const [searchQuery, setSearchQuery] = useState("");
    const [showSearchBar, setShowSearchBar] = useState(false);
    const [searchResult, setSearchResult] = useState(null);
    const [showNotification, setShowNotification] = useState(false);
    const [isSearchLoading, setIsSearchLoading] = useState(false);

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
    const handleKeyPress = (e) => {
        if (e.key === "Enter") {
            handleSearch();
        }
    };

    useEffect(() => {
        // Fetch initial data
        fetchData();

        // Subscribe to real-time updates for parking slots
        const unsubscribeSlots = onSnapshot(
            collection(db, "parking_slots"),
            (snapshot) => {
                const slotData = snapshot.docs.map((doc) => ({
                    id: doc.id,
                    ...doc.data(),
                }));
                setSlots(slotData);
            },
            (error) =>
                console.error("Error listening to parking_slots: ", error)
        );

        // Subscribe to real-time updates for license plates
        const unsubscribeLicensePlates = onSnapshot(
            collection(db, "license_plates"),
            (snapshot) => {
                const licensePlateData = snapshot.docs.map((doc) => ({
                    slotId: doc.data().slot_id,
                    license_plate: doc.data().license_plate,
                    image_url: doc.data().image_url,
                }));
                setLicensePlates(licensePlateData);
            },
            (error) =>
                console.error("Error listening to license_plates: ", error)
        );

        // Cleanup subscriptions on component unmount
        return () => {
            unsubscribeSlots();
            unsubscribeLicensePlates();
        };
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
    const handleSearch = () => {
        if (!searchQuery.trim()) return;

        setIsSearchLoading(true);
        setTimeout(() => {
            const result = licensePlates.find(
                (plate) => plate.license_plate === searchQuery
            );
            setSearchResult(result);
            setIsSearchLoading(false);
            setShowNotification(true);

            // Hide notification after 3 seconds
            setTimeout(() => {
                setShowNotification(false);
            }, 3000);
        }, 2000);
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
                    <h1 className={styles.header}>Parking Slots</h1>
                    <div className={styles.content}>
                        <div className={styles.slotsGrid}>
                            {slots.map((slot) => (
                                <div
                                    key={slot.id}
                                    className={`${styles.slot} ${
                                        slot.status === "available"
                                            ? styles.available
                                            : styles.occupied
                                    } ${
                                        selectedSlot &&
                                        selectedSlot.id === slot.id
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
                                        License Plate:{" "}
                                        {selectedSlot.license_plate}
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
                        {showSearchBar && (
                            <div className={styles.searchBar}>
                                <input
                                    type="text"
                                    value={searchQuery}
                                    onChange={(e) =>
                                        setSearchQuery(e.target.value)
                                    }
                                    placeholder="Enter license plate"
                                />
                                <button
                                    onClick={handleSearch}
                                    disabled={isSearchLoading}
                                >
                                    {isSearchLoading ? (
                                        <div className={styles.searchLoader}>
                                            <span className={styles.bar}></span>
                                            <span className={styles.bar}></span>
                                            <span className={styles.bar}></span>
                                        </div>
                                    ) : (
                                        "Search"
                                    )}
                                </button>
                            </div>
                        )}
                        <button
                            className={styles.searchIcon}
                            onClick={() => setShowSearchBar(!showSearchBar)}
                        >
                            <FiSearch size={24} />
                        </button>
                        <div
                            className={`${styles.searchBar} ${
                                showSearchBar ? styles.show : ""
                            }`}
                        >
                            <input
                                type="text"
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                onKeyPress={handleKeyPress}
                                placeholder="Enter license plate..."
                            />
                            {isSearchLoading && (
                                <div className={styles.searchSpinner} />
                            )}
                        </div>
                        <div
                            className={`${styles.notification} ${
                                showNotification ? styles.show : ""
                            }`}
                        >
                            {searchResult ? (
                                <p>
                                    License plate: {searchQuery} is located in{" "}
                                    {searchResult.slotId}
                                </p>
                            ) : (
                                <p>License plate: {searchQuery} not found</p>
                            )}
                        </div>
                    </div>
                </>
            )}
        </div>
    );
};

export default Slots;
