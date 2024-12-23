import React, { useState, useEffect } from "react";
import classNames from "classnames/bind";
import styles from "../styles/Table.module.css";
import { db } from "../config/firebase";
import {
    collection,
    getDocs,
    deleteDoc,
    doc,
    updateDoc,
    query,
    where,
} from "firebase/firestore";
import * as XLSX from "xlsx";
import { saveAs } from "file-saver";
import { FiRefreshCcw, FiTrash2, FiEdit2 } from "react-icons/fi"; // Import edit icon

const cx = classNames.bind(styles);

function Table() {
    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(true);
    const [editingItem, setEditingItem] = useState(null); // State to hold the item being edited
    const [availableSlots, setAvailableSlots] = useState([]); // State to hold available slots
    const [notification, setNotification] = useState(""); // State to hold the notification message
    const [showNotification, setShowNotification] = useState(false); // State to manage notification visibility

    // Fetch data from Firebase Firestore and update the state
    const fetchLicensePlates = async () => {
        console.log("Refreshing data...");
        const licenseCollection = collection(db, "license_plates");
        const licenseSnapshot = await getDocs(licenseCollection);
        const licenseData = licenseSnapshot.docs.map((doc, index) => {
            const data = doc.data();
            return {
                id: doc.id,
                index: index + 1,
                slotID: data.slot_id || "N/A",
                licensePlate: data.license_plate || "N/A",
                timeIn: data.entry_time || "N/A",
                imageUrl: data.image_url || "",
            };
        });
        setData(licenseData);
    };

    // Fetch available slots from Firebase Firestore
    const fetchAvailableSlots = async () => {
        const slotsCollection = collection(db, "parking_slots");
        const q = query(slotsCollection, where("status", "==", "available"));
        const slotsSnapshot = await getDocs(q);
        const slotsData = slotsSnapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data(),
        }));
        setAvailableSlots(slotsData);
    };

    const deleteSlot = async (id, slotID) => {
        try {
            console.log(`Deleting slot with ID: ${id} and slotID: ${slotID}`);
            // Delete the document from the license_plates collection
            await deleteDoc(doc(db, "license_plates", id));
            console.log(`Deleted document with ID: ${id} from license_plates`);

            // Update the corresponding slot in the parking_slots collection
            const slotDoc = doc(db, "parking_slots", slotID);
            await updateDoc(slotDoc, {
                license_plate: null,
                status: "available",
            });
            console.log(`Updated slot with ID: ${slotID} to available`);

            fetchLicensePlates(); // Refresh data after deletion
            showNotificationMessage("Delete Successfully");
        } catch (error) {
            console.error("Error deleting document: ", error);
        }
    };

    const updateSlot = async (updatedItem) => {
        try {
            console.log(`Updating slot with ID: ${updatedItem.id}`);

            // Fetch the original slot ID before updating
            const originalItem = data.find(
                (item) => item.id === updatedItem.id
            );
            const originalSlotID = originalItem.slotID;

            // Update the document in the license_plates collection
            await updateDoc(doc(db, "license_plates", updatedItem.id), {
                slot_id: updatedItem.slotID,
                license_plate: updatedItem.licensePlate,
                entry_time: updatedItem.timeIn,
                image_url: updatedItem.imageUrl,
            });
            console.log(
                `Updated document with ID: ${updatedItem.id} in license_plates`
            );

            // Update the original slot in the parking_slots collection
            if (originalSlotID !== updatedItem.slotID) {
                const originalSlotDoc = doc(
                    db,
                    "parking_slots",
                    originalSlotID
                );
                await updateDoc(originalSlotDoc, {
                    license_plate: null,
                    status: "available",
                });
                console.log(
                    `Updated original slot with ID: ${originalSlotID} to available`
                );
            }

            // Update the new slot in the parking_slots collection
            const newSlotDoc = doc(db, "parking_slots", updatedItem.slotID);
            await updateDoc(newSlotDoc, {
                license_plate: updatedItem.licensePlate,
                status: "occupied",
            });
            console.log(
                `Updated slot with ID: ${updatedItem.slotID} in parking_slots`
            );

            fetchLicensePlates(); // Refresh data after update
            setEditingItem(null); // Close the edit form
            showNotificationMessage("Update Data Successfully");
        } catch (error) {
            console.error("Error updating document: ", error);
        }
    };

    const showNotificationMessage = (message) => {
        setNotification(message);
        setShowNotification(true);
        setTimeout(() => {
            setShowNotification(false);
        }, 3000); // Hide notification after 3 seconds
    };

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

    useEffect(() => {
        fetchLicensePlates(); // Fetch data when the component first mounts
        fetchAvailableSlots(); // Fetch available slots when the component first mounts

        const interval = setInterval(() => {
            fetchLicensePlates(); // Refresh data every 2 seconds
        }, 2000);

        // Cleanup the interval on component unmount
        return () => clearInterval(interval);
    }, []);

    useEffect(() => {
        const timer = setTimeout(() => {
            setLoading(false);
        }, 3000); // Show loader for 3 seconds

        return () => clearTimeout(timer); // Cleanup timer on component unmount
    }, []);

    return (
        <>
            {loading ? (
                <div className={cx("loader")}>
                    <span className={cx("bar")}></span>
                    <span className={cx("bar")}></span>
                    <span className={cx("bar")}></span>
                </div>
            ) : (
                <div className={cx("table-container")}>
                    <table>
                        <thead>
                            <tr>
                                <th colSpan="5">
                                    <div className={cx("interact-row")}>
                                        <span className={cx("records-number")}>
                                            Records: {data.length}
                                        </span>
                                        <div className={cx("button-group")}>
                                            <button
                                                className={cx(
                                                    "download-button"
                                                )}
                                                onClick={exportToExcel}
                                            >
                                                <div className={cx("docs")}>
                                                    <svg
                                                        viewBox="0 0 24 24"
                                                        width="20"
                                                        height="20"
                                                        stroke="currentColor"
                                                        strokeWidth="2"
                                                        fill="none"
                                                        strokeLinecap="round"
                                                        strokeLinejoin="round"
                                                        className="css-i6dzq1"
                                                    >
                                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                                        <polyline points="14 2 14 8 20 8"></polyline>
                                                        <line
                                                            x1="16"
                                                            y1="13"
                                                            x2="8"
                                                            y2="13"
                                                        ></line>
                                                        <line
                                                            x1="16"
                                                            y1="17"
                                                            x2="8"
                                                            y2="17"
                                                        ></line>
                                                        <polyline points="10 9 9 9 8 9"></polyline>
                                                    </svg>
                                                    Excel
                                                </div>
                                                <div className={cx("download")}>
                                                    <svg
                                                        viewBox="0 0 24 24"
                                                        width="24"
                                                        height="24"
                                                        stroke="currentColor"
                                                        strokeWidth="2"
                                                        fill="none"
                                                        strokeLinecap="round"
                                                        strokeLinejoin="round"
                                                        className="css-i6dzq1"
                                                    >
                                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                                        <polyline points="7 10 12 15 17 10"></polyline>
                                                        <line
                                                            x1="12"
                                                            y1="15"
                                                            x2="12"
                                                            y2="3"
                                                        ></line>
                                                    </svg>
                                                </div>
                                            </button>
                                            <button
                                                className={cx("refresh-btn")}
                                                onClick={fetchLicensePlates} // Manual refresh button
                                            >
                                                <FiRefreshCcw />
                                            </button>
                                        </div>
                                    </div>
                                </th>
                            </tr>
                            <tr className={cx("header")}>
                                <td>Slot number</td>
                                <td>License Plate</td>
                                <td>Image</td>
                                <td>Time in</td>
                                <td>Actions</td>
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
                                    <td>{item.timeIn}</td>
                                    <td>
                                        <button
                                            className={cx("edit-button")}
                                            onClick={() => setEditingItem(item)}
                                        >
                                            <FiEdit2 size={20} />
                                        </button>
                                        <button
                                            className={cx("delete-button")}
                                            onClick={() =>
                                                deleteSlot(item.id, item.slotID)
                                            }
                                        >
                                            <FiTrash2 size={20} />
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    {editingItem && (
                        <div className={cx("edit-form")}>
                            <h2>Edit Slot</h2>
                            <form
                                onSubmit={(e) => {
                                    e.preventDefault();
                                    updateSlot(editingItem);
                                }}
                            >
                                <label>
                                    Slot ID:
                                    <select
                                        value={editingItem.slotID}
                                        onChange={(e) =>
                                            setEditingItem({
                                                ...editingItem,
                                                slotID: e.target.value,
                                            })
                                        }
                                    >
                                        {availableSlots.map((slot) => (
                                            <option
                                                key={slot.id}
                                                value={slot.id}
                                            >
                                                {slot.id}
                                            </option>
                                        ))}
                                    </select>
                                </label>
                                <label>
                                    License Plate:
                                    <input
                                        type="text"
                                        value={editingItem.licensePlate}
                                        onChange={(e) =>
                                            setEditingItem({
                                                ...editingItem,
                                                licensePlate: e.target.value,
                                            })
                                        }
                                    />
                                </label>
                                <label>
                                    Time In:
                                    <input
                                        type="text"
                                        value={editingItem.timeIn}
                                        onChange={(e) =>
                                            setEditingItem({
                                                ...editingItem,
                                                timeIn: e.target.value,
                                            })
                                        }
                                    />
                                </label>
                                <label>
                                    Image URL:
                                    <input
                                        type="text"
                                        value={editingItem.imageUrl}
                                        onChange={(e) =>
                                            setEditingItem({
                                                ...editingItem,
                                                imageUrl: e.target.value,
                                            })
                                        }
                                    />
                                </label>
                                <button
                                    type="submit"
                                    className={cx("update-button")}
                                >
                                    Update
                                </button>
                                <button
                                    type="button"
                                    className={cx("cancel-button")}
                                    onClick={() => setEditingItem(null)}
                                >
                                    Cancel
                                </button>
                            </form>
                        </div>
                    )}
                    <div
                        className={`${cx("notification")} ${
                            showNotification ? cx("show") : ""
                        }`}
                    >
                        {notification}
                    </div>
                </div>
            )}
        </>
    );
}

export default Table;
