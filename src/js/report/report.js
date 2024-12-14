import React, { useState, useEffect } from "react";
import {
  Chart as ChartJS,
  BarElement,
  CategoryScale,
  LinearScale,
  Tooltip,
  ArcElement,
} from "chart.js";

import { Bar } from "react-chartjs-2";

import Header from "../header";
import axios from "axios";
import "../../css/report/report.css";
import ConvenienceStore from "../../img/background-thongke.jpg";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
ChartJS.register(BarElement, CategoryScale, LinearScale, Tooltip, ArcElement);

const BarChart = ({ data }) => {
  const chartData = {
    labels: data.map((item) => item.month),
    datasets: [
      {
        label: "Lợi nhuận",
        data: data.map((item) => item.revenue),
        backgroundColor: "rgba(75, 192, 192, 0.7)",
        borderColor: "rgba(75, 192, 192, 1)",
        borderWidth: 1,
      },
    ],
  };

  const options = {
    responsive: true,
    plugins: {
      legend: {
        position: "top",
        display: true,
        labels: { font: { weight: "bold" } },
      },
      title: { display: true, text: "Lợi nhuận hàng tháng" },
      tooltip: {
        callbacks: {
          label: function (context) {
            let label = context.dataset.label || "";
            if (label) {
              label += ": ";
            }
            if (context.parsed.y !== null) {
              label += new Intl.NumberFormat("vi-VN", {
                style: "currency",
                currency: "VND",
              }).format(context.parsed.y);
            }
            return label;
          },
        },
      },
    },
    scales: {
      x: { beginAtZero: true, ticks: { font: { weight: "bold" } } },
      y: {
        beginAtZero: true,
        ticks: {
          callback: function (value) {
            return new Intl.NumberFormat("vi-VN", {
              style: "currency",
              currency: "VND",
            }).format(value);
          },
          font: { weight: "bold" },
        },
      },
    },
  };
  return <Bar data={chartData} options={options} />;
};

const HorizontalBarChart = ({ data }) => {
  const chartData = {
    labels: data.map((item) => item.name),
    datasets: [
      {
        label: "Doanh thu (%)",
        data: data.map((item) => item.percentage),
        backgroundColor: "rgba(75, 192, 192, 0.7)",
        borderColor: "rgba(75, 192, 192, 1)",
        borderWidth: 1,
      },
    ],
  };

  const options = {
    indexAxis: "y",
    responsive: true,
    plugins: {
      legend: { position: "top" },
      title: { display: true, text: "Đóng góp của hàng hóa vào doanh thu" },
      tooltip: {
        callbacks: {
          label: function (context) {
            let label = context.dataset.label || "";
            if (label) {
              label += ": ";
            }
            if (context.parsed.x !== null) {
              label += context.parsed.x + "%";
            }
            return label;
          },
        },
      },
      datalabels: {
        anchor: "end",
        align: "top",
        font: {
          weight: "bold",
        },
        formatter: (value) => value + "%",
      },
    },
    scales: {
      x: {
        beginAtZero: true,
        ticks: {
          callback: function (value) {
            return value + "%";
          },
        },
      },
      y: {
        ticks: {
          font: {
            weight: "bold",
          },
        },
      },
    },
  };

  return <Bar data={chartData} options={options} />;
};

function ReportBody() {
  //bar chart
  const [revenuesMonth, setRevenuesMonth] = useState([]);

  useEffect(() => {
    axios
      .get(`http://127.0.0.1:8000/calculate/calculateProfit/`)
      .then((response) => {
        setRevenuesMonth(
          Object.entries(
            response.data["Lợi nhuận hàng tháng trong năm 2024"]
          ).map(([month, value]) => ({
            month: month + "/2024",
            revenue: parseFloat(value[0][0]),
          }))
        );
      })
      .catch((error) => {
        console.error("Lỗi", error);
        alert(
          `Lấy thông tin lợi nhuận của cửa hàng thất bại: ${error.response.data.error}`
        );
      });
  }, []);

  const [productRevenue, setProductRevenue] = useState([]);
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
      alert("Chưa nhập đầy đủ thông tin ngày đầu và cuối");
    } else {
      const line =
        "Doanh thu từ " +
        translateDate(startDate) +
        " đến " +
        translateDate(endDate) +
        " là:";
      axios
        .post(`http://127.0.0.1:8000/calculate/performance/`, {
          startDate: translateDate(startDate),
          endDate: translateDate(endDate),
        })
        .then((response) => {
          setProductRevenue(
            Object.entries(response.data[line]).map(([Ten, PhanTram]) => ({
              name: Ten,
              percentage: parseFloat(PhanTram[0][0]),
            }))
          );
        })
        .catch((error) => {
          console.error("Lỗi", error);
          alert(
            `Lấy dữ liệu đóng góp của hàng hóa thất bại: ${error.response.data.error}`
          );
        });
    }
  };

  return (
    <div className="report-body body row d-flex">
      <div className="contributeOfProduct col-6 d-flex flex-column justify-content-end align-items-center">
        <label className="title">Đóng góp của các hàng hóa vào lợi nhuận</label>
        <form className="row" onSubmit={handleSubmit}>
          <div className="col-7 d-flex flex-column justify-content-left align-items-center">
            <div className="startDate">
              <label className="titleDate">Ngày đầu:</label>
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
              <label className="titleDate">Ngày cuối:</label>
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

        <div className="horizontalBarChart">
          <HorizontalBarChart data={productRevenue} />
        </div>
      </div>
      <div className="revenueOfStore col-5 d-flex flex-column justify-content-start align-items-center">
        <label className="title">Lợi nhuận của cửa hàng</label>
        <div className="barChart">
          <BarChart data={revenuesMonth} />
        </div>
      </div>
    </div>
  );
}
//
function Report() {
  return (
    <div
      className="web-page"
      style={{ backgroundImage: `url(${ConvenienceStore})` }}
    >
      <Header />
      <ReportBody />
    </div>
  );
}

export default Report;
