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
    //Table của Tín
    const [data, setData] = useState([]);
    const [refresh, setRefresh] = useState(false);

    // Fetch data from Firebase Firestore and update the state
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

    // useEffect hook to refresh data every 3 seconds
    useEffect(() => {
        fetchLicensePlates(); // Fetch data when the component first mounts

        const interval = setInterval(() => {
            fetchLicensePlates(); // Refresh data every 3 seconds
        }, 2000);

        // Cleanup the interval on component unmount
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
                                            onClick={fetchLicensePlates} // Manual refresh button
                                        >
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

// function Table() { //Table của Nhật
//     const [data, setData] = useState([]);
//     const [refresh, setRefresh] = useState(false);

//     useEffect(() => {
//         const fetchLicensePlates = async () => {
//             console.log("Refreshing data..."); // Debugging: Check when data is refreshed

//             const licenseCollection = collection(db, "license-plate");
//             const licenseSnapshot = await getDocs(licenseCollection);
//             const licenseData = licenseSnapshot.docs.map((doc, index) => {
//                 const data = doc.data();
//                 return {
//                     index: index + 1,
//                     slotID: data.slotID || "N/A",
//                     licensePlate: data.licensePlate || "N/A",
//                     timeIn: data.timeIn
//                         ? new Date(data.timeIn.seconds * 1000).toLocaleString()
//                         : "N/A",
//                     imageUrl: data.imageUrl || "",
//                     status: data.status || "N/A",
//                 };
//             });

//             console.log(licenseData); // Log the fetched data
//             setData(licenseData);
//         };

//         fetchLicensePlates();
//     }, [refresh]);

//     const exportToExcel = () => {
//         const workbook = XLSX.utils.book_new();
//         const worksheet = XLSX.utils.json_to_sheet(data);

//         XLSX.utils.book_append_sheet(workbook, worksheet, "LicensePlates");

//         const excelBuffer = XLSX.write(workbook, {
//             bookType: "xlsx",
//             type: "array",
//         });
//         const blob = new Blob([excelBuffer], {
//             type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
//         });
//         saveAs(blob, "LicensePlates.xlsx");
//     };

//     const refreshData = () => {
//         setRefresh(!refresh); // Toggle the refresh state to trigger useEffect
//     };

//     return (
//         <>
//             {data.length === 0 ? (
//                 <h1
//                     style={{
//                         padding: "50px",
//                         textAlign: "center",
//                         color: "green",
//                         fontFamily: "Oxygen",
//                     }}
//                 >
//                     No Data Available
//                 </h1>
//             ) : (
//                 <div className={cx("table-container")}>
//                     <table>
//                         <thead>
//                             <tr>
//                                 <th colSpan="4">
//                                     <div className={cx("interact-row")}>
//                                         <span className={cx("records-number")}>
//                                             Records: {data.length}
//                                         </span>
//                                         <button
//                                             className={cx("export-btn")}
//                                             onClick={exportToExcel}
//                                         >
//                                             Export to Excel
//                                         </button>
//                                         <button
//                                             className={cx("refresh-btn")}
//                                             onClick={refreshData}
//                                         >
//                                             <FiRefreshCcw />
//                                         </button>
//                                     </div>
//                                 </th>
//                             </tr>
//                             <tr className={cx("header")}>
//                                 <td>Slot</td>
//                                 <td>Image</td>
//                                 <td>License Plate</td>
//                                 <td>Time In</td>
//                                 <td>Status</td>   
//                             </tr>
//                         </thead>
//                         <tbody>
//                             {data.map((item) => (
//                                 <tr key={item.index}>
//                                     <td>{item.slotID}</td>
//                                     <td>
//                                         <img
//                                             src={item.imageUrl}
//                                             alt="License Plate"
//                                             style={{
//                                                 width: "100px",
//                                                 height: "100px",
//                                                 borderRadius: 8,
//                                             }}
//                                         />
//                                     </td>
//                                     <td>{item.licensePlate}</td>  
//                                     <td>{item.timeIn}</td>
//                                     <td>{item.status}</td>
//                                 </tr>
//                             ))}
//                         </tbody>
//                     </table>
//                 </div>
//             )}
//         </>
//     );
// }
export default Table;
