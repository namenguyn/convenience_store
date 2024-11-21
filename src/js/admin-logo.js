import React from "react";
import { NavLink } from "react-router-dom";

import "../css/admin-logo.css";

function AdminLogo() {
  return (
    <div className="admin-logo">
      <NavLink
        to="/admin/info"
        className="logo-link d-flex align-items-center justify-content-center"
      >
        <i className="bx bx-user-circle"></i>
        <p className="admin-name">Phát</p>
      </NavLink>
    </div>
  );
}

export default AdminLogo;
