import React, { useRef, useCallback } from "react";
import classNames from "classnames/bind";
import styles from "../styles/Dashboard.module.css";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
    faTableColumns
} from "@fortawesome/free-solid-svg-icons";
import Webcam from "react-webcam";
import { scanImage } from "../actions";

const cx = classNames.bind(styles);

const cards = [
    {
        title: 'Number of cameras',
        data: 23,
        background: '#517c64, #5bbd77'
    },
    {
        title: 'Total plates today',
        data: 56,
        background: '#f17335, #fcbc30'
    },
    {
        title: 'Total plates this week',
        data: 500,
        background: '#6382c1, #4ec5d1'
    },
    {
        title: 'Sites',
        data: 2,
        background: '#c52034, #701033'
    },
]

function Dashboard() {
    const camRef = useRef(null)
    const capture = useCallback(async () => {
        const imageSrc = camRef.current.getScreenshot();
        scanImage(imageSrc)
            .then(res => {
                console.log(res.data);
            })
            .catch(err => {
                console.log(err);
            })
    }, [camRef]);
    return (
        <div className={cx('dashboard-container')}>
            <div className={cx('dashboard-left')}>
                <div className={cx('dashboard-title')}>
                    <FontAwesomeIcon size="2x" icon={faTableColumns} />
                    <p>Dashboard</p>
                </div>
                <div className={cx('function-cards-container')}>
                    {cards.map((card, index) => (
                        <div style={{ background: `linear-gradient(to bottom right, ${card.background})` }} className={cx('card-container')}>
                            <p className={cx('title')}>{card.title}</p>
                            <p className={cx('data')}>{card.data}</p>
                        </div>
                    ))}
                </div>
            </div>
            <div className={cx('dashboard-right')}>
                <Webcam className={cx('camera')} ref={camRef} />
                <button className={cx('camera-btn')} onClick={capture}></button>
            </div>
        </div>
    );
}

export default Dashboard;
