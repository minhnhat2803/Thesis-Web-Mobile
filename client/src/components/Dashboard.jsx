import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTableColumns } from "@fortawesome/free-solid-svg-icons";
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

    const [data, setData] = useState([]);
    const [cameraFeeds, setCameraFeeds] = useState([]);

    // URLs of camera feeds from Raspberry Pi
    const cameraUrls = [
        "http://192.168.1.5:8081/?action=stream", // Camera 1
        "http://192.168.1.5:8082/?action=stream", // Camera 2
    ];

    useEffect(() => {
        // Fetch total customer data
        getAllCustomer().then((res) => {
            if (res.status === 200) {
                setData(res.data.length);
            }
        });

        // Set camera URLs
        setCameraFeeds(cameraUrls);
    }, []);

    // Check position every 20 seconds
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
            <div className={cx("dashboard-title")}>
                <FontAwesomeIcon size="2x" icon={faTableColumns} />
                <p>Camera Feeds</p>
            </div>
            <div className={cx("camera-frame")}>
                <div className={cx("camera-left")}>
                    <div className={cx("camera-overlay")}>
                        <p className={cx("camera-name")}>Camera 1 - In</p>
                    </div>
                    <img
                        className={cx("camera")}
                        src={cameraFeeds[0]}
                        alt="Camera 1 Stream"
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
                    />
                </div>
            </div>
        </div>
    );
}

export default Dashboard;
