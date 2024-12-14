import React, { useState, useEffect } from "react";
//import { NavLink } from "react-router-dom";
import axios from "axios";
import Header from "../header";
import "../../css/product/addProduct.css";
import { NavLink, useLocation, useNavigate } from "react-router-dom";
import Grocery from "../../img/ProductList.png";

function FixProductBody(selectedRow) {
  const navigate = useNavigate();

  const [product, setProduct] = useState(selectedRow.data);
  const [productPrice, setProductPrice] = useState(product.Gia);
  const [priceWithDot, setPriceWithDot] = useState(formatPrice(productPrice));

  const [typeAndUnit, setTypeAndUnit] = useState([]);

  useEffect(() => {
    axios
      .get("http://127.0.0.1:8000/read_all_HangHoa/")
      .then((response) => {
        if (Array.isArray(response.data.HangHoa)) {
          setTypeAndUnit(
            Array.from(
              response.data.HangHoa.reduce((map, product) => {
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
        } else {
          console.error("Dữ liệu không phải là mảng");
        }
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
  }, []);

  useEffect(() => {
    if (selectedRow && selectedRow.data) {
      setProduct(selectedRow.data);
      setProductPrice(selectedRow.data.Gia);
      setPriceWithDot(formatPrice(selectedRow.data.Gia));
    }
  }, [selectedRow]);

  const handleChange = (name, value) => {
    setProduct((prevProduct) => ({
      ...prevProduct,
      [name]: value,
    }));
  };

  const handlePrice = (e) => {
    const value = e.target.value.replace(/\./g, "");
    if (!isNaN(value)) {
      setProductPrice(value);
      setPriceWithDot(formatPrice(value));
      setProduct((prevProduct) => ({
        ...prevProduct,
        Gia: value,
      }));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log(product);
    if (window.confirm("Bạn có chắc chắn muốn sửa hàng hóa này không?")) {
      axios
        .post(`http://127.0.0.1:8000/update_one_HangHoa/`, {
          Ma_hang_hoa: product.MaHangHoa,
          Ten: product.Ten,
          Gia: parseFloat(product.Gia),
          MaLoai: typeAndUnit.find(
            (typeID) => typeID.TenLoai === product.TenLoai
          ).MaLoai,
          DonViTinh: product.DonViTinh,
          SoLuongConLai: product.SoLuongConLai,
        })
        .then((response) => {
          console.log(response.data);
          alert("Cập nhật thành công");
          navigate("/product_manage");
        })
        .catch((error) => {
          console.error("Error updating product:", error);
          alert(
            `Cập nhật thông tin hàng hóa thất bại: ${error.response.data.message}`
          );
        });
    }
  };

  return (
    <div className="body d-flex align-items-center justify-content-center">
      <div className="add-product-body ">
        <p className="title">Sửa hàng hóa</p>
        <form className="add-product-form row" onSubmit={handleSubmit}>
          <div className="col-6">
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductID">Mã hàng hóa</label>
              <input
                type="text"
                maxLength="7"
                className="add-product-input"
                name="id"
                value={product.MaHangHoa}
                onChange={(e) => handleChange("MaHangHoa", e.target.value)}
                readOnly
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Tên</label>
              <input
                type="text"
                className="add-product-input"
                name="name"
                value={product.Ten}
                onChange={(e) => handleChange("Ten", e.target.value)}
              />
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductPrice">Giá</label>
              <input
                type="text"
                className="add-product-input"
                name="price"
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
                value={product.TenLoai}
                onChange={(e) => handleChange("TenLoai", e.target.value)}
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
                value={product.DonViTinh}
                onChange={(e) => handleChange("DonViTinh", e.target.value)}
              >
                <option value="">--Chọn đơn vị tính--</option>
                {product.TenLoai &&
                  typeAndUnit
                    .find((item) => item.TenLoai === product.TenLoai)
                    ?.DonViTinh.map((unit) => (
                      <option key={unit} value={unit}>
                        {unit}
                      </option>
                    ))}
              </select>
            </div>
            <div className="add-product-content d-flex flex-column align-items-left justify-content-center">
              <label for="ProductName">Số lượng còn lại</label>
              <input
                type="text"
                className="add-product-input"
                name="productCount"
                placeholder="VD: 100"
                value={product.SoLuongConLai}
                onChange={(e) => handleChange("SoLuongConLai", e.target.value)}
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
                class="bx bx-wrench"
                style={{ marginRight: "0.5em", fontSize: "1.2em" }}
              ></i>
              <p style={{ marginBottom: "0" }}>Sửa hàng hóa</p>
            </button>
          </div>
        </form>
      </div>
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

const formatPrice = (value) => {
  if (typeof value !== "string") {
    value = String(value);
  }
  return value.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
};
