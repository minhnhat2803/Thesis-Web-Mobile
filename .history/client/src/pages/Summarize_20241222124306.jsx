import React, { useState, useEffect } from "react";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import { Bar } from "react-chartjs-2";
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from "chart.js";
import styles from "../styles/pages/Summarize.module.css";

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

function Summarize() {
  const [data, setData] = useState([]);
  const [statistics, setStatistics] = useState({
    daily: 0,
    monthly: 0,
    yearly: 0,
    total: 0,
  });

  const fetchLicensePlates = async () => {
    const licenseCollection = collection(db, "licensePlates");
    const licenseSnapshot = await getDocs(licenseCollection);
    const licenseData = licenseSnapshot.docs.map((doc) => doc.data());
    setData(licenseData);
    calculateStatistics(licenseData);
  };

  const calculateStatistics = (licenseData) => {
    const now = new Date();
    const daily = licenseData.filter(
      (item) => new Date(item.timeIN).toLocaleDateString() === now.toLocaleDateString()
    ).length;
    const monthly = licenseData.filter(
      (item) => new Date(item.timeIN).getMonth() === now.getMonth() && new Date(item.timeIN).getFullYear() === now.getFullYear()
    ).length;
    const yearly = licenseData.filter(
      (item) => new Date(item.timeIN).getFullYear() === now.getFullYear()
    ).length;
    const total = licenseData.length;

    setStatistics({
      daily,
      monthly,
      yearly,
      total,
    });
  };

  useEffect(() => {
    fetchLicensePlates();
    const interval = setInterval(() => {
      fetchLicensePlates();
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  const chartData = {
    labels: ["Daily", "Monthly", "Yearly", "Total"],
    datasets: [
      {
        label: "Number of Cars",
        data: [statistics.daily, statistics.monthly, statistics.yearly, statistics.total],
        backgroundColor: "#517c64",
        borderColor: "#3e6249",
        borderWidth: 1,
      },
    ],
  };

  return (
    <div className={styles.summarizeContainer}>
      <div className={styles.statsContainer}>
        <div className={styles.chartContainer}>
          <Bar data={chartData} options={{ responsive: true, plugins: { title: { display: true, text: "Total Number by Daily, Monthly and Yearly" } } }} />
        </div>
      </div>
    </div>
  );
}

export default Summarize;
