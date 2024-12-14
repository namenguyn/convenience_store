import React, { useState, useEffect } from "react";
//import { NavLink } from "react-router-dom";
import axios from "axios";
import Header from "../header";
import "../../css/product/addProduct.css";
import { NavLink, useLocation } from "react-router-dom";
import Grocery from "../../img/ProductList.png";

function ShowGoodsBody(selectedRow) {
  const [goods, setGoods] = useState([]);

  useEffect(() => {
    axios
      .post("http://127.0.0.1:8000/read_lohang/id/", {
        id: selectedRow.data.MaHangHoa,
      })
      .then((response) => {
        setGoods(
          response.data["Lô hàng"].map((item) => ({
            MaHangHoa: item.MaHangHoa,
            MaLoHang: item.MaLoHang,
            SoLuongHangHoa: item.SoLuongHangHoa,
            DiaChi: item.DiaChi,
            Email: item.Email,
            MaNhaCungCap: item.MaNhaCungCap,
            SoDienThoai: item.SoDienThoai,
            Ten: item.Ten,
          }))
        );
      })
      .catch((error) => {
        if (error.response) {
          console.error("Lỗi từ server:", error.response.data);
        } else if (error.request) {
          console.error("Không nhận được phản hồi từ server:", error.request);
        } else {
          console.error("Lỗi khi cấu hình request:", error.message);
        }
      });
  }, [selectedRow]);

  return (
    <div className="body d-flex align-items-center justify-content-center">
      {goods.length > 0 && (
        <div className="add-product-body ">
          <p className="title">Xem lô hàng của hàng hóa</p>
          <form className="add-product-form row">
            <div className="col-4">
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductID">Mã hàng hóa</label>
                <input
                  type="text"
                  className="add-product-input"
                  name="id"
                  value={goods[0].MaHangHoa}
                  readOnly
                />
              </div>
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductName">Mã lô hàng</label>
                <input
                  type="text"
                  className="add-product-input"
                  name="name"
                  value={goods[0].MaLoHang}
                  readOnly
                />
              </div>
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductPrice">Số lượng hàng hóa</label>
                <input
                  type="text"
                  className="add-product-input"
                  name="price"
                  value={goods[0].SoLuongHangHoa}
                  readOnly
                />
              </div>
            </div>
            <div className="col-4">
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductType">Địa chỉ</label>
                <input
                  className="add-product-input"
                  type="text"
                  value={goods[0].DiaChi}
                  readOnly
                />
              </div>
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductUnit">Email</label>
                <input
                  className="add-product-input"
                  name="unit"
                  value={goods[0].Email}
                  type="text"
                  readOnly
                />
              </div>
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductName">Mã nhà cung cấp</label>
                <input
                  type="text"
                  className="add-product-input"
                  name="productCount"
                  value={goods[0].MaNhaCungCap}
                  readOnly
                />
              </div>
            </div>
            <div className="col-4">
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductName">Số điện thoại</label>
                <input
                  type="text"
                  className="add-product-input"
                  name="productCount"
                  value={goods[0].SoDienThoai}
                  readOnly
                />
              </div>
              <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
                <label for="ProductName">Tên nhà cung cấp</label>
                <input
                  type="text"
                  className="add-product-input"
                  name="productCount"
                  value={goods[0].Ten}
                  readOnly
                />
              </div>
            </div>

            <div className="add-product-trigger d-flex align-items-center justify-content-end">
              <NavLink
                to="/product_manage"
                className="manage-body-link d-flex justify-content-between align-items-center"
                style={{ background: "#DC143C", width: "fit-content" }}
              >
                <p>Thoát</p>
              </NavLink>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}

function ShowGoods() {
  const location = useLocation();
  const selectedRow = location.state;
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <ShowGoodsBody data={selectedRow} />
    </div>
  );
}

export default ShowGoods;

const formatPrice = (value) => {
  if (typeof value !== "string") {
    value = String(value);
  }
  return value.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
};
