import React, { useState } from "react";
//import { NavLink } from "react-router-dom";
import axios from "axios";

import Header from "../header";
import "../../css/product/addProduct.css";
import { NavLink, useNavigate, useLocation } from "react-router-dom";
import Grocery from "../../img/ProductList.png";

import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

function AddEmployeeBody(merchandise) {
  const [employeeID, setEmployeeID] = useState("");
  const [phoneNumber, setPhoneNumber] = useState("");
  const [bdate, setBDate] = useState("");
  const [startDate, setStartDate] = useState("");
  const [name, setName] = useState("");
  const [sex, setSex] = useState("");
  const [address, setAddress] = useState("");
  const [email, setEmail] = useState("");
  const [mgrssn, setMgrssn] = useState();
  const [ssn, setSSN] = useState("");

  const [typeAndUnit, setTypeAndUnit] = useState(
    Array.from(
      merchandise.data.reduce((map, product) => {
        if (!map.has(product.MaLoai)) {
          map.set(product.MaLoai, {
            MaLoai: product.MaLoai,
            TenLoai: product.TenLoai,
            DonViTinh: new Set(),
          });
        }
        map.get(product.MaLoai).DonViTinh.add(product.DonViTinh);
        return map;
      }, new Map())
    ).map(([MaLoai, { TenLoai, DonViTinh }]) => ({
      MaLoai,
      TenLoai,
      DonViTinh: Array.from(DonViTinh),
    }))
  );
  console.log(typeAndUnit);

  // const [priceWithDot, setPriceWithDot] = useState("");
  // const formatPrice = (value) => {
  //   return value.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  // };
  // const handlePrice = (e) => {
  //   const value = e.target.value.replace(/\./g, "");
  //   if (!isNaN(value)) {
  //     console.log(value);
  //     setPrice(value);
  //     setPriceWithDot(formatPrice(value));
  //   }
  // };

  const navigate = useNavigate();
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (
      !employeeID ||
      !name ||
      !phoneNumber ||
      !bdate ||
      !startDate ||
      !sex ||
      !address ||
      !email ||
      !ssn
    ) {
      alert("Bạn chưa nhập đủ thông tin nhân viên");
    } else {
      if (window.confirm("Bạn có chắc chắn muốn thêm nhân viên này không?")) {
        axios
          .post(`http://127.0.0.1:8000/addNhanVien/`, {
            MaNhanVien: employeeID,
            SoDienThoai: phoneNumber,
            NgayThangNamSinh: bdate,
            NgayBatDauLam: startDate,
            HoTen: name,
            GioiTinh: sex,
            DiaChi: address,
            Email: email,
            MaQuanLy: mgrssn,
            CanCuocCongDan: ssn,
          })
          .then((response) => {
            console.log(response.data);
            alert("Đã thêm thành công");
            navigate("/employee");
          })
          .catch((error) => {
            console.error("Lỗi", error);
            alert(
              `Thêm thông tin nhân viên thất bại: ${error.response.data.error}`
            );
          });
      }
    }
  };

  return (
    <div className="body d-flex flex-column align-items-center justify-content-center ">
      <div className="add-product-body">
        <p className="title">Thêm nhân viên</p>
        <form className="add-product-form row d-flex" onSubmit={handleSubmit}>
          <div className="col-4">
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductID">Mã nhân viên</label>
              <input
                type="text"
                maxLength="7"
                className="add-product-input"
                name="product-id"
                placeholder="VD: A123456"
                value={employeeID}
                onChange={(e) => setEmployeeID(e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Số điện thoại</label>
              <input
                type="text"
                className="add-product-input"
                name="name"
                placeholder="VD: 0123456745"
                value={phoneNumber}
                onChange={(e) => setPhoneNumber(e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductPrice">Ngày tháng năm sinh</label>
              <DatePicker
                selected={bdate}
                onChange={(e) => setBDate(e)}
                className="add-product-input"
                dateFormat="dd/MM/yyyy"
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Ngày bắt đầu làm</label>
              <DatePicker
                selected={startDate}
                minDate={bdate}
                onChange={(e) => setStartDate(e)}
                className="add-product-input"
                dateFormat="dd/MM/yyyy"
              />
            </div>
          </div>
          <div className="col-4">
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Tên</label>
              <input
                type="text"
                className="add-product-input"
                name="name"
                placeholder="VD: Nguyen Van A"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Giới tính</label>
              <div
                className="d-flex align-items-center justify-content-center"
                style={{
                  border: "1px solid rgba(0, 0, 0, 0.345);",
                  borderRadius: "20px",
                  padding: "0.5em 1.5em",
                  width: "fit-content",
                  background: "rgb(219, 235, 247)",
                }}
              >
                <label
                  className="input-choose-label"
                  style={{
                    margin: "0 3em 0 0",
                  }}
                >
                  <input
                    type="radio"
                    value="Nam"
                    className="input-choose"
                    style={{ marginRight: "0.5em" }}
                    checked={sex === "Nam"}
                    onChange={(e) => setSex(e.target.value)}
                  />
                  Nam
                </label>
                <label className="input-choose-label" style={{ margin: "0" }}>
                  <input
                    className="input-choose"
                    type="radio"
                    style={{ marginRight: "0.5em" }}
                    value="Nu"
                    checked={sex === "Nu"}
                    onChange={(e) => setSex(e.target.value)}
                  />
                  Nữ
                </label>
              </div>
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Địa chỉ</label>
              <input
                type="text"
                className="add-product-input"
                name="name"
                placeholder="VD: 123 Duong ABC, Phuong XYZ"
                value={address}
                onChange={(e) => setAddress(e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Email</label>
              <input
                type="text"
                className="add-product-input"
                name="name"
                placeholder="VD: nguyenvana@gmail.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </div>
          </div>
          <div className="col-4">
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Mã quản lý</label>
              <input
                type="text"
                maxLength="7"
                className="add-product-input"
                name="name"
                placeholder="VD: F000003"
                value={mgrssn}
                onChange={(e) => setMgrssn(e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Căn cước công dân</label>
              <input
                type="text"
                maxLength="12"
                className="add-product-input"
                name="name"
                placeholder="VD: 123456789712"
                value={ssn}
                onChange={(e) => setSSN(e.target.value)}
              />
              <p
                style={{ marginBottom: "0", fontSize: "0.9em", color: "blue" }}
              >
                Căn cước công dân có 12 chữ số
              </p>
            </div>
          </div>

          <div className="add-product-trigger d-flex align-items-center justify-content-end">
            <NavLink
              to="/employee"
              className="manage-body-link d-flex justify-content-between align-items-center"
              style={{ background: "#DC143C", width: "fit-content" }}
            >
              <p>Hủy bỏ</p>
            </NavLink>
            <button
              type="submit"
              className="add-body-button d-flex justify-content-center align-items-center"
            >
              <i
                class="bx bxs-user-plus"
                style={{ marginRight: "0.4em", fontSize: "1.2em" }}
              ></i>
              <p style={{ marginBottom: "0" }}>Thêm nhân viên</p>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

function AddEmployee() {
  const location = useLocation();
  const employee = location.state;
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <AddEmployeeBody data={employee} />
    </div>
  );
}

export default AddEmployee;
