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
import Summarize from "./pages/Summarize";
import ProtectedRoute from "../src/config/ProtectedRoute"; 
import { AuthProvider } from "../src/config/AuthContext"; 
import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const cx = classNames.bind(styles);

function App() {
  return (
    <AuthProvider>
      <Router>
        <div className={cx("container")}>
          <ToastContainer />
          <div className={cx("dashboard-container")}>
            <TabBar />
            <div className={cx("main-content")}>
              <Routes>
                <Route path="/profile" element={<Profile />} />
                <Route 
                  path="/dashboard" 
                  element={
                    <ProtectedRoute>
                      <>
                        <Header />
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
                  path="/summarize" 
                  element={
                    <ProtectedRoute>
                      <Summarize />
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
