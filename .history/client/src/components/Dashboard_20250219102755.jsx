import React, { useState, useEffect, useRef } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";
import { scanImage, checkPosition } from "../actions";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { motion } from "framer-motion";

const cx = classNames.bind(styles);

function Dashboard() {
    const [cameraFeeds, setCameraFeeds] = useState([]);
    const videoRefs = useRef([]); // Sử dụng useRef để quản lý thẻ <video>

    const cameraUrls = [
        "http://192.168.252.237:8081/?action=stream",
        "http://192.168.252.237:8082/?action=stream",
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

        // Khởi tạo luồng video cho từng camera
        videoRefs.current.forEach((video, index) => {
            if (video) {
                video.src = cameraUrls[index];
                video.play().catch((err) => {
                    console.error(`Failed to play camera ${index + 1}:`, err);
                });
            }
        });

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
                    <video
                        ref={(el) => (videoRefs.current[index] = el)} // Gán thẻ video vào ref
                        className={cx("camera")}
                        src={url}
                        autoPlay
                        muted
                        loop
                        controls
                        playsInline // Thêm playsInline để hỗ trợ trên mobile
                        onError={(e) => {
                            console.error(`Failed to load camera ${index + 1}:`, e);
                        }}
                    />
                    <div className={cx("camera-title")}>Camera {index + 1}</div>
                </motion.div>
            ))}
        </motion.div>
    );
}

export default Dashboard;