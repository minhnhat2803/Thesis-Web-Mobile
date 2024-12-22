import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import TabBar from "./components/TabBar";
import styles from "./styles/Container.module.css";
import classNames from "classnames/bind";
import Content from "./components/Dashboard";
import Table from "./components/Table";
import Slots from "./pages/Slots";
import Profile from "./pages/Profile";
import Statistic from "./pages/Statistic";
import ProtectedRoute from "../src/config/ProtectedRoute"; // Import ProtectedRoute
import { AuthProvider } from "../src/config/AuthContext"; // Import AuthProvider
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const cx = classNames.bind(styles);

function App() {
    return (
        <AuthProvider>
            <Router>
                <div className={cx("container")}>
                    <ToastContainer />
                    <TabBar />
                    <div className={cx("dashboard-container")}>
                        <div className={cx("main-content")}>
                            <Routes>
                                <Route path="/profile" element={<Profile />} />
                                <Route
                                    path="/dashboard"
                                    element={
                                        <ProtectedRoute>
                                            <>
                                                <Content />
                                                <Table />
                                            </>
                                        </ProtectedRoute>
                                    }
                                />
                                <Route
                                    path="/slots"
                                    element={
                                        <ProtectedRoute>
                                            <Slots />
                                        </ProtectedRoute>
                                    }
                                />
                                <Route
                                    path="/statistic"
                                    element={
                                        <ProtectedRoute>
                                            <Statistic />
                                        </ProtectedRoute>
                                    }
                                />
                            </Routes>
                        </div>
                    </div>
                </div>
            </Router>
        </AuthProvider>
    );
}

export default App;
