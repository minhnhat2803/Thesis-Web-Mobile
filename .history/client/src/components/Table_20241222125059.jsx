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
  const [selectedImage, setSelectedImage] = useState(null);

  const fetchLicensePlates = async () => {
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
    }, 5000);
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

  const openImageModal = (imageUrl) => {
    setSelectedImage(imageUrl);
  };

  const closeImageModal = () => {
    setSelectedImage(null);
  };

  return (
    <div className={cx("table-container")}>
      {data.length === 0 ? (
        <h1 className={cx("no-data")}>No Data Available</h1>
      ) : (
        <>
          <div className={cx("interact-row")}>
            <span className={cx("records-number")}>Records: {data.length}</span>
            <button className={cx("export-btn")} onClick={exportToExcel}>
              Export to Excel
            </button>
            <button className={cx("refresh-btn")} onClick={fetchLicensePlates}>
              <FiRefreshCcw />
            </button>
          </div>
          <table className={cx("custom-table")}>
            <thead>
              <tr>
                <th>Slot Location</th>
                <th>License Plate</th>
                <th>License Plate Image</th>
                <th>Activity</th>
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
                      className={cx("table-image")}
                      onClick={() => openImageModal(item.imageUrl)}
                    />
                  </td>
                  <td>{item.timeIN}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}

      {selectedImage && (
        <>
          <div
            className={cx("image-modal-overlay", { active: selectedImage })}
            onClick={closeImageModal}
          />
          <div className={cx("image-modal", { active: selectedImage })}>
            <img src={selectedImage} alt="Zoomed License Plate" />
          </div>
        </>
      )}
    </div>
  );
}

export default Table;
