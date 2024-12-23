import React, { useState, useEffect } from "react";
import { Pie } from "react-chartjs-2";
import "chart.js/auto";
import styles from "../styles/pages/Summarize.module.css";

function Summarize() {
  const [data, setData] = useState({
    totalImages: 0,
    totalIn: 0,
    totalOut: 0,
  });

  useEffect(() => {
    const fetchData = async () => {
      const fetchedData = {
        totalImages: 500,
        totalIn: 300,
        totalOut: 200,
      };
      setData(fetchedData);
    };
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
        <div className={styles.chartContainer}>
          <Pie data={chartData} />
        </div>
      </div>
    </div>
  );
}

export default Summarize;
