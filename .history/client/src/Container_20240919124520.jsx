import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import TabBar from "./components/TabBar";
import styles from "./styles/Container.module.css";
import classNames from "classnames/bind";
import Header from "./components/Header";
import Content from "./components/Dashboard";
import Table from "./components/Table";
import Setting from "./pages/Setting";
import Profile from "./pages/Profile";
import Cash from "./pages/Cash";
import Camera from "./pages/Camera";
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const cx = classNames.bind(styles);

function App() {
  return (
    <Router>
      <div className={cx("container")}>
        <ToastContainer />
        <div className={cx("dashboard-container")}>
          <TabBar />
          <div className={cx("main-content")}>
            <Routes>
              <Route path="/dashboard" element={<><Header /><Content /><Table /></>} />
              <Route path="/setting" element={<Setting />} />
              <Route path="/profile" element={<Profile />} />
              <Route path="/cash" element={<Cash />} />
              <Route path="/camera" element={<Camera />} />
            </Routes>
          </div>
        </div>
      </div>
    </Router>
  );
}

export default App;
