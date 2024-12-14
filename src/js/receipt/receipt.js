import React, { useState } from "react";
import axios from "axios";
import ReactPaginate from "react-paginate";
import Header from "../header";
import "../../css/report/report.css";
import "../../css/receipt/receipt.css";
import Grocery from "../../img/ProductList.png";

import "../../css/tool/table.css";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

function ReceiptBody() {
  const [receipts, setReceipts] = useState([]);
  const [startDate, setStartDate] = useState();
  const [endDate, setEndDate] = useState();

  const translateDate = (date) => {
    const newDate = new Date(`${date}`);

    const yyyy = newDate.getFullYear();
    const mm = String(newDate.getMonth() + 1).padStart(2, "0"); // Tháng bắt đầu từ 0
    const dd = String(newDate.getDate()).padStart(2, "0");

    return `${yyyy}-${mm}-${dd}`;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!startDate || !endDate) {
      alert("Bạn chưa nhập đầy đủ thông tin");
    } else {
      axios
        .post(`http://127.0.0.1:8000/hoadon/`, {
          NgayBatDau: translateDate(startDate),
          NgayKetThuc: translateDate(endDate),
        })
        .then((response) => {
          setReceipts(response.data.HoaDon);
        })
        .catch((error) => {
          console.error("Lỗi", error);
          alert(`Lấy dữ liệu hóa đơn thất bại: ${error.response.data.error}`);
        });
    }
  };

  const [currentPage, setCurrentPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  // Tính toán dữ liệu cho trang hiện tại
  const indexOfLastRow = (currentPage + 1) * rowsPerPage;
  const indexOfFirstRow = indexOfLastRow - rowsPerPage;
  const currentRows = Array.isArray(receipts)
    ? receipts.slice(indexOfFirstRow, indexOfLastRow)
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
        DANH SÁCH HÓA ĐƠN
      </p>
      <form
        className="form-receipt d-flex justify-content-around align-items-center"
        onSubmit={handleSubmit}
        style={{ margin: "1em 0" }}
      >
        <div className="d-flex justify-content-left align-items-center">
          <div className="startDate" style={{ marginRight: "3em" }}>
            <label className="titleDate">Ngày bắt đầu:</label>
            <DatePicker
              selected={startDate}
              onChange={(date) => {
                setStartDate(date);
                if (date > endDate) {
                  setEndDate(date);
                }
              }}
              className="dateBox"
              dateFormat="dd/MM/yyyy"
            />
          </div>
          <div className="endDate">
            <label className="titleDate">Ngày kết thúc:</label>
            <DatePicker
              selected={endDate}
              onChange={(date) => setEndDate(date)}
              minDate={startDate}
              maxDate={new Date()}
              className="dateBox"
              dateFormat="dd/MM/yyyy"
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
              <th>Mã hóa đơn</th>
              <th>Thời gian xuất hóa đơn</th>
              <th>Họ và tên</th>
              <th>Mã khách hàng</th>
            </tr>
          </thead>
          <tbody>
            {currentRows.map((row) => (
              <tr key={row.MaHoaDon}>
                <td className="text-center" style={{ width: "9em" }}>
                  {row.MaHoaDon}
                </td>
                <td className="text-center" style={{ width: "9em" }}>
                  {row.ThoiGianXuatHoaDon}
                </td>
                <td
                  className="text-center"
                  style={{ width: "9em", fontWeight: "600" }}
                >
                  {row.HoTen}
                </td>
                <td className="text-center" style={{ width: "9em" }}>
                  {row.MaKhachHang}
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
            pageCount={Math.ceil(receipts.length / rowsPerPage)}
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
    </div>
  );
}

function Receipt() {
  return (
    <div className="web-page" style={{ backgroundImage: `url(${Grocery})` }}>
      <Header />
      <ReceiptBody />
    </div>
  );
}

export default Receipt;
