import React from "react";
import { NavLink } from "react-router-dom";

import "../css/tool/admin-logo.css";

function AdminLogo() {
  return (
    <div className="admin-logo">
      <NavLink
        to="/info"
        className="logo-link d-flex align-items-center justify-content-center"
      >
        <i className="bx bx-user-circle"></i>
        <p className="admin-name">Admin</p>
      </NavLink>
    </div>
  );
}

export default AdminLogo;
