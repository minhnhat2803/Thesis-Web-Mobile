import React, { useState, useEffect, useRef } from "react";
import classNames from "classnames/bind";
import styles from "../styles/pages/Dashboard.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTableColumns } from "@fortawesome/free-solid-svg-icons";
import { checkPosition, getAllCustomer } from "../actions";
import { toast } from "react-toastify";
import Webcam from "react-webcam"; // Import Webcam từ react-webcam
import "react-toastify/dist/ReactToastify.css";

const cx = classNames.bind(styles);

function Dashboard() {
  const [data, setData] = useState([]);
  const [plateInfo, setPlateInfo] = useState([]);
  const webcamRef = useRef(null); // Ref để truy cập webcam

  useEffect(() => {
    getAllCustomer().then((res) => {
      if (res.status === 200) {
        setData(res.data.length);
      }
    });
  }, []);

  useEffect(() => {
    const interval = setInterval(async () => {
      try {
        const res = await checkPosition();
        const position = res.data;
        console.log(position);

        if (position <= 10) {
          showToastSuccess("You are in the right position " + position + " cm");
          const plateData = await capture(); // Gọi hàm capture để lấy thông tin biển số
          if (plateData) {
            setPlateInfo((prev) => [...prev, plateData]); // Cập nhật biển số mới vào danh sách
          }
        } else {
          showToastInfo("Your position with the sensor is " + position + " cm");
        }
      } catch (err) {
        console.log(err);
      }
    }, 20000);

    return () => clearInterval(interval);
  }, []);

  const capture = async () => {
    try {
      const imageSrc = webcamRef.current.getScreenshot(); // Chụp ảnh từ webcam
      // Ở đây, bạn có thể gửi imageSrc đến API nhận diện biển số
      const res = await scanImage(imageSrc); // Giả sử scanImage nhận hình ảnh từ webcam
      console.log(res.data);
      return res.data; // Trả về dữ liệu biển số
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <div className={cx("dashboard-container")}>
      <div className={cx("dashboard-left")}>
        <div className={cx("dashboard-title")}>
          <FontAwesomeIcon size="2x" icon={faTableColumns} />
          <p>Statistics</p>
        </div>
        {/* Hiển thị các thẻ thống kê */}
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
        {/* Hiển thị thông tin biển số đã nhận diện */}
        <div className={cx("plate-info-container")}>
          <h3>Recognized Plates</h3>
          <ul>
            {plateInfo.map((plate, index) => (
              <li key={index}>Plate: {plate.number} - Time: {plate.time}</li>
            ))}
          </ul>
        </div>
      </div>
      <div className={cx("dashboard-right")}>
        <div className={cx("camera-container")}>
          <h2>Webcam Feed</h2>
          <Webcam
            ref={webcamRef}
            className={cx("camera")}
            screenshotFormat="image/jpeg"
            width={640}
            height={480}
          />
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
