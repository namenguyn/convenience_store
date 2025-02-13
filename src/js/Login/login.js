import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import "../../css/login/login.css";

function Login() {
  const [view, setView] = useState("login");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  const handleViewChange = (newView) => {
    setView(newView);
    setError(null); // Reset error khi chuyển giao diện
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post("http://127.0.0.1:8000/", {
        username,
        password,
      });
      if (response.data.success) {
        navigate("/Home");
      }
    } catch (error) {
      setError(error.response?.data?.message || "Lỗi kết nối đến server");
    }
  };

  const handleForgotPassword = async (e) => {
    e.preventDefault();
    try {
      await axios.post("http://127.0.0.1:8000/forgot-password", { username });
      alert("Vui lòng kiểm tra email để đặt lại mật khẩu.");
    } catch (error) {
      setError(error.response?.data?.message || "Lỗi kết nối đến server");
    }
  };

  return (
    <div className="login">
      <div className="navbar">
        <button className={view === "login" ? "active" : ""} onClick={() => handleViewChange("login")}>
          Đăng nhập
        </button>
        <button className={view === "forgotPassword" ? "active" : ""} onClick={() => handleViewChange("forgotPassword")}>
          Quên mật khẩu?
        </button>
      </div>
      <div className="company">
        <h1 className="title-company">CỬA HÀNG TIỆN LỢI</h1>
      </div>
      <div className="content-container">
        {view === "login" ? (
          <form onSubmit={handleLogin}>
            <div className="login-container">
              <input
                type="text"
                placeholder="Tên đăng nhập"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
              />
              <input
                type="password"
                placeholder="Mật khẩu"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
              {error && <div className="error-message">{error}</div>}
              <button type="submit">Đăng nhập</button>
            </div>
          </form>
        ) : (
          <form onSubmit={handleForgotPassword}>
            <div className="forgot-password-container">
              <input
                type="text"
                placeholder="Nhập tên đăng nhập"
                value={username}
                onChange={(e) => setUsername(e.target.value)}
                required
              />
              {error && <div className="error-message">{error}</div>}
              <button type="submit">Gửi yêu cầu</button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
}

export default Login;