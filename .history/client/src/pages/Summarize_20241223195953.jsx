import React from "react";
import { Pie } from "react-chartjs-2";
import styles from "../styles/pages/Summarize.module.css";

function Summarize() {
  // Dữ liệu mẫu cho biểu đồ
  const totalPlates = 120;
  const chartData = {
    labels: ["Cars In", "Cars Out"],
    datasets: [
      {
        label: "Car Flow",
        data: [70, 50],
        backgroundColor: ["#4CAF50", "#FF5722"],
        borderWidth: 1,
      },
    ],
  };

  const chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: "bottom",
      },
    },
  };

  return (
    <div className={styles.dashboardContainer}>
      <h1>Dashboard Summary</h1>
      <div className={styles.summaryContainer}>
        <div className={styles.totalPlates}>Total Plates Collected: {totalPlates}</div>
        <div className={styles.chartContainer}>
          <Pie data={chartData} options={chartOptions} />
        </div>
      </div>
    </div>
  );
}

export default Summarize;