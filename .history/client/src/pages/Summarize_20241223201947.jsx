import React, { useState, useEffect } from "react";
import { Pie } from "react-chartjs-2";
import "chart.js/auto";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import styles from "../styles/pages/Summarize.module.css";

function Summarize() {
  const [data, setData] = useState({
    totalImages: 0,
    totalIn: 0,
    totalOut: 0,
    peakTime: "",
  });

  const fetchData = async () => {
    const licenseCollection = collection(db, "licensePlates");
    const licenseSnapshot = await getDocs(licenseCollection);
    const licenseData = licenseSnapshot.docs.map((doc) => doc.data());

    let totalIn = 0;
    let totalOut = 0;
    let peakTime = "";
    const timeCounts = {};

    licenseData.forEach((data) => {
      if (data.timeIN && data.timeOut) {
        totalIn++;
        totalOut++;
      }
      if (data.timeIN) {
        const hour = new Date(data.timeIN).getHours();
        timeCounts[hour] = (timeCounts[hour] || 0) + 1;
      }
      if (data.timeOut) {
        const hour = new Date(data.timeOut).getHours();
        timeCounts[hour] = (timeCounts[hour] || 0) + 1;
      }
    });

    // Find the peak time
    const peakHour = Object.keys(timeCounts).reduce((a, b) =>
      timeCounts[a] > timeCounts[b] ? a : b
    );

    setData({
      totalImages: licenseData.length,
      totalIn,
      totalOut,
      peakTime: peakHour,
    });
  };

  useEffect(() => {
    fetchData();
  }, []);

  const chartData = {
    labels: ["Vehicles In", "Vehicles Out"],
    datasets: [
      {
        data: [data.totalIn, data.totalOut],
        backgroundColor: ["#4CAF50", "#F44336"],
      },
    ],
  };

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
          <h2>Peak Vehicle Activity Hour</h2>
          <p>{data.peakTime}:00</p>
        </div>
        <div className={styles.chartContainer}>
          <Pie data={chartData} />
        </div>
      </div>
    </div>
  );
}

export default Summarize;
