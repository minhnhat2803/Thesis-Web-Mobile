import React from "react";
import TabBar from "./components/TabBar";
import styles from "./styles/Container.module.css";
import classNames from "classnames/bind";
import Header from "./components/Header";
import Content from "./components/Dashboard";
import Table from "./components/Table";
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const cx = classNames.bind(styles);

function App() {
  return (
    <div className={cx("container")}>
      <ToastContainer />
      <div className={cx("dashboard-container")}>
        <TabBar />
        <div className={cx("main-content")}>
          <Header />
          <Content />
          <Table />
        </div>
      </div>
    </div>
  );
}

export default App;
