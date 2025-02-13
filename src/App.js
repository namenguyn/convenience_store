import React from "react";

import "./css/tool/lang.css";
import "./css/tool/web-page.css";
import "./App.css";
import "./css/tool/paginate.css";
import "./css/tool/table.css";

import Home from "./js/home";
import ManageProduct from "./js/product/manageProduct";
import AddProduct from "./js/product/addProduct";
import FixProduct from "./js/product/fixProduct";
import Report from "./js/report/report";
import Employee from "./js/employee/manageEmployee";
import AddEmployee from "./js/employee/addEmployee";
import FixEmployee from "./js/employee/fixEmployee";
import Receipt from "./js/receipt/receipt";
import { Route, Routes } from "react-router-dom";
import CheckStorage from "./js/product/checkStorage";
import ShowGoods from "./js/product/showGoods";
import LoginPage from "./js/Login/login";
function App() {
  return (
    <div className="wrapper">
      <Routes className="routes">
        <Route path="/" Component={LoginPage} /> 
        <Route path="/Home" Component={Home} />

        <Route path="/product_manage" Component={ManageProduct} />
        <Route path="/product_manage/add" Component={AddProduct} />
        <Route path="/product_manage/fix" Component={FixProduct} />
        <Route path="/product_manage/check_storage" Component={CheckStorage} />
        <Route path="/product_manage/view" Component={ShowGoods} />

        <Route path="/report" Component={Report} />

        <Route path="/employee" Component={Employee} />
        <Route path="/employee/add" Component={AddEmployee} />
        <Route path="/employee/fix" Component={FixEmployee} />

        <Route path="/receipt" Component={Receipt} />
      </Routes>
    </div>
  );
}

export default App;
