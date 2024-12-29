import React, { useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faTableList,
  faUser,
  faParking,
  faChartPie,
} from "@fortawesome/free-solid-svg-icons";
import styles from "../styles/NewTabBar.module.css";

const tabs = [
  { title: "Dashboard", icon: faTableList, path: "/dashboard" },
  { title: "Profile", icon: faUser, path: "/profile" },
  { title: "Summarize", icon: faChartPie, path: "/summarize" },
  { title: "Slots", icon: faParking, path: "/slots" },
];

function TabBar() {
  const [activeTab, setActiveTab] = useState(0);
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    const currentTab = tabs.findIndex((tab) => tab.path === location.pathname);
    if (currentTab !== -1) setActiveTab(currentTab);
  }, [location.pathname]);

  const handleTabClick = (index, path) => {
    setActiveTab(index);
    navigate(path);
  };

  return (
    <div className={styles.tabBar}>
      {tabs.map((tab, index) => (
        <div
          key={index}
          className={`${styles.tab} ${
            activeTab === index ? styles.active : ""
          }`}
          onClick={() => handleTabClick(index, tab.path)}
        >
          <FontAwesomeIcon icon={tab.icon} size="lg" />
          <span>{tab.title}</span>
        </div>
      ))}
    </div>
  );
}

export default TabBar;
