import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import ReactPaginate from "react-paginate";
import axios from "axios";

import Header from "../header";
import "../../css/product/manageProduct.css";
import "../../css/product/filterProduct.css";
import "../../css/product/findProduct.css";
import "../../css/tool/table.css";
import ConvenienceStore from "../../img/ProductList.png";

function ManageEmployeeBody() {
  const navigate = useNavigate();

  const [employee, setEmployee] = useState([]);

  useEffect(() => {
    if (employee.length === 0) {
      axios
        .get("http://127.0.0.1:8000/read_all_NhanVien/")
        .then((response) => {
          setEmployee(response.data.NhanVien);
        })
        .catch((error) => {
          if (error.response) {
            console.error("Lỗi từ server:", error.response.data);
          } else if (error.request) {
            console.error("Không nhận được phản hồi từ server:", error.request);
          } else {
            console.error("Lỗi khi cấu hình request:", error.message);
          }
          alert(
            `Lấy thông tin nhân viên thất bại: ${error.response.data.message}`
          );
        });
    }
  }, [employee]);

  const [currentPage, setCurrentPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  // Tính toán dữ liệu cho trang hiện tại
  const indexOfLastRow = (currentPage + 1) * rowsPerPage;
  const indexOfFirstRow = indexOfLastRow - rowsPerPage;
  const currentRows = Array.isArray(employee)
    ? employee.slice(indexOfFirstRow, indexOfLastRow)
    : [];

  // Xử lý khi người dùng thay đổi trang
  const handlePageClick = ({ selected }) => {
    setCurrentPage(selected);
  };

  const handleRowsPerPageChange = (e) => {
    setRowsPerPage(Number(e.target.value));
    setCurrentPage(0);
  };

  const formatNumber = (number) => {
    return new Intl.NumberFormat("vi-VN").format(number);
  };
  //------------------THÊM HÀNG HÓA--------------------------
  const handleAdd = async () => {
    navigate("/employee/add", {
      state: employee,
    });
  };
  //------------------SỬA HÀNG HÓA------------------------------
  const handleFix = async (row) => {
    navigate("/employee/fix", {
      state: {
        employeeID: row.MaNhanVien,
        phoneNumber: row.SoDienThoai,
        bdate: row.NgayThangNamSinh,
        startDate: row.NgayBatDauLam,
        name: row.HoTen,
        sex: row.GioiTinh,
        address: row.DiaChi,
        email: row.Email,
        mgrssn: row.MaQuanLy,
        ssn: row.CanCuocCongDan,
      },
    });
  };

  //------------------XÓA HÀNG HÓA------------------------------
  const [selectedRows, setSelectedRows] = useState([]);

  const handleCheckboxChangeForDelete = (row) => {
    if (
      selectedRows.some(
        (selectedRow) => selectedRow.MaNhanVien === row.MaNhanVien
      )
    ) {
      setSelectedRows(
        selectedRows.filter(
          (selectedRow) => selectedRow.MaNhanVien !== row.MaNhanVien
        )
      );
    } else {
      setSelectedRows([...selectedRows, row]);
    }
  };
  const handleSelectAll = () => {
    if (selectedRows.length === employee.length) {
      setSelectedRows([]);
    } else {
      setSelectedRows(employee.map((row) => row));
    }
  };

  const handleDeleteRow = async (MaNhanVien) => {
    const notify =
      "Bạn có chắc chắn muốn xóa nhân viên " +
      employee.find((p) => p.MaNhanVien === MaNhanVien).HoTen +
      " không?";
    if (window.confirm(notify)) {
      axios
        .post(`http://127.0.0.1:8000/deleteNhanVien/`, {
          MaNhanVien: MaNhanVien,
        })
        .then((response) => {
          console.log(response.data);
          alert("Xóa nhân viên thành công");
          setEmployee(
            employee.filter((employee) => employee.MaNhanVien !== MaNhanVien)
          );
        })
        .catch((error) => {
          if (error.response) {
            const serverMessage =
              error.response.data.error || error.response.data;

            if (
              serverMessage.includes("conflicted with the REFERENCE constraint")
            ) {
              alert(
                "Xóa nhân viên thất bại: Nhân viên này đang được tham chiếu trong dữ liệu khác. Hãy kiểm tra các ràng buộc liên quan."
              );
            } else {
              alert(`Lỗi từ server: ${serverMessage}`);
            }
          } else if (error.request) {
            alert("Không nhận được phản hồi từ server. Vui lòng thử lại sau.");
          } else {
            alert(`Đã xảy ra lỗi: ${error.message}`);
          }
        });
    }
  };

  const handleDelete = async () => {
    const notify =
      "Bạn có chắc chắn muốn xóa nhân viên " +
      selectedRows.map((row) => row.HoTen) +
      " không?";
    if (selectedRows.length === 0) {
      alert("Chưa có hàng nào để xóa!");
    } else {
      if (window.confirm(notify)) {
        try {
          const deletePromises = selectedRows.map((row) => {
            return axios.post(`http://127.0.0.1:8000/deleteNhanVien/`, {
              MaNhanVien: row.MaNhanVien,
            });
          });
          await Promise.all(deletePromises);
          setEmployee(
            employee.filter(
              (employee) =>
                !selectedRows.some(
                  (row) => row.MaNhanVien === employee.MaNhanVien
                )
            )
          );
          setSelectedRows([]);
          alert("Xóa nhân viên thành công!");
        } catch (error) {
          if (error.response) {
            const serverMessage =
              error.response.data.error || error.response.data;

            if (
              serverMessage.includes("conflicted with the REFERENCE constraint")
            ) {
              alert(
                "Xóa nhân viên thất bại: Nhân viên này đang được tham chiếu trong dữ liệu khác. Hãy kiểm tra các ràng buộc liên quan."
              );
            } else {
              alert(`Lỗi từ server: ${serverMessage}`);
            }
          } else if (error.request) {
            alert("Không nhận được phản hồi từ server. Vui lòng thử lại sau.");
          } else {
            alert(`Đã xảy ra lỗi: ${error.message}`);
          }
        }
      }
    }
  };
  return (
    <div className="manage-product-body body">
      <div className="d-flex flex-column justify-content-center align-items-center">
        <p className="titlePage " style={{ margin: "0" }}>
          DANH SÁCH NHÂN VIÊN
        </p>
        <div className="table-product">
          <div className="table-product-tool d-flex justify-content-start align-items-center">
            <div className="table-product-btn justify-content-start d-flex align-items-center">
              <button
                onClick={handleDelete}
                className="btn-product delete-product d-flex align-items-center"
                disabled={selectedRows.length === 0} // Nút chỉ khả dụng khi có hàng được chọn
                style={{
                  marginRight: "2em",
                  opacity: selectedRows.length === 0 ? 0.5 : 1, // Làm mờ khi không có hàng được chọn
                  cursor: selectedRows.length === 0 ? "not-allowed" : "pointer", // Thay đổi con trỏ chuột
                }}
              >
                <i className="bx bx-trash"></i>
                <p style={{ marginBottom: "0" }}>Xóa</p>
              </button>
              <button
                onClick={handleAdd}
                className="btn-product add-product d-flex justify-content-center align-items-center"
              >
                <i class="bx bx-cart-add"></i>
                <p style={{ marginBottom: "0" }}>Thêm</p>
              </button>
            </div>
          </div>
          <div className="scroll-table">
            <table className="table table-responsive align-middle table-bordered">
              <thead className="table-success text-center align-middle">
                <tr>
                  <th>
                    <input
                      type="checkbox"
                      checked={selectedRows.length === employee.length}
                      onChange={handleSelectAll}
                    />
                  </th>
                  <th>Mã nhân viên</th>
                  <th>Số điện thoại</th>
                  <th>Ngày tháng năm sinh</th>
                  <th>Ngày bắt đầu làm</th>
                  <th>Họ tên</th>
                  <th>Giới tính</th>
                  <th>Địa chỉ</th>
                  <th>Email</th>
                  <th>Mã quản lý</th>
                  <th>Căn cước công dân</th>
                  <th>Hành động</th>
                </tr>
              </thead>
              <tbody>
                {currentRows.map((row) => (
                  <tr
                    key={row.MaNhanVien}
                    className={
                      selectedRows.some(
                        (selectedRow) =>
                          selectedRow.MaNhanVien === row.MaNhanVien
                      )
                        ? "table-success"
                        : ""
                    }
                  >
                    {row.MaNhanVien ? (
                      <td className="text-center">
                        <input
                          type="checkbox"
                          checked={selectedRows.some(
                            (selectedRow) =>
                              selectedRow.MaNhanVien === row.MaNhanVien
                          )}
                          onChange={() => handleCheckboxChangeForDelete(row)}
                        />
                      </td>
                    ) : (
                      <td></td>
                    )}
                    <td className="text-center">{row.MaNhanVien}</td>
                    <td className="text-start">{row.SoDienThoai}</td>
                    <td className="text-center" style={{ width: "15em" }}>
                      {row.NgayThangNamSinh}
                    </td>
                    <td className="text-center" style={{ width: "15em" }}>
                      {row.NgayBatDauLam}
                    </td>
                    <td className="text-center" style={{ width: "20em" }}>
                      {row.HoTen}
                    </td>
                    <td className="text-center">{row.GioiTinh}</td>
                    <td className="text-start" style={{ width: "25em" }}>
                      {row.DiaChi}
                    </td>
                    <td className="text-center">{row.Email}</td>
                    <td className="text-center">{row.MaQuanLy}</td>
                    <td className="text-center">{row.CanCuocCongDan}</td>
                    {row.MaNhanVien ? (
                      <td className="text-center" style={{ width: "14em" }}>
                        <i
                          class="bx bx-edit edit"
                          onClick={() => handleFix(row)}
                        ></i>
                        <i
                          className="bx bx-trash delete"
                          onClick={() => handleDeleteRow(row.MaNhanVien)}
                        ></i>
                      </td>
                    ) : (
                      <td></td>
                    )}
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
        </div>
        <div className="tool-bar-for-table d-flex align-items-center">
          <div className="pagination-container">
            <ReactPaginate
              previousLabel={"<"}
              nextLabel={">"}
              breakLabel={"..."}
              breakClassName={"break-me"}
              pageCount={Math.ceil(employee.length / rowsPerPage)}
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
    </div>
  );
}

function ManageEmployee() {
  return (
    <div
      className="web-page"
      style={{ backgroundImage: `url(${ConvenienceStore})` }}
    >
      <Header />
      <ManageEmployeeBody />
    </div>
  );
}

export default ManageEmployee;
