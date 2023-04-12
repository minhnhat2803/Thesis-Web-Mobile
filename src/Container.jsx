import React from "react";
import TabBar from "./Components/TabBar";
import styles from "./Style/Container.module.css";
import classNames from "classnames/bind";
import Header from "./Components/Header";
import Content from "./Components/Dashboard";

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
