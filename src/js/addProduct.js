import React from "react";
//import { NavLink } from "react-router-dom";

import Header from "../js/header";
import "../css/addProduct.css";
import { NavLink } from "react-router-dom";
import Grocery from "../img/GroceryBackground.jpg";

function AddProductBody() {
  return (
    <div className="add-product-body body d-flex flex-column align-items-center justify-content-start ">
      <p className="title">Thêm hàng hóa</p>
      <form className="add-product-form">
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductID">Mã hàng hóa</label>
          <input
            type="text"
            maxLength="7"
            className="add-product-input"
            name="product-id"
            placeholder="VD: UN12345"
            required
          />
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductName">Tên</label>
          <input
            type="text"
            className="add-product-input"
            name="name"
            placeholder="VD: Ca rot"
            required
          />
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductPrice">Giá</label>
          <input
            type="text"
            className="add-product-input"
            name="price"
            placeholder="VD: 8000"
            required
          />
          <div className="unit">VND</div>
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductType">Loại</label>
          <input
            type="text"
            className="add-product-input"
            name="type"
            placeholder="VD: Loai 1"
            required
          />
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductUnit">Đơn vị tính</label>
          <input
            type="text"
            className="add-product-input"
            name="unit"
            placeholder="VD: kg, g, hop, chai,..."
            required
          />
        </div>
        <div className="add-product-trigger d-flex align-items-center justify-content-between">
          <NavLink
            to="/admin/manage"
            className="manage-body-link d-flex justify-content-between align-items-center"
            style={{ background: "#DC143C", width: "fit-content" }}
          >
            <p>Hủy bỏ</p>
          </NavLink>
          <button
            type="submit"
            className="manage-body-button d-flex justify-content-center align-items-center"
          >
            <i class="bx bx-cart-add"></i>
            <p>Thêm hàng hóa</p>
          </button>
        </div>
      </form>
    </div>
  );
}

function AddProduct() {
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <AddProductBody />
    </div>
  );
}

export default AddProduct;
