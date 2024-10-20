import React, { useState, useEffect } from 'react';
import styles from '../styles/pages/Slots.module.css';

const Slots = ({ slotsData }) => {
  const [selectedSlot, setSelectedSlot] = useState(null);

  const handleSlotClick = (slot) => {
    if (slot.isOccupied) {
      setSelectedSlot(slot);
    }
  };

  useEffect(() => {
    // Kết nối với sensor để cập nhật trạng thái chỗ đậu xe
    // Có thể thêm logic để cập nhật dữ liệu từ cảm biến
  }, []);

  return (
    <div className={styles.container}>
      <h1>Available Slots</h1>
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
