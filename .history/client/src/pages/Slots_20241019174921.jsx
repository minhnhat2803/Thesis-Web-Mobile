import React, { useState, useEffect } from 'react';
import styles from '../styles/pages/Slots.module.css';

const Slots = ({ slotsData = [] }) => {
  const [selectedSlot, setSelectedSlot] = useState(null);

  // Kiểm tra xem slotsData có dữ liệu hay không
  useEffect(() => {
    console.log(slotsData); // Kiểm tra xem dữ liệu có được truyền vào không
  }, [slotsData]);

  const handleSlotClick = (slot) => {
    if (slot.isOccupied) {
      setSelectedSlot(slot);
    }
  };

  return (
    <div className={styles.container}>
      <h1>Available Slots</h1>
      {/* Hiển thị thông báo nếu không có chỗ đậu nào */}
      {!slotsData.length && <p>No slots available</p>}
      
      <div className={styles.grid}>
        {slotsData.map((slot) => (
          <div
            key={slot.id || Math.random()} // Dùng id làm key, nếu id không tồn tại thì dùng giá trị tạm
            className={slot.isOccupied ? styles.occupied : styles.available}
            onClick={() => handleSlotClick(slot)}
          >
            Slot {slot.id}
          </div>
        ))}
      </div>

      {/* Hiển thị modal nếu slot đã được chọn */}
      {selectedSlot && (
        <div className={styles.overlay}>
          <div className={styles.modal}>
            <button onClick={() => setSelectedSlot(null)} className={styles.closeButton}>X</button>
            <h2>Car Information</h2>
            <p>License Plate: {selectedSlot?.carInfo?.licensePlate || 'N/A'}</p>
            <p>Parking Time: {selectedSlot?.carInfo?.parkingTime || 'N/A'}</p>
            <img src={selectedSlot?.carInfo?.imageUrl || '/placeholder.jpg'} alt="Car" className={styles.carImage} />
          </div>
        </div>
      )}
    </div>
  );
};

export default Slots;
