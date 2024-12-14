import React, { useState } from "react";
//import { NavLink } from "react-router-dom";
import axios from "axios";

import Header from "../header";
import "../../css/product/addProduct.css";
import { NavLink, useNavigate, useLocation } from "react-router-dom";
import Grocery from "../../img/ProductList.png";

function AddProductBody(merchandise) {
  const [productID, setProductID] = useState("");
  const [name, setName] = useState("");
  const [price, setPrice] = useState();
  const [type, setType] = useState("");
  const [unit, setUnit] = useState("");
  const [productCount, setProductCount] = useState();

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

  const [priceWithDot, setPriceWithDot] = useState("");
  const formatPrice = (value) => {
    return value.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  };
  const handlePrice = (e) => {
    const value = e.target.value.replace(/\./g, "");
    if (!isNaN(value)) {
      console.log(value);
      setPrice(value);
      setPriceWithDot(formatPrice(value));
    }
  };

  const navigate = useNavigate();
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!productID || !name || !price || !type || !unit || !productCount) {
      alert("Bạn chưa nhập đủ thông tin hàng hóa");
    } else {
      if (window.confirm("Bạn có chắc chắn muốn thêm hàng hóa này không?")) {
        axios
          .post(`http://127.0.0.1:8000/create_one_HangHoa/`, {
            Ma_hang_hoa: productID,
            Ten: name,
            Gia: parseFloat(price),
            MaLoai: typeAndUnit.find((typeID) => typeID.TenLoai === type)
              .MaLoai,
            SoLuongConLai: productCount,
            DonViTinh: unit,
          })
          .then((response) => {
            console.log(response.data);
            alert("Đã thêm thành công");
            navigate("/product_manage");
          })
          .catch((error) => {
            console.error("Lỗi", error);
            alert(`Thêm hàng hóa thất bại: ${error.response.data.message}`);
          });
      }
    }
  };

  return (
    <div className="body d-flex flex-column align-items-center justify-content-center ">
      <div className="add-product-body">
        <p className="title">Thêm hàng hóa</p>
        <form className="add-product-form row d-flex" onSubmit={handleSubmit}>
          <div className="col-6">
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductID">Mã hàng hóa</label>
              <input
                type="text"
                maxLength="7"
                className="add-product-input"
                name="product-id"
                placeholder="VD: UN12345"
                value={productID}
                onChange={(e) => setProductID(e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Tên</label>
              <input
                type="text"
                className="add-product-input"
                name="name"
                placeholder="VD: Ca rot"
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductPrice">Giá</label>
              <input
                type="text"
                className="add-product-input"
                name="price"
                placeholder="VD: 8.000"
                value={priceWithDot}
                onChange={handlePrice}
              />
              <div className="unit" style={{ width: "fit-content" }}>
                VND
              </div>
            </div>
          </div>
          <div className="col-6">
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductType">Loại</label>
              <select
                className="add-product-input"
                name="type"
                placeholder="VD: Loai 1"
                value={type}
                onChange={(e) => setType(e.target.value)}
              >
                <option value="">--Chọn loại--</option>
                {typeAndUnit.map((arr) => (
                  <option value={arr.TenLoai}>{arr.TenLoai}</option>
                ))}
              </select>
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductUnit">Đơn vị tính</label>
              <select
                className="add-product-input"
                name="unit"
                placeholder="VD: kg, g, hop, chai,..."
                value={unit}
                onChange={(e) => setUnit(e.target.value)}
              >
                <option value="">--Chọn đơn vị tính--</option>
                {type &&
                  typeAndUnit
                    .find((item) => item.TenLoai === type)
                    .DonViTinh.map((a) => <option value={a}>{a}</option>)}
              </select>
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Số lượng còn lại</label>
              <input
                type="text"
                className="add-product-input"
                name="name"
                placeholder="VD: 100"
                value={productCount}
                onChange={(e) => setProductCount(e.target.value)}
              />
            </div>
          </div>
          <div className="add-product-trigger d-flex align-items-center justify-content-end">
            <NavLink
              to="/product_manage"
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
                class="bx bx-cart-add"
                style={{ marginRight: "0.4em", fontSize: "1.2em" }}
              ></i>
              <p style={{ marginBottom: "0" }}>Thêm hàng hóa</p>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

function AddProduct() {
  const location = useLocation();
  const products = location.state;
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <AddProductBody data={products} />
    </div>
  );
}

export default AddProduct;
