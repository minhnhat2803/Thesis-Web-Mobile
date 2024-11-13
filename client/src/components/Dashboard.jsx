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

    // URLs của camera từ Raspberry Pi
    const cameraUrls = [
        "http://192.168.1.4:8080/?action=stream", // Camera feed từ Raspberry Pi
    ];

    useEffect(() => {
        // Lấy dữ liệu từ API (tổng số lượng khách hàng)
        getAllCustomer().then((res) => {
            if (res.status === 200) {
                setData(res.data.length);
            }
        });

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
                "http://192.168.1.4:8080/?action=stream"
            );
            console.log(res.data);
            return res.data;
        } catch (err) {
            console.log(err);
        }
    };

    const cards = [
        {
            index: 0,
            title: "Number of cameras",
            data: cameraFeeds.length,
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
            title:
                "Total vehicles currently on " +
                new Date().toLocaleDateString(),
            data: data,
            background: "#6382c1, #4ec5d1",
        },
        {
            index: 3,
            title: "Sites",
            data: 2,
            background: "#c52034, #701033",
        },
    ];

    return (
        <div className={cx("dashboard-container")}>
            <div className={cx("dashboard-left")}>
                <div className={cx("dashboard-title")}>
                    <FontAwesomeIcon size="2x" icon={faTableColumns} />
                    <p>Statistics</p>
                </div>
                <div className={cx("function-cards-container")}>
                    {cards.map((card, index) => (
                        <div
                            key={index}
                            style={{
                                background: `linear-gradient(to bottom right, ${card.background})`,
                            }}
                            className={cx("card-container")}
                        >
                            <p className={cx("title")}>{card.title}</p>
                            <p className={cx("data")}>{card.data}</p>
                        </div>
                    ))}
                </div>
            </div>
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
