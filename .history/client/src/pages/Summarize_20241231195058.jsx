import React, { useState, useEffect } from "react";
import { Bar } from "react-chartjs-2";
import "chart.js/auto";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import { ClipLoader } from "react-spinners"; 
import styles from "../styles/pages/Summarize.module.css";

function Summarize() {
  const [data, setData] = useState({
    totalImages: 0,
    totalIn: 0,
    peakTime: "",
    avgTimes: Array(24).fill(0), 
    dailyStats: {},
    monthlyStats: {},
    yearlyStats: {},
  });
  const [loading, setLoading] = useState(true); // State for loading

  const fetchData = async () => {
    setLoading(true);
    const licenseCollection = collection(db, "licensePlates");
    const licenseSnapshot = await getDocs(licenseCollection);
    const licenseData = licenseSnapshot.docs.map((doc) => doc.data());

    let totalIn = 0;
    const hourCounts = Array(24).fill(0); // For tracking the number of vehicles per hour
    const dailyCounts = {}; // For daily counts
    const monthlyCounts = {}; // For monthly counts
    const yearlyCounts = {}; // For yearly counts

    licenseData.forEach((data) => {
      if (data.timeIN) {
        totalIn++;
        const hour = new Date(data.timeIN).getHours();
        hourCounts[hour]++; // Count the number of vehicles for each hour

        // Date-related counts
        const date = new Date(data.timeIN);
        const day = `${date.getDate()}-${date.getMonth() + 1}-${date.getFullYear()}`;
        const month = `${date.getMonth() + 1}-${date.getFullYear()}`;
        const year = `${date.getFullYear()}`;

        // Update daily, monthly, and yearly counts
        dailyCounts[day] = (dailyCounts[day] || 0) + 1;
        monthlyCounts[month] = (monthlyCounts[month] || 0) + 1;
        yearlyCounts[year] = (yearlyCounts[year] || 0) + 1;
      }
    });

    // Find the peak time
    const peakHour = hourCounts.indexOf(Math.max(...hourCounts));

    setData({
      totalImages: licenseData.length,
      totalIn,
      peakTime: peakHour,
      avgTimes: hourCounts, // Store hourly vehicle counts
      dailyStats: dailyCounts,
      monthlyStats: monthlyCounts,
      yearlyStats: yearlyCounts,
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
            <h2>Peak Vehicle Activity Hour</h2>
            <p>{data.peakTime}:00</p>
          </div>

          <div className={styles.statBox}>
            <h2>Daily Vehicle Counts</h2>
            <ul>
              {Object.keys(data.dailyStats).map((day) => (
                <li key={day}>
                  {day}: {data.dailyStats[day]}
                </li>
              ))}
            </ul>
          </div>

          <div className={styles.statBox}>
            <h2>Monthly Vehicle Counts</h2>
            <ul>
              {Object.keys(data.monthlyStats).map((month) => (
                <li key={month}>
                  {month}: {data.monthlyStats[month]}
                </li>
              ))}
            </ul>
          </div>

          <div className={styles.statBox}>
            <h2>Yearly Vehicle Counts</h2>
            <ul>
              {Object.keys(data.yearlyStats).map((year) => (
                <li key={year}>
                  {year}: {data.yearlyStats[year]}
                </li>
              ))}
            </ul>
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
