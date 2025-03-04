import React, { useState, useEffect, useRef } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { motion } from "framer-motion";

const cx = classNames.bind(styles);

function Dashboard() {
    const [cameraFeeds, setCameraFeeds] = useState([]);
    const cameraUrls = [
        "http://192.168.78.255:8081/?action=stream",
        "http://192.168.78.255:8082/?action=stream",
    ];

    // Sử dụng useRef để lưu trữ tham chiếu đến thẻ <img> của camera 2
    const camera2Ref = useRef(null);

    useEffect(() => {
        setCameraFeeds(cameraUrls);

        // Thiết lập interval để làm mới luồng video của camera 2 mỗi 5 giây
        const interval = setInterval(() => {
            if (camera2Ref.current) {
                // Làm mới bằng cách thêm timestamp vào URL để tránh cache
                const url = new URL(cameraUrls[1]);
                url.searchParams.set("t", Date.now());
                camera2Ref.current.src = url.toString();
            }
        }, 5000); // Làm mới mỗi 5 giây

        // Dọn dẹp interval khi component unmount
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
                        ref={index === 1 ? camera2Ref : null} // Gán ref cho camera 2
                        className={cx("camera")}
                        src={url}
                        alt={`Camera Stream ${index + 1}`}
                        onError={(e) => {
                            console.error(`Failed to load camera ${index + 1}:`, e);
                            toast.error(`Camera ${index + 1} is not available`);
                        }}
                    />
                    <div className={cx("camera-title")}>Camera {index + 1}</div>
                </motion.div>
            ))}
        </motion.div>
    );
}

export default Dashboard;