import React, { useState, useEffect } from 'react';
import classNames from "classnames/bind";
import styles from "../styles/Table.module.css";
import { getAllCustomer } from '../actions';

const cx = classNames.bind(styles);

function Table() {
    const [data, setData] = useState([]);
    useEffect(() => {
        getAllCustomer().then(res => {
            if (res.status === 200) {
                const dataWithIndex = res.data.map((data, index) => {
                    return {
                        ...data,
                        createdAt: new Date(data.createdAt).toLocaleDateString(),
                        timeStamp: new Date(data.createdAt).toLocaleTimeString(),
                        index: index + 1
                    }
                })
                setData(dataWithIndex);
            }
        })
    }, [])

    return (
        <>
        {data.length == 0 ? <h1 style={{padding: '50px', textAlign: 'center', color: 'green', fontFamily: 'Oxygen'}}>No Data Available</h1> : (
            <div className={cx('table-container')}>
                <table>
                    <thead>
                        <tr>
                            <th colSpan="7">
                                <div className={cx('interact-row')}>
                                    <span className={cx('records-number')}>Records: {data.length}</span>
                                    <span className={cx('rows-number')}>No of rows in table: {data.length}</span>
                                    <select defaultValue={'Sortby'} className={cx('select-type')}>
                                        <option value="Sortby" disabled>Sort by</option>
                                        <option value="s-no">S.no</option>
                                        <option value="customerName">Customer</option>
                                        <option value="plate-no">Plate No.</option>
                                        <option value="date">Date</option>
                                        <option value="time-stamp">TimeStamp</option>
                                        <option value="site">Site</option>
                                    </select>
                                    <button className={cx('export-btn')}>Export Excel</button>
                                </div>
                            </th>
                        </tr>
                        <tr className={cx('header')}>
                            <td>S.no</td>
                            <td>Customer</td>
                            <td>Plate No.</td>
                            <td>Site</td>
                            <td>Date</td>
                            <td>Timestamp</td>
                        </tr>
                    </thead>
                    <tbody>
                        {data.map(data => (
                            <tr key={data.index}>
                                <td>{data.index}</td>
                                <td>{data.phoneNumber}</td>
                                <td>{data.plateNo}</td>
                                <td>{data.site}</td>
                                <td>{data.createdAt}</td>
                                <td>{data.timeStamp}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        )}
        </>
    );
}

export default Table;
