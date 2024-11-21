import React from "react";
// import { NavLink } from "react-router-dom";

import HCMUT from "./hcmut";
import AdminLogo from "./admin-logo";
import "../css/header.css";

function Header() {
  return (
    <div className="header d-flex justify-content-between align-items-center">
      <HCMUT />
      <AdminLogo />
    </div>
  );
}

export default Header;
