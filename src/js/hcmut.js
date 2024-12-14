import React from "react";
import hcmut from "../img/logo.png";
import { NavLink } from "react-router-dom";
import "../css/tool/hcmut.css";

function HCMUT() {
  return (
    <div
      className="HCMUT d-flex justify-content-left align-items-left"
      id="HCMUT-id"
    >
      <div className="HCMUT-logo">
        <img src={hcmut} alt="HCMUT" className="HCMUT-logo__img" />
      </div>
      <div className="HCMUT-slogan d-flex align-items-left flex-column justify-content-center">
        <NavLink to="/" className="HCMUT-slogan-nav-link">
          <p className="line1">Trường Đại học Bách Khoa - ĐHQG TP.HCM</p>
          <p>Cửa hàng tiện lợi</p>
        </NavLink>
      </div>
    </div>
  );
}

export default HCMUT;
