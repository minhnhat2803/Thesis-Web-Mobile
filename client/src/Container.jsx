import React from "react";
import TabBar from "./components/TabBar";
import styles from "./styles/Container.module.css";
import classNames from "classnames/bind";
import Header from "./components/Header";
import Content from "./components/Dashboard";

const cx = classNames.bind(styles);

function App() {
  return (
    <div className={cx("container")}>
      <div className={cx("dashboard-container")}>
        <TabBar />
        <div className={cx("main-content")}>
          <Header />
          <Content />
        </div>
      </div>
    </div>
  );
}

export default App;
