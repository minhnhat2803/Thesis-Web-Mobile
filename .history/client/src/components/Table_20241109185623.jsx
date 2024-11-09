import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/Table.module.css";
import { db } from "../"; // Đảm bảo bạn đã cấu hình Firebase
import { collection, getDocs } from "firebase/firestore";
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import { FiRefreshCcw } from "react-icons/fi";

const cx = classNames.bind(styles);

function Table() {
  const [data, setData] = useState([]);
  const [refresh, setRefresh] = useState(false);

  useEffect(() => {
    const fetchUsers = async () => {
      const usersCollection = collection(db, "users");
      const userSnapshot = await getDocs(usersCollection);
      const userData = userSnapshot.docs.map((doc, index) => {
        const data = doc.data();
        return {
          index: index + 1,
          email: data.email || "N/A",
          userLicensePlate: data.userLicensePlate || "N/A",
          createdAt: data.createdAt ? new Date(data.createdAt.seconds * 1000).toLocaleDateString() : "N/A",
          timeStamp: data.createdAt ? new Date(data.createdAt.seconds * 1000).toLocaleTimeString() : "N/A",
          userAvatar: data.userAvatar || "",
          bill: data.bill || 0,
        };
      });
      setData(userData);
    };

    fetchUsers();
  }, [refresh]);

  const exportToExcel = () => {
    const workbook = XLSX.utils.book_new();
    const worksheet = XLSX.utils.json_to_sheet(data);

    XLSX.utils.book_append_sheet(workbook, worksheet, "UsersData");

    const excelBuffer = XLSX.write(workbook, {
      bookType: "xlsx",
      type: "array",
    });
    const blob = new Blob([excelBuffer], {
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    });
    saveAs(blob, "UsersData.xlsx");
  };

  const refreshData = () => {
    setRefresh(!refresh);
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
                <th colSpan="7">
                  <div className={cx("interact-row")}>
                    <span className={cx("records-number")}>
                      Records: {data.length}
                    </span>
                    <button className={cx("export-btn")} onClick={exportToExcel}>
                      Export to Excel
                    </button>
                    <button className={cx("refresh-btn")} onClick={refreshData}>
                      <FiRefreshCcw />
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
              {data.map((user) => (
                <tr key={user.index}>
                  <td>{user.index}</td>
                  <td>{user.email}</td>
                  <td>{user.userLicensePlate}</td>
                  <td>{user.createdAt}</td>
                  <td>{user.bill === 0 ? "Not parking" : user.timeStamp}</td>
                  <td>
                    <img
                      src={user.userAvatar}
                      alt="Avatar"
                      style={{
                        width: "100px",
                        height: "100px",
                        borderRadius: 8,
                      }}
                    />
                  </td>
                  <td>{user.bill === 0 ? "0 VND" : `${user.bill.fee} VND`}</td>
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
