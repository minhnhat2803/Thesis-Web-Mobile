import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTableColumns } from "@fortawesome/free-solid-svg-icons";
import { scanImage, checkPosition } from "../actions"; // Giả định bạn có hàm scanImage để lấy ảnh từ camera
import { toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { db, storage } from "../";

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
      theme: "light",
    });
  };

  const [data, setData] = useState([]);
  const [cameraFeeds, setCameraFeeds] = useState([]);

  const cameraUrls = [
    "http://192.168.1.5:8080/?action=stream",
  ];

  useEffect(() => {
    setCameraFeeds(cameraUrls);

    // Lấy dữ liệu xe từ Firestore
    const fetchVehicles = async () => {
      const snapshot = await db.collection("Vehicles").get();
      const vehiclesData = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setData(vehiclesData);
    };
    fetchVehicles();
  }, []);

  // Kiểm tra vị trí mỗi 20 giây
  useEffect(() => {
    const interval = setInterval(async () => {
      try {
        const res = await checkPosition();
        const position = res.data;

        if (position <= 10) {
          showToastSuccess("You are in the right position " + position + " cm");
          await capture();
        } else {
          showToastInfo("Your position with the sensor is " + position + " cm");
        }
      } catch (err) {
        console.log(err);
      }
    }, 20000);

    return () => clearInterval(interval);
  }, []);

  // Hàm chụp và lưu dữ liệu vào Firestore
  const capture = async () => {
    try {
      const imageBlob = await scanImage("http://192.168.1.5:8080/stream"); // Giả định hàm scanImage trả về blob hình ảnh
      const licensePlate = "Biển số giả định"; // Bạn có thể thay thế bằng hàm nhận diện biển số thực tế
      
      // Upload ảnh lên Firebase Storage
      const fileName = `vehicle_images/${Date.now()}.jpg`;
      const imageRef = storage.ref(fileName);
      await imageRef.put(imageBlob);
      const imageUrl = await imageRef.getDownloadURL();

      // Lưu thông tin vào Firestore
      await db.collection("Vehicles").add({
        licensePlate,
        imageUrl,
        entryTime: firebase.firestore.FieldValue.serverTimestamp(),
        slotNumber: Math.floor(Math.random() * 100) + 1, // Số slot giả định
      });
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
      data: data.length,
      background: "#f17335, #fcbc30",
    },
    {
      index: 2,
      title: "Total vehicles currently on " + new Date().toLocaleDateString(),
      data: data.length,
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
        {cameraFeeds.map((url, index) => (
          <div key={index} className={cx("camera-container")}>
            <h2>Camera {index + 1}</h2>
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
