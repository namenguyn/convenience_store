import React from "react";
import hcmut from "../img/hcmut.png";
import { NavLink } from "react-router-dom";
import "../css/hcmut.css";

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
        <NavLink to="/admin" className="HCMUT-slogan-nav-link">
          <p className="line1">Trường Đại học Bách Khoa - ĐHQG TP.HCM</p>
          <p>Convenience Store</p>
        </NavLink>
      </div>
    </div>
  );
}

export default HCMUT;
