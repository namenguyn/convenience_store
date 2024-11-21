import React, { useState, useEffect } from "react";
//import { NavLink } from "react-router-dom";

import Header from "../js/header";
import "../css/addProduct.css";
import { NavLink, useLocation } from "react-router-dom";
import Grocery from "../img/GroceryBackground.jpg";

function FixProductBody(selectedRow) {
  const [product, setProduct] = useState(selectedRow.data);

  useEffect(() => {
    if (selectedRow) {
      setProduct(selectedRow);
    }
  }, [selectedRow]);

  const handleChange = (e) => {
    const { name, value } = e.target.value;
    setProduct((prevProduct) => ({
      ...prevProduct,
      [name]: value,
    }));
  };

  return (
    <div className="add-product-body body d-flex flex-column align-items-center justify-content-start ">
      <p className="title">Sửa hàng hóa</p>
      <form className="add-product-form">
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductID">Mã hàng hóa</label>
          <input
            type="text"
            maxLength="7"
            className="add-product-input"
            name="product-id"
            value={product.id}
            onChange={handleChange}
            readOnly
          />
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductName">Tên</label>
          <input
            type="text"
            className="add-product-input"
            name="name"
            value={product.name}
            onChange={handleChange}
          />
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductPrice">Giá</label>
          <input
            type="text"
            className="add-product-input"
            name="price"
            value={product.price}
            onChange={handleChange}
          />
          <div className="unit">VND</div>
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductType">Loại</label>
          <input
            type="text"
            className="add-product-input"
            name="type"
            value={product.type}
            onChange={handleChange}
          />
        </div>
        <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
          <label for="ProductUnit">Đơn vị tính</label>
          <input
            type="text"
            className="add-product-input"
            name="unit"
            value={product.unit}
            onChange={handleChange}
          />
        </div>
        <div className="add-product-trigger d-flex align-items-center justify-content-between">
          <NavLink
            to="/admin/manage/fix_choose"
            className="manage-body-link d-flex justify-content-between align-items-center"
            style={{ background: "#DC143C", width: "fit-content" }}
          >
            <p>Hủy bỏ</p>
          </NavLink>
          <button
            type="submit"
            className="manage-body-button d-flex justify-content-center align-items-center"
          >
            <i class="bx bx-wrench"></i>
            <p>Sửa hàng hóa</p>
          </button>
        </div>
      </form>
    </div>
  );
}

function FixProduct() {
  const location = useLocation();
  const selectedRow = location.state;
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <FixProductBody data={selectedRow} />
    </div>
  );
}

export default FixProduct;
