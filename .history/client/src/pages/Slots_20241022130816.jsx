import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore'; // Import Firestore functions
import { db } from './firebaseConfig'; // Import Firebase config
import styles from '../styles/pages/Slots.module.css';

const Slots = () => {
  const [slotsData, setSlotsData] = useState([]);
  const [selectedSlot, setSelectedSlot] = useState(null);

  // Hàm lấy dữ liệu từ Firebase
  const fetchSlotsData = async () => {
    try {
      const querySnapshot = await getDocs(collection(db, 'parkingSlots'));
      const slots = querySnapshot.docs.map(doc => doc.data());
      setSlotsData(slots);
    } catch (error) {
      console.error('Error fetching slot data:', error);
    }
  };

  const handleSlotClick = (slot) => {
    if (slot.isOccupied) {
      setSelectedSlot(slot); // Khi click vào slot, mở modal với thông tin slot
    }
  };

  useEffect(() => {
    fetchSlotsData(); // Gọi Firebase khi component được render
  }, []);

  return (
    <div className={styles.container}>
      <h1>Parking Slots</h1>
      <div className={styles.grid}>
        {slotsData.map((slot) => (
          <div
            key={slot.id}
            className={slot.isOccupied ? styles.occupied : styles.available}
            onClick={() => handleSlotClick(slot)}
          >
            Slot {slot.id}
          </div>
        ))}
      </div>

      {selectedSlot && (
        <div className={styles.overlay}>
          <div className={styles.modal}>
            <button onClick={() => setSelectedSlot(null)} className={styles.closeButton}>X</button>
            <h2>Car Information</h2>
            <p>License Plate: {selectedSlot.carInfo.licensePlate}</p>
            <p>Parking Time: {selectedSlot.carInfo.parkingTime}</p>
            <img src={selectedSlot.carInfo.imageUrl} alt="Car Image" className={styles.carImage} />
          </div>
        </div>
      )}
    </div>
  );
};

export default Slots;
