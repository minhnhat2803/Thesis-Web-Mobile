import React from "react";
import classNames from "classnames/bind";
import styles from "../styles/Table.module.css";


const cx = classNames.bind(styles);

const fakeData = [
    {
        sNo: 1,
        plateNo: 123456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 2,
        plateNo: 213456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.59.16',
        site: 'Ha Noi'
    },
    {
        sNo: 3,
        plateNo: 456556,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '14.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 4,
        plateNo: "59A70B",
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '17.59.16',
        site: 'Da Nang'
    },
    {
        sNo: 5,
        plateNo: 189856,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.12.16',
        site: 'Tra Vinh'
    },
    {
        sNo: 6,
        plateNo: 1555456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.19.42',
        site: 'Thanh Hoa'
    },
    {
        sNo: 1,
        plateNo: 123456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 2,
        plateNo: 213456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.59.16',
        site: 'Ha Noi'
    },
    {
        sNo: 3,
        plateNo: 456556,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '14.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 4,
        plateNo: "59A70B",
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '17.59.16',
        site: 'Da Nang'
    },
    {
        sNo: 5,
        plateNo: 189856,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.12.16',
        site: 'Tra Vinh'
    },
    {
        sNo: 6,
        plateNo: 1555456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.19.42',
        site: 'Thanh Hoa'
    },
    {
        sNo: 1,
        plateNo: 123456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 2,
        plateNo: 213456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.59.16',
        site: 'Ha Noi'
    },
    {
        sNo: 3,
        plateNo: 456556,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '14.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 4,
        plateNo: "59A70B",
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '17.59.16',
        site: 'Da Nang'
    },
    {
        sNo: 5,
        plateNo: 189856,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.12.16',
        site: 'Tra Vinh'
    },
    {
        sNo: 6,
        plateNo: 1555456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.19.42',
        site: 'Thanh Hoa'
    },
    {
        sNo: 1,
        plateNo: 123456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 2,
        plateNo: 213456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.59.16',
        site: 'Ha Noi'
    },
    {
        sNo: 3,
        plateNo: 456556,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '14.59.16',
        site: 'Ho Chi Minh City'
    },
    {
        sNo: 4,
        plateNo: "59A70B",
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '17.59.16',
        site: 'Da Nang'
    },
    {
        sNo: 5,
        plateNo: 189856,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '20.12.16',
        site: 'Tra Vinh'
    },
    {
        sNo: 6,
        plateNo: 1555456,
        plateType: 'Commercial',
        date: '13.4.2023',
        timeStamp: '22.19.42',
        site: 'Thanh Hoa'
    },
]

function Table() {
    return (
        <div className={cx('table-container')}>
            <table>
                <thead>
                    <tr>
                        <th colspan="7">
                            <div className={cx('interact-row')}>
                                <span className={cx('records-number')}>3600 records</span>
                                <span className={cx('rows-number')}>No of rows in table: X</span>
                                <select className={cx('select-type')}>
                                    <option value="" disabled selected>Sort by</option>
                                    <option value="s-no">S.no</option>
                                    <option value="plate-no">Plate No.</option>
                                    <option value="plate-type">Plate type</option>
                                    <option value="date">Date</option>
                                    <option value="time-stamp">TimeStamp</option>
                                    <option value="site">Site</option>
                                </select>
                                <button className={cx('export-btn')}>Export Excel</button>
                            </div>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr className={cx('header')}>
                        <td>S.no</td>
                        <td>Plate No.</td>
                        <td>Plate type</td>
                        <td>Date</td>
                        <td>Timestamp</td>
                        <td>Site</td>
                        <td>Image</td>
                    </tr>
                    {fakeData.map(data => (
                        <tr>
                            <td>{data.sNo}</td>
                            <td>{data.plateNo}</td>
                            <td>{data.plateType}</td>
                            <td>{data.date}</td>
                            <td>{data.timeStamp}</td>
                            <td>{data.site}</td>
                            <td>No img</td>
                        </tr>
                    ))}
                </tbody>
            </table>

        </div>
    );
}

export default Table;
