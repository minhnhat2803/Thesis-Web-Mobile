import React from "react";
import "..styles/pages/LayoutExample.css";

const LayoutExample = () => {
    return (
        <div className="layoutContainer">
            <div className="row">
                {[...Array(5)].map((_, index) => (
                    <div key={index} className="slot90">
                        <div className="car"></div>
                    </div>
                ))}
            </div>
            <div className="row">
                {[...Array(5)].map((_, index) => (
                    <div key={index} className="slot45">
                        <div className="car"></div>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default LayoutExample;
