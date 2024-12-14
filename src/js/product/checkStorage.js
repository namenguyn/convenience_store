import React, { useState } from "react";
import axios from "axios";
import ReactPaginate from "react-paginate";
import Header from "../header";
import "../../css/report/report.css";
import "../../css/receipt/receipt.css";
import Grocery from "../../img/ProductList.png";
import { useNavigate } from "react-router-dom";
import "../../css/tool/table.css";
import "../../css/product/checkStorage.css";
function CheckStorageBody() {
  const navigate = useNavigate();
  const [storage, setStorage] = useState([]);
  const [storageID, setStorageID] = useState("");
  const [maxCount, setMaxCount] = useState();

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!storageID || !maxCount) {
      alert("Bạn chưa nhập đủ thông tin để kiểm tra");
    } else {
      axios
        .post(`http://127.0.0.1:8000/kiemtrakhoahang/`, {
          MaKhoHang: storageID,
          SoLuongToiDa: maxCount,
        })
        .then((response) => {
          setStorage(response.data.HangHoaTrongKho);
        })
        .catch((error) => {
          console.error("Lỗi", error);
          alert(`Lấy dữ liệu kho hàng thất bại: ${error.response.data.error}`);
        });
    }
  };

  const [currentPage, setCurrentPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  // Tính toán dữ liệu cho trang hiện tại
  const indexOfLastRow = (currentPage + 1) * rowsPerPage;
  const indexOfFirstRow = indexOfLastRow - rowsPerPage;
  const currentRows = Array.isArray(storage)
    ? storage.slice(indexOfFirstRow, indexOfLastRow)
    : [];

  // Xử lý khi người dùng thay đổi trang
  const handlePageClick = ({ selected }) => {
    setCurrentPage(selected);
  };

  const handleRowsPerPageChange = (e) => {
    setRowsPerPage(Number(e.target.value));
    setCurrentPage(0);
  };
  return (
    <div className="body receipt d-flex flex-column align-items-center justify-content-start">
      <p style={{ marginBottom: "0" }} className="titlePage">
        KIỂM TRA HÀNG HÓA TRONG KHO
      </p>
      <form
        className="form-receipt d-flex justify-content-around align-items-center"
        onSubmit={handleSubmit}
        style={{ margin: "1em 0" }}
      >
        <div className="d-flex justify-content-left align-items-center">
          <div className="startDate" style={{ marginRight: "3em" }}>
            <label className="titleDate">Mã kho hàng:</label>
            <input
              type="text"
              className="input-box"
              value={storageID}
              onChange={(e) => setStorageID(e.target.value)}
            />
          </div>
          <div className="endDate">
            <label className="titleDate">Tổng số lượng tối đa:</label>
            <input
              type="number"
              className="input-box"
              value={maxCount}
              onChange={(e) => setMaxCount(e.target.value)}
            />
          </div>
        </div>
        <div className="col-5 d-flex flex-column justify-content-center align-items-center">
          <button
            type="submit"
            className="trigger-date btn btn-outline-primary"
          >
            Hiển thị
          </button>
        </div>
      </form>
      <div className="scroll-table">
        <table className="table table-responsive align-middle table-bordered">
          <thead className="table-success text-center align-middle">
            <tr>
              <th>Mã kho hàng</th>
              <th>Loại hàng hóa</th>
              <th>Tổng số lượng đã nhập</th>
            </tr>
          </thead>
          <tbody>
            {currentRows.map((row) => (
              <tr key={row.LoaiHangHoa}>
                <td className="text-center">{row.MaKhoHang}</td>
                <td className="text-center">{row.LoaiHangHoa}</td>
                <td className="text-center" style={{ fontWeight: "600" }}>
                  {row.TongSoLuongDaNhap}
                </td>
              </tr>
            ))}
            {Array.from({ length: rowsPerPage - currentRows.length }).map(
              (_, index) => (
                <tr key={`empty-${index}`}>
                  <td colSpan="7" className="adjustRow"></td>
                </tr>
              )
            )}
          </tbody>
        </table>
      </div>
      <div className="tool-bar-for-table d-flex align-items-center">
        <div className="pagination-container">
          <ReactPaginate
            previousLabel={"<"}
            nextLabel={">"}
            breakLabel={"..."}
            breakClassName={"break-me"}
            pageCount={Math.ceil(storage.length / rowsPerPage)}
            marginPagesDisplayed={2}
            pageRangeDisplayed={2}
            onPageChange={handlePageClick}
            containerClassName={"pagination"}
            activeClassName={"active"}
            pageClassName={"page-item"}
            pageLinkClassName={"page-link"}
            previousClassName={"page-item"}
            previousLinkClassName={"page-link"}
            nextClassName={"page-item"}
            nextLinkClassName={"page-link"}
            breakLinkClassName={"page-link"}
          />
        </div>
        <div className="display-table">
          <select
            className="display-table-select"
            value={rowsPerPage}
            onChange={handleRowsPerPageChange}
          >
            <option value={5}>5</option>
            <option value={10}>10</option>
            <option value={15}>15</option>
            <option value={20}>20</option>
          </select>
          <label className="display-table-label">Hiển thị</label>
        </div>
      </div>
      <div
        className="d-flex align-items-center justify-content-start"
        style={{
          background: "white",
          width: "fit-content",
          marginTop: "0.5em",
        }}
      >
        <button
          type="button"
          onClick={() => {
            navigate("/product_manage");
          }}
          className="btn btn-outline-primary d-flex align-items-center justify-content-center"
        >
          <i className="bx bx-exit" style={{ marginRight: "0.5em" }}></i>
          Thoát
        </button>
      </div>
    </div>
  );
}

function CheckStorage() {
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <CheckStorageBody />
    </div>
  );
}

export default CheckStorage;
