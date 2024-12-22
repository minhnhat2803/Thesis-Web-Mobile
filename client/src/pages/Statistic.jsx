import React from "react";
import styles from "../styles/pages/Statistic.module.css";

const cards = [
    {
        index: 0,
        title: "Number of cameras",
        data: 2, // Replace with dynamic `cameraFeeds.length` if available
        background: "#517c64, #5bbd77",
    },
    {
        index: 1,
        title: "Total plates today",
        data: 30,
        background: "#f17335, #fcbc30",
    },
    {
        index: 2,
        title: "Total vehicles currently on " + new Date().toLocaleDateString(),
        data: 45, // Replace with dynamic `data` if available
        background: "#6382c1, #4ec5d1",
    },
    {
        index: 3,
        title: "Sites",
        data: 2,
        background: "#c52034, #701033",
    },
];

function Statistic() {
    return (
        <div className={styles.statisticContainer}>
            <h1>Statistics</h1>
            <div className={styles.functionCardsContainer}>
                {cards.map((card) => (
                    <div
                        key={card.index}
                        className={styles.cardContainer}
                        style={{
                            background: `linear-gradient(${card.background})`,
                        }}
                    >
                        <h3 className={styles.title}>{card.title}</h3>
                        <p className={styles.data}>{card.data}</p>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default Statistic;
