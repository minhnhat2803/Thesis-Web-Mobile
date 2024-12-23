import React from "react";
import styles from "../styles/pages/Summarize.module.css";

function Summarize() {
  // Dữ liệu mẫu của các giao dịch thanh toán
  const paymentData = [
    {
      username: "John Doe",
      licensePlateImage: "/path/to/license-plate-image.jpg",
      parkingDuration: "5 hours",
      totalAmount: "$25.00",
      paymentStatus: "Paid",
      paymentTime: "2024-09-20 14:30",
    },
    {
      username: "Jane Smith",
      licensePlateImage: "/path/to/license-plate-image2.jpg",
      parkingDuration: "3 hours",
      totalAmount: "$15.00",
      paymentStatus: "Unpaid",
      paymentTime: "-",
    },
    // Thêm các dòng khác theo nhu cầu
  ];

  return (
    <div className={styles.cashContainer}>
      <h1>Payment Information</h1>
      <table className={styles.paymentTable}>
        <thead>
          <tr>
            <th>User Name</th>
            <th>License Plate</th>
            <th>Parking Duration</th>
            <th>Total Amount</th>
            <th>Payment Status</th>
            <th>Payment Time</th>
          </tr>
        </thead>
        <tbody>
          {paymentData.map((payment, index) => (
            <tr key={index}>
              <td>{payment.username}</td>
              <td>
                <img
                  src={payment.licensePlateImage}
                  alt="License Plate"
                  className={styles.licensePlateImage}
                />
              </td>
              <td>{payment.parkingDuration}</td>
              <td>{payment.totalAmount}</td>
              <td>{payment.paymentStatus}</td>
              <td>{payment.paymentTime}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default Summarize;
