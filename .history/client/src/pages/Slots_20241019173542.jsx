import React, { useState, useEffect } from 'react';
import styles from '../sty/Slots.module.css';
import Modal from './Modal';  // Để tạo pop-up, bạn có thể tạo Modal component riêng

const Slots = ({ slotsData }) => {
  const [selectedSlot, setSelectedSlot] = useState(null);

  // Giả định slotsData là một mảng chứa thông tin từng chỗ đậu xe
  // Format dữ liệu mẫu: [{ id: 1, isOccupied: false, carInfo: {...} }, ...]

  const handleSlotClick = (slot) => {
    if (slot.isOccupied) {
      setSelectedSlot(slot);
    }
  };

  useEffect(() => {
    // Kết nối với sensor để cập nhật trạng thái chỗ đậu xe
    // Đây là phần bạn có thể tùy chỉnh theo việc lấy dữ liệu từ sensor
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
        <Modal onClose={() => setSelectedSlot(null)}>
          <h2>Car Information</h2>
          <p>License Plate: {selectedSlot.carInfo.licensePlate}</p>
          <p>Parking Time: {selectedSlot.carInfo.parkingTime}</p>
          <img src={selectedSlot.carInfo.imageUrl} alt="Car Image" />
        </Modal>
      )}
    </div>
  );
};

export default Slots;
