import React, { useEffect, useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import classNames from "classnames/bind";
import styles from "../styles/TabBar.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
    faTachometerAlt,
    faUserCircle,
    faChartLine,
    faParking,
} from "@fortawesome/free-solid-svg-icons";

const cx = classNames.bind(styles);

const tabs = [
    {
        index: 0,
        title: "Dashboard",
        icon: faTachometerAlt,
        path: "/dashboard",
    },
    {
        index: 1,
        title: "Profile",
        icon: faUserCircle,
        path: "/profile",
    },
    {
        index: 2,
        title: "Statistic",
        icon: faChartLine,
        path: "/statistic",
    },
    {
        index: 3,
        title: "Slots",
        icon: faParking,
        path: "/slots",
    },
];

function TabBar() {
    const navigate = useNavigate();
    const location = useLocation();
    const [activeTab, setActiveTab] = useState(location.pathname);

    useEffect(() => {
        setActiveTab(location.pathname);
    }, [location]);

    return (
        <div className={cx("tabBar")}>
            <div className={cx("tabBar-container")}>
                {tabs.map((tab) => (
                    <div
                        key={tab.index}
                        className={cx("tabCell", {
                            active: activeTab === tab.path,
                        })}
                        onClick={() => navigate(tab.path)}
                        style={
                            activeTab === tab.path
                                ? { color: "#517c64" }
                                : { color: "#82c4a0" }
                        }
                    >
                        <div
                            className={cx(styles.icon, {
                                active: activeTab === tab.path,
                            })}
                        >
                            <FontAwesomeIcon size="2x" icon={tab.icon} />
                        </div>
                        <p
                            className={cx(styles.title, {
                                active: activeTab === tab.path,
                            })}
                        >
                            {tab.title}
                        </p>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default TabBar;
