import React, { useState, useEffect } from 'react';
import styles from '../styles/pages/Slots.module.css';

// Dữ liệu mẫu để test
const testSlotsData = [
  { id: 1, isOccupied: true, carInfo: { licensePlate: 'ABC123', parkingTime: '2h', imageUrl: '/car1.jpg' } },
  { id: 2, isOccupied: false },
  { id: 3, isOccupied: true, carInfo: { licensePlate: 'XYZ789', parkingTime: '1h', imageUrl: '/car2.jpg' } },
  { id: 4, isOccupied: false },
  { id: 5, isOccupied: false }
];

const Slots = () => {
  const [selectedSlot, setSelectedSlot] = useState(null);

  const handleSlotClick = (slot) => {
    if (slot.isOccupied) {
      setSelectedSlot(slot); // Khi click vào slot, mở modal với thông tin slot
    }
  };

  useEffect(() => {
    console.log(testSlotsData); // Kiểm tra dữ liệu testSlotsData
  }, []);

  return (
    <div className={styles.container}>
      <h1>Parking Slots</h1>
      <div className={styles.grid}>
        {testSlotsData.map((slot) => (
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
