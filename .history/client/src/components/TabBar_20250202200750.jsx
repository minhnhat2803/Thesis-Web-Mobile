import React, { useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import classNames from "classnames/bind";
import styles from "../styles/TabBar.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faTableList,
  faUser,
  faParking,
  faChartPie,
  faChevronLeft,
  faChevronRight,
} from "@fortawesome/free-solid-svg-icons";
import { motion } from "framer-motion";

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
    icon: faParking,
    path: "/slots",
  },
];

function TabBar() {
  const [click, setClick] = useState(0);
  const [isCollapsed, setIsCollapsed] = useState(false);
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
    setIsCollapsed(!isCollapsed);
  };

  return (
    <div className={cx("tabBar-container", { collapsed: isCollapsed })}>
      <motion.div
        className={cx("toggle-container")}
        onClick={toggleTabBar}
        whileHover={{ scale: 1.2, rotate: 10 }}
        whileTap={{ scale: 0.9 }}
      >
        <FontAwesomeIcon
          icon={isCollapsed ? faChevronRight : faChevronLeft}
          size="lg"
        />
      </motion.div>

      <div className={cx("tabs")}>
        {tabs.map((tab, index) => (
          <motion.div
            key={index}
            onClick={() => handleTabClick(index, tab.path)}
            className={cx("tabCell-container", { active: click === index })}
            whileHover={{
              scale: 1.1,
              backgroundColor: "rgba(255, 255, 255, 0.2)",
            }}
            whileTap={{ scale: 0.95 }}
            style={{
              height: `calc(100% / ${tabs.length})`,
            }}
          >
            <FontAwesomeIcon size="2x" icon={tab.icon} />
            {!isCollapsed && (
              <motion.p
                className={cx("tabCell-title")}
                initial={{ opacity: 0, x: -10 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.2 }}
              >
                {tab.title}
              </motion.p>
            )}
          </motion.div>
        ))}
      </div>
    </div>
  );
}

export default TabBar;
