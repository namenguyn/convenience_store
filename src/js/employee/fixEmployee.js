import React, { useState, useEffect } from "react";
//import { NavLink } from "react-router-dom";
import axios from "axios";
import Header from "../header";
import "../../css/product/addProduct.css";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import Grocery from "../../img/ProductList.png";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

function FixEmployeeBody(selectedRow) {
  const navigate = useNavigate();
  const [employee, setEmployee] = useState(selectedRow.data);

  useEffect(() => {
    if (selectedRow && selectedRow.data) {
      setEmployee(selectedRow.data);
    }
  }, [selectedRow]);

  const handleChange = (name, value) => {
    setEmployee((prevEmployee) => ({
      ...prevEmployee,
      [name]: value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (window.confirm("Bạn có chắc chắn muốn sửa nhân viên này không?")) {
      axios
        .post(`http://127.0.0.1:8000/updateNhanVien/`, {
          MaNhanVien: employee.employeeID,
          SoDienThoai: employee.phoneNumber,
          NgayThangNamSinh: employee.bdate,
          NgayBatDauLam: employee.startDate,
          HoTen: employee.name,
          GioiTinh: employee.sex,
          DiaChi: employee.address,
          Email: employee.email,
          MaQuanLy: employee.mgrssn,
          CanCuocCongDan: employee.ssn,
        })
        .then((response) => {
          console.log(response.data);
          alert("Đã cập nhật thành công");
          navigate("/employee");
        })
        .catch((error) => {
          console.error("Error updating product:", error);
          alert(
            `Sửa thông tin hàng hóa thất bại: ${error.response.data.error}`
          );
        });
    }
  };

  return (
    <div className="body d-flex align-items-center justify-content-center">
      <div className="add-product-body ">
        <p className="title">Sửa thông tin nhân viên</p>
        <form className="add-product-form row" onSubmit={handleSubmit}>
          <div className="col-4">
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductID">Mã nhân viên</label>
              <input
                type="text"
                maxLength="7"
                className="add-product-input"
                name="employeeID"
                placeholder="VD: A123456"
                value={employee.employeeID}
                onChange={(employeeID) =>
                  handleChange("employeeID", employeeID.target.value)
                }
                readOnly
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Số điện thoại</label>
              <input
                type="text"
                className="add-product-input"
                name="phoneNumber"
                placeholder="VD: 0123456745"
                value={employee.phoneNumber}
                onChange={(phoneNumber) =>
                  handleChange("phoneNumber", phoneNumber.target.value)
                }
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductPrice">Ngày tháng năm sinh</label>
              <DatePicker
                selected={employee.bdate}
                onChange={(date) => handleChange("bdate", date)}
                className="add-product-input"
                dateFormat="dd/MM/yyyy"
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Ngày bắt đầu làm</label>
              <DatePicker
                name
                selected={employee.startDate}
                minDate={employee.bdate}
                onChange={(date) => handleChange("startDate", date)}
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
                value={employee.name}
                onChange={(name) => handleChange("name", name.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Giới tính</label>
              <div
                className="d-flex align-items-center justify-content-center"
                style={{
                  border: "1px solid black",
                  borderRadius: "20px",
                  padding: "0.5em 1.5em",
                  width: "fit-content",
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
                    name="sex"
                    value="Nam"
                    className="input-choose"
                    style={{ marginRight: "0.5em" }}
                    checked={employee.sex === "Nam"}
                    onChange={(sex) => handleChange("sex", sex.target.value)}
                  />
                  Nam
                </label>
                <label className="input-choose-label" style={{ margin: "0" }}>
                  <input
                    className="input-choose"
                    name="sex"
                    type="radio"
                    style={{ marginRight: "0.5em" }}
                    value="Nu"
                    checked={employee.sex === "Nu"}
                    onChange={(sex) => handleChange("sex", sex.target.value)}
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
                name="address"
                placeholder="VD: 123 Duong ABC, Phuong XYZ"
                value={employee.address}
                onChange={(address) =>
                  handleChange("address", address.target.value)
                }
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Email</label>
              <input
                type="text"
                className="add-product-input"
                name="email"
                placeholder="VD: nguyenvana@gmail.com"
                value={employee.email}
                onChange={(email) => handleChange("email", email.target.value)}
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
                name="mgrssn"
                placeholder="VD: F000003"
                value={employee.mgrssn}
                onChange={(mgrssn) =>
                  handleChange("mgrssn", mgrssn.target.value)
                }
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Căn cước công dân</label>
              <input
                type="text"
                maxLength="12"
                className="add-product-input"
                name="ssn"
                placeholder="VD: 123456789712"
                value={employee.ssn}
                onChange={(ssn) => handleChange("ssn", ssn.target.value)}
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
                class="bx bx-wrench"
                style={{ marginRight: "0.5em", fontSize: "1.2em" }}
              ></i>
              <p style={{ marginBottom: "0" }}>Sửa thông tin</p>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

function FixEmployee() {
  const location = useLocation();
  const selectedRow = location.state;
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <FixEmployeeBody data={selectedRow} />
    </div>
  );
}

export default FixEmployee;
