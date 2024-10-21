import React, { useEffect, useState } from "react";
import styles from "../styles/pages/Camera.module.css";

const Camera = () => {
    const [cameraFeeds, setCameraFeeds] = useState([]);

    // Replace with the actual MJPG-Streamer URL
    const cameraUrls = [
        "http://192.168.1.5:8080/?action=stream", // MJPG-Streamer feed from Raspberry Pi
    ];

    useEffect(() => {
        // Set the camera feed URLs
        setCameraFeeds(cameraUrls);
    }, []);

    return (
        <div>
            {/* <h1>Camera Feeds</h1> */}
            <div className={styles.cameraContainer}>
                {cameraFeeds.map((url, index) => (
                    <div key={index} className={styles.cameraFeed}>
                        <h2 className={styles.cameraTitle}>
                            Camera {index + 1}
                        </h2>
                        <img
                            className={styles.cameraVideo}
                            src={url}
                            alt={`Camera ${index + 1}`}
                        />
                    </div>
                ))}
            </div>
        </div>
    );
};

export default Camera;
