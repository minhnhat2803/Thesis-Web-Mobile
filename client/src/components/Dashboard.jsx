import React, { useRef, useCallback, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/Dashboard.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTableColumns } from "@fortawesome/free-solid-svg-icons";
import Webcam from "react-webcam";
import { scanImage, checkPosition } from "../actions";

const cx = classNames.bind(styles);

const cards = [
  {
    index: 0,
    title: "Number of cameras",
    data: 23,
    background: "#517c64, #5bbd77",
  },
  {
    index: 1,
    title: "Total plates today",
    data: 56,
    background: "#f17335, #fcbc30",
  },
  {
    index: 2,
    title: "Total plates this week",
    data: 500,
    background: "#6382c1, #4ec5d1",
  },
  {
    index: 3,
    title: "Sites",
    data: 2,
    background: "#c52034, #701033",
  },
];

function Dashboard() {
  useEffect(() => {
    const interval = setInterval(async () => {
      try {
        const res = await checkPosition();
				const position = res.data;
				console.log(position);
        if (position <= 10) {
          await capture();
        }
      } catch (err) {
        console.log(err);
      }
    }, 20000);

    return () => clearInterval(interval);
  }, []);

  const camRef = useRef(null);
  const capture = useCallback(async () => {
    const imageSrc = camRef.current.getScreenshot();
    try {
      const res = await scanImage(imageSrc);
      console.log(res.data);
      return res.data;
    } catch (err) {
      console.log(err);
    }
  }, [camRef]);

  return (
    <div className={cx("dashboard-container")}>
      <div className={cx("dashboard-left")}>
        <div className={cx("dashboard-title")}>
          <FontAwesomeIcon size="2x" icon={faTableColumns} />
          <p>Dashboard</p>
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
        {/* <div style={{ width: '100%', height: '100%', backgroundColor: 'red' }}></div> */}

        <Webcam className={cx("camera")} ref={camRef} />
        {/* <button className={cx("camera-btn")} onClick={capture}></button> */}
      </div>
    </div>
  );
}

export default Dashboard;
