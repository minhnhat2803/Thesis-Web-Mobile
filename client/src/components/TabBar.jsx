import React, { useState } from "react";
import classNames from "classnames/bind";
import styles from "../styles/TabBar.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faGear,
  faTableList,
  faSignOut,
} from "@fortawesome/free-solid-svg-icons";

const cx = classNames.bind(styles);

const tabs = [
  {
    index: 0,
    title: "Dashboard",
    icon: faTableList,
  },
  {
    index: 1,
    title: "Setting",
    icon: faGear,
  },
  {
    index: 2,
    title: "Logout",
    icon: faSignOut,
  },
  {
    index: 3,
    title: "Dashboard",
    icon: faTableList,
  },
  {
    index: 4,
    title: "Setting",
    icon: faGear,
  },
  {
    index: 5,
    title: "Logout",
    icon: faSignOut,
  },
];

function TabBar() {
  const [click, setClick] = useState(1)
  return (
    <div className={cx("tabBar-container")}>
      <div className={cx('logo')}>
        {/* <p className={cx('logo-text')}>IoT</p> */}
        <img
          src="../src/assets/img/iotlogo.png"
          className={cx('logo-text')} />
      </div>
      <div className={cx('tabs')}>
        {tabs.map((tab, index) => (
          <div key={index} onClick={() => setClick(index)} className={cx("tabCell-container")}
            style={click === index ?
              { color: '#517c64', height: `calc(100% / ${tabs.length})` }
              : { color: '#82c4a0', height: `calc(100% / ${tabs.length})` }}>
            <FontAwesomeIcon size="2x" icon={tab.icon} />
            <p className={cx("tabCell-title")}>{tab.title}</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default TabBar;
