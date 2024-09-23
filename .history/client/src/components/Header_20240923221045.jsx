import React from "react";
import classNames from "classnames/bind";
import styles from "../styles/Header.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
    faBell,
    faCar, faCircleInfo
} from "@fortawesome/free-solid-svg-icons";

const cx = classNames.bind(styles);

function Header() {
    return (
        <div className={cx("header-container")}>
            <div className={cx("header-left")}>
                <div className={cx("header-title")}>
                    <div className={cx("sub-content")}>
                        <FontAwesomeIcon icon={faCar} />
                        <p>Administration</p>
                    </div>
                </div>
            </div>
            <div className={cx("header-right")}>
                <div className={cx("header-help")}>
                    <div className={cx("sub-content")}>
                        <FontAwesomeIcon icon={faCircleInfo} />
                        <p>Help & Support</p>
                    </div>
                </div>
                <div className={cx("header-user")}>
                    <div className={cx("sub-content")}>
                        <p>Notifications</p>
                        <FontAwesomeIcon icon={faBell} />
                    </div>
                </div>
            </div> hih
        </div>
    );
}

export default Header;
