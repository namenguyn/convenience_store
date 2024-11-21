import React from "react";

import "./css/lang.css";
import "./css/web-page.css";
import "./App.css";

import Home from "./js/home";
import ManageProduct from "./js/manageProduct";
import AddProduct from "./js/addProduct";
import DeleteProduct from "./js/deleteProduct";
import FixProduct_Choose from "./js/fixProduct-choose";
import FixProduct from "./js/fixProduct";
import FindProduct from "./js/findProduct";
import { Route, Routes } from "react-router-dom";

function App() {
  return (
    <div className="wrapper">
      <Routes className="routes">
        <Route path="/admin" Component={Home} />
        <Route path="/admin/manage" Component={ManageProduct} />
        <Route path="/admin/manage/add" Component={AddProduct} />
        <Route path="/admin/manage/delete" Component={DeleteProduct} />
        <Route path="/admin/manage/fix_choose" Component={FixProduct_Choose} />
        <Route path="/admin/manage/fix_choose/fix" Component={FixProduct} />
        <Route path="/admin/find" Component={FindProduct} />
      </Routes>
    </div>
  );
}

export default App;
