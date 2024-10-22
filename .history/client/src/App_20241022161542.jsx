import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import TabBar from "./components/TabBar";
import styles from "./styles/Container.module.css";
import classNames from "classnames/bind";
import Header from "./components/Header";
import Content from "./components/Dashboard";
import Table from "./components/Table";
import Slots from "./pages/Slots";
import Profile from "./pages/Profile";
import Cash from "./pages/Cash";
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
              <Route path="/slots" element={<Slots />} />
              <Route path="/profile" element={<Profile />} />
              <Route path="/cash" element={<Cash />} />
              {/* <Auth />
            <span> </span> */}
            </Routes>
          </div>
        </div>
      </div>
    </Router>
  );
}

export default App;
