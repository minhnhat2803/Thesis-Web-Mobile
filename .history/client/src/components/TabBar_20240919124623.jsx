import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import classNames from "classnames/bind";
import styles from "../styles/TabBar.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faGear,
  faTableList,
  faSignOut,
  faUser,
  faMoneyBills,
  faCamera,
} from "@fortawesome/free-solid-svg-icons";

const cx = classNames.bind(styles);

const tabs = [
  {
    index: 0,
    title: "Dashboard",
    icon: faTableList,
    path: "/dashboard", // Đường dẫn tương ứng với trang Dashboard
  },
  {
    index: 1,
    title: "Profile",
    icon: faUser,
    path: "/profile", // Đường dẫn tương ứng với trang Setting
  },
  {
    index: 2,
    title: "Camera",
    icon: faCamera,
    path: "/camera",
  },
  {
    index: 3,
    title: "Cash",
    icon: faMoneyBills,
    path: "/cash",
  },
  {
    index: 4,
    title: "Setting",
    icon: faGear,
    path: "/setting",xq
  },
  // {
  //   index: 5,
  //   title: "Logout",
  //   icon: faSignOut,
  //   path: "/logout",
  // },
];

function TabBar() {
  const [click, setClick] = useState(1);
  const navigate = useNavigate(); // Sử dụng useNavigate để điều hướng

  const handleTabClick = (index, path) => {
    setClick(index);
    navigate(path); // Điều hướng tới trang tương ứng
  };

  return (
    <div className={cx("tabBar-container")}>
      <div className={cx("logo")}>
        <img
          src="../src/assets/img/smartparking.png"
          className={cx("logo-text")}
        />
      </div>
      <div className={cx("tabs")}>
        {tabs.map((tab, index) => (
          <div
            key={index}
            onClick={() => handleTabClick(index, tab.path)} // Thêm sự kiện điều hướng
            className={cx("tabCell-container")}
            style={
              click === index
                ? { color: "#517c64", height: `calc(100% / ${tabs.length})` }
                : { color: "#82c4a0", height: `calc(100% / ${tabs.length})` }
            }
          >
            <FontAwesomeIcon size="2x" icon={tab.icon} />
            <p className={cx("tabCell-title")}>{tab.title}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default TabBar;
