import React, { useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import classNames from "classnames/bind";
import styles from "../styles/TabBar.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faTableList,
  faUser,
  faCheckToSlot,
  faChartPie,
  faChevronLeft, // Thêm icon cho nút thu/thu vào
  faChevronRight, // Thêm icon cho nút thu/thu vào
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
    icon: faChartPie,
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
  const [isCollapsed, setIsCollapsed] = useState(false); // Trạng thái thu/thu vào
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
    setIsCollapsed(!isCollapsed); // Đổi trạng thái thu/thu vào
  };

  return (
    <div className={cx("tabBar-container", { collapsed: isCollapsed })}>
      <button className={cx("toggle-button")} onClick={toggleTabBar}>
        <FontAwesomeIcon
          icon={isCollapsed ? faChevronRight : faChevronLeft}
          size="lg"
        />
      </button>
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
            {!isCollapsed && <p className={cx("tabCell-title")}>{tab.title}</p>}
          </div>
        ))}
      </div>
    </div>
  );
}

export default TabBar;
