import React, { useState } from "react";
import { NavLink } from "react-router-dom";

import Header from "./header";
import "../css/deleteProduct.css";
import DeleteProductImage from "../img/GroceryBackground.jpg";

function DeleteProductBody() {
  const [selectedRows, setSelectedRows] = useState([]);
  const [message, setMessage] = useState("");
  const productInfo = [
    ["UN12345", "Ca rot", 18000.0, "Loai 1", "kg"],
    ["DE54321", "Sua Milo", 8000.0, "Loai 2", "hop"],
    ["XY98765", "Sting", 15000.0, "Loai 1", "chai"],
    ["AB34567", "My 3 mien", 200000.0, "Loai 3", "thung"],
    ["CD67890", "Keo bac ha", 25000.0, "Loai 2", "goi"],
    ["EF56789", "Soju", 35000.0, "Loai 1", "chai"],
    ["GH43210", "Sua ong tho", 22000.0, "Loai 3", "lon"],
    ["IJ65432", "Sua TH true milk", 7000.0, "Loai 1", "hop"],
    ["KL87654", "Nuoc suoi", 5000.0, "Loai 2", "chai"],
    ["MN76543", "Monster", 30000.0, "Loai 3", "lon"],
    ["OP43210", "Nuoc dao", 25000.0, "Loai 4", "hop"],
    ["QR54321", "Mi SiuKay", 15000.0, "Loai 4", "goi"],
    ["ST65432", "Yakult", 5000.0, "Loai 5", "chai"],
    ["UV76543", "Tao Fuji", 49000.0, "Loai 5", "kg"],
    ["WX87654", "Nam kim chi", 12000.0, "Loai 6", "goi"],
    ["YZ98765", "Strongbow", 22000.0, "Loai 6", "lon"],
    ["AB09876", "Kim chi Han Quoc", 31000.0, "Loai 7", "hop"],
    ["CD10987", "Bento", 27000.0, "Loai 7", "bao"],
    ["EF21098", "Nuoc tuong Magi", 27000.0, "Loai 8", "chai"],
    ["GH32109", "Dua leo", 10000.0, "Loai 8", "kg"],
  ];
  const productInfoNamed = productInfo.map((item, index) => {
    return {
      id: item[0],
      name: item[1],
      price: item[2],
      type: item[3],
      unit: item[4],
    };
  });
  const handleCheckboxChange = (id) => {
    setSelectedRows((prevSelectedRows) =>
      prevSelectedRows.includes(id)
        ? prevSelectedRows.filter((rowId) => rowId !== id)
        : [...prevSelectedRows, id]
    );
    setMessage("");
  };
  const handleSelectAll = () => {
    if (selectedRows.length === productInfoNamed.length) {
      setSelectedRows([]);
    } else {
      setSelectedRows(productInfoNamed.map((row) => row.id));
    }
  };

  const handleDelete = () => {
    if (selectedRows.length === 0) {
      setMessage("Please select a row to delete.");
    } else {
      console.log("Deleting row with id:", selectedRows);
      setMessage(`Row has been deleted.`);
      setSelectedRows(null);
    }
  };
  return (
    <div className="delete-product-body body d-flex flex-column justify-content-start align-items-center">
      <p className="title">Xóa hàng hóa</p>
      <div className="table-product">
        <table className="table text-center align-middle table-responsive table-bordered table-hover">
          <thead>
            <tr>
              <th>
                {" "}
                <input
                  type="checkbox"
                  checked={selectedRows.length === productInfoNamed.length}
                  onChange={handleSelectAll}
                />{" "}
              </th>
              <th>Mã hàng hóa</th>
              <th>Tên</th>
              <th>Giá</th>
              <th>Loại</th>
              <th>Đơn vị tính</th>
            </tr>
          </thead>
          <tbody>
            {productInfoNamed.map((row) => (
              <tr key={row.id}>
                <td>
                  <input
                    type="checkbox"
                    checked={selectedRows.includes(row.id)}
                    onChange={() => handleCheckboxChange(row.id)}
                  />
                </td>
                <td>{row.id}</td>
                <td>{row.name}</td>
                <td>{row.price}</td>
                <td>{row.type}</td>
                <td>{row.unit}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <div className="edit-trigger d-flex justify-content-between align-items-center">
        <NavLink
          to="/admin/manage"
          className="manage-body-link d-flex justify-content-center align-items-center"
          style={{ background: "#00BFFF" }}
        >
          <p>Hủy bỏ</p>
        </NavLink>
        <button
          type="submit"
          className="manage-body-link d-flex justify-content-center align-items-center"
          style={{ background: "#DC143C" }}
          onClick={handleDelete}
        >
          <i class="bx bx-trash"></i>
          <p>Xóa</p>
        </button>
        {message && <p className="delete-message">{message}</p>}
      </div>
    </div>
  );
}

function DeleteProduct() {
  return (
    <div
      className="web-page"
      style={{ backgroundImage: `url(${DeleteProductImage})` }}
    >
      <Header />
      <DeleteProductBody />
    </div>
  );
}

export default DeleteProduct;
