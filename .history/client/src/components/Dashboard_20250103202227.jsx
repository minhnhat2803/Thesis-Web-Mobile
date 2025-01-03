import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";
import { scanImage, checkPosition } from "../actions";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { motion } from "framer-motion";

const cx = classNames.bind(styles);

function Dashboard() {
    const [cameraFeeds, setCameraFeeds] = useState([]);
    const cameraUrls = [
        "http://192.168.2.27:8081/?action=stream",
        "http://192.168.2.27:8082/?action=stream",
        "http://192.168.2.27:8082/?action=stream",
    ];

    const showToastInfo = (data) => {
        toast.info(data, {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 1500,
            theme: "light",
        });
    };

    const showToastSuccess = (data) => {
        toast.success(data, {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 3000,
            theme: "light",
        });
    };

    const capture = async () => {
        try {
            const res = await scanImage("http://192.168.1.5:8080/?action=stream");
            console.log(res.data);
            return res.data;
        } catch (err) {
            console.error(err);
        }
    };

    useEffect(() => {
        setCameraFeeds(cameraUrls);

        const interval = setInterval(async () => {
            try {
                const res = await checkPosition();
                const position = res.data;

                if (position <= 10) {
                    showToastSuccess(`You are in the right position (${position} cm)`);
                    await capture();
                } else {
                    showToastInfo(`Your position with the sensor is ${position} cm`);
                }
            } catch (err) {
                console.error(err);
            }
        }, 20000);

        return () => clearInterval(interval);
    }, []);

    return (
        <motion.div
            className={cx("dashboard-container")}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
        >
            {cameraFeeds.map((url, index) => (
                <motion.div
                    key={index}
                    className={cx("camera-container")}
                    whileHover={{ scale: 1.05 }}
                    transition={{ duration: 0.3 }}
                >
                    <img
                        className={cx("camera")}
                        src={url}
                        alt={`Camera Stream ${index + 1}`}
                    />
                    <div className={cx("camera-title")}>Camera {index + 1}</div>
                </motion.div>
            ))}
        </motion.div>
    );
}

export default Dashboard;
