import React from "react";
import { NavLink } from "react-router-dom";

import Header from "../js/header";
import "../css/home.css";
import ConveninceStore from "../img/Convenience-store-Vietnam-1-scaled.jpg";
function HomeBody() {
  return (
    <div className="home-body body d-flex flex-column justify-content-center align-items-center">
      <div className="home-body-background d-flex justify-content-center align-items-center">
        <NavLink
          to="/admin/manage"
          className="home-body-link d-flex justify-content-center align-items-center"
        >
          <i class="bx bxs-package"></i>
          <p>Quản lý hàng hóa</p>
        </NavLink>
      </div>
      <div className="home-body-background d-flex justify-content-center align-items-center">
        <NavLink
          to="/admin/find"
          className="home-body-link d-flex justify-content-center align-items-center"
        >
          <i class="bx bx-search-alt-2"></i>
          <p>Tìm hàng hóa</p>
        </NavLink>
      </div>
    </div>
  );
}

function Home() {
  return (
    <div
      className="web-page"
      style={{ backgroundImage: `url(${ConveninceStore})` }}
    >
      <Header />
      <HomeBody />
    </div>
  );
}

export default Home;
