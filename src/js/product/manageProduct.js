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

function ManageProductBody() {
  const navigate = useNavigate();

  const [products, setProducts] = useState([]);
  const [arrayType, setArrayType] = useState([]);
  const [error, setError] = useState(false);
  useEffect(() => {
    if (products.length === 0) {
      axios
        .get("http://127.0.0.1:8000/read_all_HangHoa/")
        .then((response) => {
          setProducts(response.data.HangHoa);
          setArrayType([
            ...new Set(response.data.HangHoa.map((product) => product.TenLoai)),
          ]);
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
            `Lấy dữ liệu hàng hóa thất bại: ${error.response.data.message}`
          );
          setError(!error);
        });
    }
  }, [products, arrayType]);

  const [currentPage, setCurrentPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  // Tính toán dữ liệu cho trang hiện tại
  const indexOfLastRow = (currentPage + 1) * rowsPerPage;
  const indexOfFirstRow = indexOfLastRow - rowsPerPage;
  const currentRows = Array.isArray(products)
    ? products.slice(indexOfFirstRow, indexOfLastRow)
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
    navigate("/product_manage/add", {
      state: products,
    });
  };

  //----------------LỌC VÀ SẮP XẾP DỮ LIỆU------------------------
  const [showFilterProduct, setShowFilterProduct] = useState(false);

  const [selectedType, setSelectedType] = useState("");

  const [isToggled, setIsToggled] = useState(false);

  const handleFilter = () => {
    setShowFilterProduct(!showFilterProduct);
  };

  //xử lý sắp xếp dữ liệu
  const handleSubmitFilter = (event) => {
    event.preventDefault();
    if (!isToggled) {
      axios
        .post(`http://127.0.0.1:8000/read_all_HangHoa/loai/desc/`, {
          type: selectedType,
        })
        .then((response) => {
          setProducts(response.data.HangHoa);
          setShowFilterProduct(!showFilterProduct);
        })
        .catch((error) => {
          console.log("Lỗi: ", error);
          alert(
            `Lấy dữ liệu hàng hóa thất bại: ${error.response.data.message}`
          );
        });
    } else {
      axios
        .post(`http://127.0.0.1:8000/read_all_HangHoa/loai/incr/`, {
          type: selectedType,
        })
        .then((response) => {
          setProducts(response.data.HangHoa);
          setShowFilterProduct(!showFilterProduct);
        })
        .catch((error) => {
          console.log("Lỗi: ", error);
          alert(
            `Lấy dữ liệu hàng hóa thất bại: ${error.response.data.message}`
          );
        });
    }
  };
  //-------------------SẮP XẾP HÀNG HÓA----------------------
  const handleIncre = (e) => {
    e.preventDefault();
    if (selectedType) {
      axios
        .post(`http://127.0.0.1:8000/read_all_HangHoa/loai/incr/`, {
          type: selectedType,
        })
        .then((response) => {
          setProducts(response.data.HangHoa);
        })
        .catch((error) => {
          console.log("Lỗi: ", error);
          alert(
            `Lấy dữ liệu hàng hóa thất bại: ${error.response.data.message}`
          );
        });
    } else {
      axios
        .get(`http://127.0.0.1:8000/read_all_HangHoa/incr/`)
        .then((response) => {
          setProducts(response.data.HangHoa);
        })
        .catch((error) => {
          console.log("Lỗi: ", error);
          alert(
            `Lấy dữ liệu hàng hóa thất bại: ${error.response.data.message}`
          );
        });
    }
  };
  const handleDecre = (e) => {
    e.preventDefault();
    if (selectedType) {
      axios
        .post(`http://127.0.0.1:8000/read_all_HangHoa/loai/desc/`, {
          type: selectedType,
        })
        .then((response) => {
          setProducts(response.data.HangHoa);
        })
        .catch((error) => {
          console.log("Lỗi: ", error);
          alert(
            `Lấy dữ liệu hàng hóa thất bại: ${error.response.data.message}`
          );
        });
    } else {
      axios
        .get(`http://127.0.0.1:8000/read_all_HangHoa/desc/`)
        .then((response) => {
          setProducts(response.data.HangHoa);
        })
        .catch((error) => {
          console.log("Lỗi: ", error);
          alert(
            `Lấy dữ liệu hàng hóa thất bại: ${error.response.data.message}`
          );
        });
    }
  };
  //-------------------TÌM DỮ LIỆU DỰA VÀO ID-----------------
  const [result, setResult] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    axios
      .post(`http://127.0.0.1:8000/read_all_HangHoa/id/`, {
        data: result,
      })
      .then((response) => {
        if (response.data.HangHoa && response.data.HangHoa.length > 0) {
          setProducts(response.data.HangHoa);
        } else {
          setProducts([]);
          alert("Không tìm thấy hàng hóa phù hợp.");
        }
      })
      .catch((error) => {
        console.error("Lỗi", error);
        if (error.response && error.response.data.message) {
          alert(`Tìm kiếm thất bại: ${error.response.data.message}`);
        } else {
          alert("Đã xảy ra lỗi trong quá trình tìm kiếm. Vui lòng thử lại.");
        }
      });
  };
  //------------------SỬA HÀNG HÓA------------------------------
  const handleFix = async (row) => {
    navigate("/product_manage/fix", {
      state: {
        MaHangHoa: row.MaHangHoa,
        Ten: row.Ten,
        Gia: row.Gia,
        TenLoai: row.TenLoai,
        DonViTinh: row.DonViTinh,
        SoLuongConLai: row.SoLuongConLai,
      },
    });
  };

  //------------------XÓA HÀNG HÓA------------------------------
  const [selectedRows, setSelectedRows] = useState([]);

  const handleCheckboxChangeForDelete = (row) => {
    if (
      selectedRows.some(
        (selectedRow) => selectedRow.MaHangHoa === row.MaHangHoa
      )
    ) {
      setSelectedRows(
        selectedRows.filter(
          (selectedRow) => selectedRow.MaHangHoa !== row.MaHangHoa
        )
      );
    } else {
      setSelectedRows([...selectedRows, row]);
    }
  };
  const handleSelectAll = () => {
    if (selectedRows.length === products.length) {
      setSelectedRows([]);
    } else {
      setSelectedRows(products.map((row) => row));
    }
  };

  const handleDeleteRow = async (MaHangHoa) => {
    const notify =
      "Bạn có chắc chắn muốn xóa hàng hóa " +
      products.find((p) => p.MaHangHoa === MaHangHoa).Ten +
      " không?";
    if (window.confirm(notify)) {
      axios
        .post(`http://127.0.0.1:8000/delete_one_HangHoa/`, {
          data: MaHangHoa,
        })
        .then((response) => {
          console.log(response.data);
          alert("Xóa hàng hóa thành công");
          setProducts(
            products.filter((product) => product.MaHangHoa !== MaHangHoa)
          );
        })
        .catch((error) => {
          console.error("Failed to delete the row: ", error);
          alert(
            `Bị lỗi trong việc xóa hàng hóa: ${error.response.data.message}`
          );
        });
    }
  };

  const handleDelete = async () => {
    const notify =
      "Bạn có chắc chắn muốn xóa các hàng hóa " +
      selectedRows.map((row) => row.Ten) +
      " không?";
    if (selectedRows.length === 0) {
      alert("Chưa có hàng nào để xóa!");
    } else {
      if (window.confirm(notify)) {
        try {
          const deletePromises = selectedRows.map((row) => {
            return axios.post(`http://127.0.0.1:8000/delete_one_HangHoa/`, {
              data: row.MaHangHoa,
            });
          });
          await Promise.all(deletePromises);
          setProducts(
            products.filter(
              (product) =>
                !selectedRows.some((row) => row.MaHangHoa === product.MaHangHoa)
            )
          );
          setSelectedRows([]);
          alert("Xóa thành công!");
        } catch (error) {
          console.error("Lỗi", error);
          alert(
            `Đã xảy ra lỗi khi xóa hàng hóa: ${error.response.data.message}`
          );
        }
      }
    }
  };
  //--------------Kiểm tra hàng hóa trong kho--------------
  const handleCheck = () => {
    navigate("/product_manage/check_storage");
  };

  //-------------Xem hàng hóa thuộc lô hàng nào?-------------
  const handleView = async (MaHangHoa) => {
    navigate("/product_manage/view", {
      state: {
        MaHangHoa: MaHangHoa,
      },
    });
  };

  return (
    <div className="manage-product-body body">
      <div className="d-flex flex-column justify-content-center align-items-center">
        <p className="titlePage " style={{ margin: "0" }}>
          DANH SÁCH HÀNG HÓA
        </p>

        <div className="table-product">
          <div className="table-product-tool d-flex justify-content-between align-items-center">
            <div className="table-product-btn justify-content-between d-flex align-items-center">
              <button
                onClick={handleDelete}
                className="btn-product delete-product d-flex align-items-center"
                disabled={selectedRows.length === 0} // Nút chỉ khả dụng khi có hàng được chọn
                style={{
                  opacity: selectedRows.length === 0 ? 0.5 : 1, // Làm mờ khi không có hàng được chọn
                  cursor: selectedRows.length === 0 ? "not-allowed" : "pointer", // Thay đổi con trỏ chuột
                }}
              >
                <i className="bx bx-trash"></i>
                <p className="note" style={{ marginBottom: "0" }}>
                  Xóa
                </p>
              </button>
              <button
                onClick={handleFilter}
                className="btn-product filter-product d-flex align-items-center"
              >
                <i class="bx bx-filter"></i>
                <p className="note" style={{ marginBottom: "0" }}>
                  Lọc
                </p>
              </button>
              <button
                onClick={handleAdd}
                className="btn-product add-product d-flex justify-content-center align-items-center"
              >
                <i class="bx bx-cart-add"></i>
                <p className="note" style={{ marginBottom: "0" }}>
                  Thêm
                </p>
              </button>
              <button
                onClick={handleCheck}
                className="btn-product check-product d-flex justify-content-center align-items-center"
              >
                <i class="bx bx-list-check"></i>
                <p className="note" style={{ marginBottom: "0" }}>
                  Kiểm tra hàng hóa trong kho
                </p>
              </button>
            </div>
            <form
              className="find-product-form d-flex justify-content-end align-items-center"
              onSubmit={handleSubmit}
            >
              <div className="find-product">
                <i class="bx bx-search-alt-2"></i>
                <input
                  type="text"
                  className="find-input"
                  name="find"
                  placeholder="Tìm mã hàng hóa"
                  value={result}
                  onChange={(e) => setResult(e.target.value)}
                />
              </div>
              <button type="submit" className="btn btn-primary">
                Tìm kiếm
              </button>
            </form>
          </div>
          <div className="scroll-table">
            <table className="table table-responsive align-middle table-bordered">
              <thead className="table-success text-center align-middle">
                <tr>
                  <th>
                    <input
                      type="checkbox"
                      checked={selectedRows.length === products.length}
                      onChange={handleSelectAll}
                    />
                  </th>
                  <th>Mã hàng hóa</th>
                  <th>Tên</th>
                  <th
                    className="d-flex align-items-center justify-content-center"
                    style={{ height: "100%" }}
                  >
                    <p style={{ marginBottom: "0" }}>Giá</p>
                    <div
                      className="sort d-flex flex-column justify-content-center"
                      style={{
                        height: "1em",
                        fontSize: "0.8em",
                        marginLeft: "0.3em",
                      }}
                    >
                      <i
                        className="bx bx-chevron-up"
                        style={{
                          fontWeight: "800",
                          color: "blue",
                          cursor: "pointer",
                        }}
                        onClick={handleIncre}
                      ></i>
                      <i
                        className="bx bx-chevron-down"
                        style={{
                          fontWeight: "800",
                          color: "blue",
                          cursor: "pointer",
                        }}
                        onClick={handleDecre}
                      ></i>
                    </div>
                  </th>
                  <th>Đơn vị tính</th>
                  <th>Số lượng còn lại</th>
                  <th>Mã loại</th>
                  <th>Tên loại</th>
                  <th>Hành động</th>
                </tr>
              </thead>
              <tbody>
                {currentRows.map((row) => (
                  <tr
                    key={row.MaHangHoa}
                    className={
                      selectedRows.some(
                        (selectedRow) => selectedRow.MaHangHoa === row.MaHangHoa
                      )
                        ? "table-success"
                        : ""
                    }
                  >
                    {row.MaHangHoa ? (
                      <td className="text-center">
                        <input
                          type="checkbox"
                          checked={selectedRows.some(
                            (selectedRow) =>
                              selectedRow.MaHangHoa === row.MaHangHoa
                          )}
                          onChange={() => handleCheckboxChangeForDelete(row)}
                        />
                      </td>
                    ) : (
                      <td></td>
                    )}
                    <td className="text-center" style={{ width: "9em" }}>
                      {row.MaHangHoa}
                    </td>
                    <td
                      className="text-start"
                      style={{ width: "11em", fontWeight: "600" }}
                    >
                      {row.Ten}
                    </td>
                    <td className="text-end" style={{ width: "9em" }}>
                      {row.Gia ? `${formatNumber(row.Gia) + " VND"}` : ""}
                    </td>
                    <td className="text-center" style={{ width: "9em" }}>
                      {row.DonViTinh}
                    </td>
                    <td className="text-center" style={{ width: "7em" }}>
                      {row.SoLuongConLai}
                    </td>
                    <td className="text-center" style={{ width: "7em" }}>
                      {row.MaLoai}
                    </td>
                    <td className="text-center" style={{ width: "7em" }}>
                      {row.TenLoai}
                    </td>
                    {row.MaHangHoa ? (
                      <td className="text-center">
                        <i
                          class="bx bx-show view"
                          onClick={() => handleView(row.MaHangHoa)}
                        ></i>
                        <i
                          class="bx bx-edit edit"
                          onClick={() => handleFix(row)}
                        ></i>
                        <i
                          className="bx bx-trash delete"
                          onClick={() => handleDeleteRow(row.MaHangHoa)}
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
              pageCount={Math.ceil(products.length / rowsPerPage)}
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
      {showFilterProduct && (
        <div className="overlay form-filter d-flex flex-column justify-content-center align-items-center">
          <div className="form-filter-inside">
            <i
              class="bx bx-x-circle icon-exit d-flex justify-content-end"
              onClick={handleFilter}
            ></i>
            <form
              className="d-flex flex-column justify-content-center align-items-center"
              onSubmit={handleSubmitFilter}
            >
              <div className="product-type d-flex flex-column justify-content-center align-items-start">
                <label className="title">Loại hàng hóa</label>
                <select
                  id="type"
                  className="input-filter"
                  value={selectedType}
                  onChange={(e) => setSelectedType(e.target.value)}
                >
                  <option value="">--Chọn loại--</option>
                  {arrayType.map((type) => (
                    <option value={type}>{type}</option>
                  ))}
                </select>
              </div>
              <div className="product-outdate d-flex flex-column align-items-start justify-content-center">
                <label className="title">Giá tiền</label>
                <div class="sort-outdate d-flex justify-content-center align-items-center">
                  <div className="sort-outdate-new">Cao nhất</div>
                  <div
                    className={`toggle-btn ${isToggled ? "toggled" : ""}`}
                    onClick={() => setIsToggled(!isToggled)}
                  >
                    <i className="indicator"></i>
                  </div>
                  <div className="sort-outdate-old">Thấp nhất</div>
                </div>
              </div>
              <div className="button-filter d-flex justify-content-center align-items-center">
                <button
                  type="submit"
                  className="btn btn-outline-primary trigger-filter"
                >
                  Lọc dữ liệu
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

function ManageProduct() {
  return (
    <div
      className="web-page"
      style={{ backgroundImage: `url(${ConvenienceStore})` }}
    >
      <Header />
      <ManageProductBody />
    </div>
  );
}

export default ManageProduct;
