import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/Table.module.css";
import { getAllCustomer } from "../actions";
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";

const cx = classNames.bind(styles);

function Table() {
  const [data, setData] = useState([]);
  useEffect(() => {
    getAllCustomer().then((res) => {
      if (res.status === 200) {
        const dataWithIndex = res.data.map((data, index) => {
          if (data.bill == null) {
            data.bill = 0;
          } else {
            data.bill = data.bill;
          }
          return {
            ...data,
            createdAt: new Date(data.createdAt).toLocaleDateString(),
            timeStamp: new Date(data.createdAt).toLocaleTimeString(),
            index: index + 1,
          };
        });
        setData(dataWithIndex);
      }
    });
  }, []);

  const exportToExcel = () => {
    const workbook = XLSX.utils.book_new();
    const worksheet = XLSX.utils.json_to_sheet(data);

    XLSX.utils.book_append_sheet(workbook, worksheet, "DataCustomers");

    const excelBuffer = XLSX.write(workbook, {
      bookType: "xlsx",
      type: "array",
    });
    const blob = new Blob([excelBuffer], {
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    });
    saveAs(blob, "ParkingData.xlsx");
  };

  return (
    <>
      {data.length == 0 ? (
        <h1
          style={{
            padding: "50px",
            textAlign: "center",
            color: "green",
            fontFamily: "Oxygen",
          }}
        >
          No Data Available
        </h1>
      ) : (
        <div className={cx("table-container")}>
          <table>
            <thead>
              <tr>
                <th colSpan="7">
                  <div className={cx("interact-row")}>
                    <span className={cx("records-number")}>
                      Records: {data.length}
                    </span>
                    <span className={cx("rows-number")}>
                      No of rows in table: {data.length}
                    </span>
                    <select
                      defaultValue={"Sortby"}
                      className={cx("select-type")}
                    >
                      <option value="Sortby" disabled>
                        Sort by
                      </option>
                      <option value="s-no">S.no</option>
                      <option value="customerName">Customer</option>
                      <option value="plate-no">Plate No.</option>
                      <option value="date">Date</option>
                      <option value="time-stamp">TimeStamp</option>
                      <option value="site">Site</option>
                    </select>
                    <button
                      className={cx("export-btn")}
                      onClick={exportToExcel}
                    >
                      Export to Excel
                    </button>
                  </div>
                </th>
              </tr>
              <tr className={cx("header")}>
                <td>S.no</td>
                <td>Email</td>
                <td>Plate No.</td>
                <td>Day Join</td>
                <td>Time in</td>
                <td>Avatar</td>
                <td>Price</td>
              </tr>
            </thead>
            <tbody>
              {data.map((data) => (
                <tr key={data.index}>
                  <td>{data.index}</td>
                  <td>{data.email}</td>
                  <td>{data.userLicensePlate}</td>
                  <td>{data.createdAt}</td>
                  <td>{data.bill == 0 ? "Not parking" : data.bill.timeIn}</td>
                  <td>
                    <img
                      src={data.userAvatar}
                      alt="plate"
                      style={{
                        width: "100px",
                        height: "100px",
                        borderRadius: 8,
                      }}
                    />
                  </td>
                  <td>
                    {data.bill == 0 ? 0 + " VND" : data.bill.fee + " VND"}
                  </td>
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
