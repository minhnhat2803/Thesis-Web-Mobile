import React, { useEffect, useState } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";

const cx = classNames.bind(styles);

function Dashboard() {
    const [cameraFeeds, setCameraFeeds] = useState([
        "http://192.168.2.16:8081/?action=stream",
        "http://192.168.2.16:8082/?action=stream",
    ]);

    useEffect(() => {
        const interval = setInterval(() => {
            setCameraFeeds((prevFeeds) => [
                `${prevFeeds[0]}?${new Date().getTime()}`, // Add a timestamp to force reload
                `${prevFeeds[1]}?${new Date().getTime()}`, // Add a timestamp to force reload
            ]);
        }, 5000); // Refresh every 5 seconds

        return () => clearInterval(interval); // Cleanup interval on component unmount
    }, []);

    const handleImageError = (index) => {
        console.log(`Camera ${index + 1} feed failed to load, reloading...`);
        setCameraFeeds((prevFeeds) => [
            ...prevFeeds.slice(0, index),
            `${prevFeeds[index]}?${new Date().getTime()}`, // Add a timestamp to force reload
            ...prevFeeds.slice(index + 1),
        ]);
    };

    return (
        <div className={cx("dashboard-container")}>
            <div className={cx("camera-frame")}>
                <div className={cx("camera-left")}>
                    <div className={cx("camera-overlay")}>
                        <p className={cx("camera-name")}>Camera 1 - In</p>
                    </div>
                    <img
                        className={cx("camera")}
                        src={cameraFeeds[0]}
                        alt="Camera 1 Stream"
                        onError={() => handleImageError(0)}
                    />
                </div>
                <div className={cx("camera-right")}>
                    <div className={cx("camera-overlay")}>
                        <p className={cx("camera-name")}>Camera 2 - Out</p>
                    </div>
                    <img
                        className={cx("camera")}
                        src={cameraFeeds[1]}
                        alt="Camera 2 Stream"
                        onError={() => handleImageError(1)}
                    />
                </div>
            </div>
        </div>
    );
}

export default Dashboard;
