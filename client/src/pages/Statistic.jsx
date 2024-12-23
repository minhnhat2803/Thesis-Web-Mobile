import React, { useState, useEffect } from "react";
import styles from "../styles/pages/Statistic.module.css";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";

const Statistic = () => {
    const [totalVehiclesToday, setTotalVehiclesToday] = useState(0);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const today = new Date();
                today.setHours(0, 0, 0, 0); // Set to the start of the day
                const tomorrow = new Date(today);
                tomorrow.setDate(today.getDate() + 1); // Set to the start of the next day

                console.log("Fetching data from:", today, "to:", tomorrow);

                const querySnapshot = await getDocs(
                    collection(db, "license_plates")
                );
                const filteredData = querySnapshot.docs.filter((doc) => {
                    const entryTime = doc.data().entry_time;
                    const entryDate = new Date(
                        entryTime.split(" ")[1].split("/").reverse().join("-") +
                            "T" +
                            entryTime.split(" ")[0]
                    );
                    return entryDate >= today && entryDate < tomorrow;
                });

                console.log("Fetched data:", filteredData.length);
                setTotalVehiclesToday(filteredData.length);
            } catch (error) {
                console.error("Error fetching data:", error);
            }
        };

        fetchData();
        const interval = setInterval(fetchData, 2000);

        return () => clearInterval(interval);
    }, []);

    const cards = [
        {
            index: 0,
            title: "Number of cameras",
            data: 2,
            background: "#517c64, #5bbd77",
        },
        {
            index: 1,
            title: "Total plates today",
            data: totalVehiclesToday * 2,
            background: "#f17335, #fcbc30",
        },
        {
            index: 2,
            title:
                "Total vehicles currently on " +
                new Date().toLocaleDateString(),
            data: totalVehiclesToday, // Use the state value
            background: "#6382c1, #4ec5d1",
        },
        {
            index: 3,
            title: "Sites",
            data: 1,
            background: "#c52034, #701033",
        },
    ];

    return (
        <div className={styles.statisticContainer}>
            <h1>Statistics</h1>
            <div className={styles.functionCardsContainer}>
                {cards.map((card) => (
                    <div
                        key={card.index}
                        className={styles.functionCard}
                        style={{
                            background: `linear-gradient(${card.background})`,
                        }}
                    >
                        <h2 className={styles.title}>{card.title}</h2>
                        <p className={styles.data}>{card.data}</p>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default Statistic;
