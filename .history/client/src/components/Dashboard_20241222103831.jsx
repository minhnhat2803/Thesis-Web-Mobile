import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";
import { scanImage, checkPosition, getAllCustomer } from "../actions";
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const cx = classNames.bind(styles);

function Dashboard() {
    const showToastInfo = (data) => {
        toast.info(data, {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 1500,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "light",
        });
    };

    const showToastSuccess = (data) => {
        toast.success(data, {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 3000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "light",
        });
    };

    const [cameraFeeds, setCameraFeeds] = useState([]);

    // URLs của camera từ Raspberry Pi
    const cameraUrls = [
        "http://192.168.2.27:8081/?action=stream", // Camera feed từ Raspberry Pi 1
        "http://192.168.2.27:8082/?action=stream", // Camera feed từ Raspberry Pi 2
    ];

    useEffect(() => {
        // Đặt URLs của camera
        setCameraFeeds(cameraUrls);
    }, []);

    // Kiểm tra khoảng cách với sensor mỗi 20 giây
    useEffect(() => {
        const interval = setInterval(async () => {
            try {
                const res = await checkPosition();
                const position = res.data;
                console.log(position);

                if (position <= 10) {
                    showToastSuccess(
                        "You are in the right position " + position + " cm"
                    );
                    await capture();
                } else {
                    showToastInfo(
                        "Your position with the sensor is " + position + " cm"
                    );
                }
            } catch (err) {
                console.log(err);
            }
        }, 20000);

        return () => clearInterval(interval);
    }, []);

    // Thay thế webcam bằng luồng từ Raspberry Pi
    const capture = async () => {
        try {
            const res = await scanImage(
                "http://192.168.1.5:8080/?action=stream"
            );
            console.log(res.data);
            return res.data;
        } catch (err) {
            console.log(err);
        }
    };

    return (
        <div className={cx("dashboard-container")}>
            <div className={cx("dashboard-right")}>
                {/* Hiển thị luồng camera từ Raspberry Pi */}
                {cameraFeeds.map((url, index) => (
                    <div key={index} className={cx("camera-container")}>
                        <img
                            className={cx("camera")}
                            src={url}
                            alt={`Raspberry Pi Camera Stream ${index + 1}`}
                        />
                    </div>
                ))}
            </div>
        </div>
    );
}

export default Dashboard;
