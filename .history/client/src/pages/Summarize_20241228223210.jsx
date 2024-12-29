import React, { useState, useEffect } from "react";
import { Pie, Bar } from "react-chartjs-2";
import "chart.js/auto";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import { ClipLoader } from "react-spinners"; // For loading spinner
import styles from "../styles/pages/Summarize.module.css";

function Summarize() {
  const [data, setData] = useState({
    totalImages: 0,
    totalIn: 0,
    totalOut: 0,
    peakTime: "",
    avgTimes: Array(24).fill(0), // Array for hourly avg times
  });
  const [loading, setLoading] = useState(true); // State for loading

  const fetchData = async () => {
    setLoading(true);
    const licenseCollection = collection(db, "licensePlates");
    const licenseSnapshot = await getDocs(licenseCollection);
    const licenseData = licenseSnapshot.docs.map((doc) => doc.data());

    let totalIn = 0;
    let totalOut = 0;
    let peakTime = "";
    const timeCounts = {};
    const hourCounts = Array(24).fill(0); // For tracking the number of vehicles per hour

    licenseData.forEach((data) => {
      if (data.timeIN && data.timeOut) {
        totalIn++;
        totalOut++;
      }

      if (data.timeIN) {
        const hour = new Date(data.timeIN).getHours();
        hourCounts[hour]++; // Count the number of vehicles for each hour
      }

      if (data.timeOut) {
        const hour = new Date(data.timeOut).getHours();
        hourCounts[hour]++; // Count the number of vehicles for each hour
      }
    });

    // Find the peak time
    const peakHour = hourCounts.indexOf(Math.max(...hourCounts));

    setData({
      totalImages: licenseData.length,
      totalIn,
      totalOut,
      peakTime: peakHour,
      avgTimes: hourCounts, // Store hourly vehicle counts
    });
    setLoading(false); // Stop loading after data is processed
  };

  useEffect(() => {
    fetchData();
  }, []);

  const barChartData = {
    labels: Array.from({ length: 24 }, (_, i) => `${i}:00`), // Hourly labels
    datasets: [
      {
        label: "Vehicle Activity",
        data: data.avgTimes, // Average vehicle counts per hour
        backgroundColor: "rgba(75, 192, 192, 0.5)",
        borderColor: "rgba(75, 192, 192, 1)",
        borderWidth: 1,
      },
    ],
  };

  const chartOptions = {
    scales: {
      y: {
        display: false, // Hide the y-axis completely
      },
    },
  };

  return (
    <div className={styles.summarizeContainer}>
      <h1>Summary Dashboard</h1>
      {loading ? (
        <ClipLoader size={50} color="#4CAF50" />
      ) : (
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
            <Bar data={barChartData} options={chartOptions} />
          </div>
        </div>
      )}
    </div>
  );
}

export default Summarize;