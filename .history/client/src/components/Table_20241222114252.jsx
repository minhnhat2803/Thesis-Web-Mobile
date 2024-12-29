import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/Table.module.css";
import { db } from "../config/firebase";
import { collection, getDocs } from "firebase/firestore";
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import { FiRefreshCcw } from "react-icons/fi";

const cx = classNames.bind(styles);

function Table() {
  const [data, setData] = useState([]);
  const [refresh, setRefresh] = useState(false);
  const fetchLicensePlates = async () => {
    console.log("Refreshing data...");
    const licenseCollection = collection(db, "licensePlates");
    const licenseSnapshot = await getDocs(licenseCollection);
    const licenseData = licenseSnapshot.docs.map((doc, index) => {
      const data = doc.data();
      return {
        index: index + 1,
        slotID: data.slotID || "N/A",
        licensePlate: data.licensePlate || "N/A",
        timeIN: data.timeIN || "N/A",
        imageUrl: data.imageUrl || "",
      };
    });
    setData(licenseData);
  };
  useEffect(() => {
    fetchLicensePlates();
    const interval = setInterval(() => {
      fetchLicensePlates();
    }, 2000);
    return () => clearInterval(interval);
  }, []);

  const exportToExcel = () => {
    const workbook = XLSX.utils.book_new();
    const worksheet = XLSX.utils.json_to_sheet(data);
    XLSX.utils.book_append_sheet(workbook, worksheet, "LicensePlates");

    const excelBuffer = XLSX.write(workbook, {
      bookType: "xlsx",
      type: "array",
    });
    const blob = new Blob([excelBuffer], {
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    });
    saveAs(blob, "LicensePlates.xlsx");
  };

  return (
    <>
      {data.length === 0 ? (
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
                <th colSpan="4">
                  <div className={cx("interact-row")}>
                    <span className={cx("records-number")}>
                      Records: {data.length}
                    </span>
                    <button
                      className={cx("export-btn")}
                      onClick={exportToExcel}
                    >
                      Export to Excel
                    </button>
                    <button
                      className={cx("refresh-btn")}
                      onClick={fetchLicensePlates} 
                      <FiRefreshCcw />
                    </button>
                  </div>
                </th>
              </tr>
              <tr className={cx("header")}>
                <td>Slot number</td>
                <td>License Plate</td>
                <td>Image</td>
                <td>Time in</td>
              </tr>
            </thead>
            <tbody>
              {data.map((item) => (
                <tr key={item.index}>
                  <td>{item.slotID}</td>
                  <td>{item.licensePlate}</td>
                  <td>
                    <img
                      src={item.imageUrl}
                      alt="License Plate"
                      style={{
                        width: "100px",
                        height: "100px",
                        borderRadius: 8,
                      }}
                    />
                  </td>
                  <td>{item.timeIN}</td>
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