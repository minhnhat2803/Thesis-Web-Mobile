import React, { useState, useEffect } from "react";
import { useNavigate, useLocation } from "react-router-dom";
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
  faCheckToSlot,
  faBars, // Biểu tượng 3 dấu gạch ngang
} from "@fortawesome/free-solid-svg-icons";

const cx = classNames.bind(styles);

const tabs = [
  {
    index: 0,
    title: "Dashboard",
    icon: faTableList,
    path: "/dashboard",
  },
  {
    index: 1,
    title: "Profile",
    icon: faUser,
    path: "/profile",
  },
  {
    index: 2,
    title: "Summarize",
    icon: faMoneyBills,
    path: "/summarize",
  },
  {
    index: 3,
    title: "Slots",
    icon: faCheckToSlot,
    path: "/slots",
  },
];

function TabBar() {
  const [click, setClick] = useState(0);
  const [isOpen, setIsOpen] = useState(false); // Trạng thái mở/đóng TabBar
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const currentTab = tabs.findIndex((tab) => tab.path === location.pathname);
    if (currentTab !== -1) {
      setClick(currentTab);
    }
  }, [location.pathname]);

  const handleTabClick = (index, path) => {
    setClick(index);
    navigate(path);
  };

  const toggleTabBar = () => {
    setIsOpen(!isOpen); // Chuyển đổi trạng thái TabBar
  };

  return (
    <div className={cx("tabBar-container", { open: isOpen })}>
      <div className={cx("toggle-button")} onClick={toggleTabBar}>
        <FontAwesomeIcon size="2x" icon={faBars} />
      </div>
      <div className={cx("logo")}>
        <img
          src="../src/assets/img/iotlogo.png"
          className={cx("logo-text")}
        />
      </div>
      <div className={cx("tabs")}>
        {tabs.map((tab, index) => (
          <div
            key={index}
            onClick={() => handleTabClick(index, tab.path)}
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
