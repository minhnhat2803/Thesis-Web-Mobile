import React, { useState, useEffect } from "react";
import styles from "../styles/pages/Summarize.module.css";

function Summarize() {
  const [data, setData] = useState({
    totalImages: 0,
    totalIn: 0,
    totalOut: 0,
    peakTime: "",
  });

  useEffect(() => {
    const fetchData = async () => {
      // Đây là dữ liệu giả, bạn cần thay đổi để lấy từ Firebase hoặc API thực tế
      const fetchedData = {
        totalImages: 500,
        totalIn: 300,
        totalOut: 200,
        peakTime: "3:00 PM", // Ví dụ thời gian cao điểm
      };
      setData(fetchedData);
    };
    fetchData();
  }, []);

  return (
    <div className={styles.summarizeContainer}>
      <h1>Summary Dashboard</h1>
      <div className={styles.statistics}>
        <div className={styles.statBox}>
          <h2>Total License Plate Images</h2>
          <p>{data.totalImages}</p>
        </div>
        <div className={styles.statBox}>
          <h2>Total Vehicles In</h2>
          <p>{data.totalIn}</p>
        </div>
        <div className={styles.statBox}>
          <h2>Total Vehicles Out</h2>
          <p>{data.totalOut}</p>
        </div>
        <div className={styles.statBox}>
          <h2>Peak Time</h2>
          <p>{data.peakTime}</p>
        </div>
      </div>
    </div>
  );
}

export default Summarize;
