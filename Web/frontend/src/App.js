import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Login from "./components/LogIn";
import AddGameCode from "./components/AddGameCode";

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/add-game-code" element={<AddGameCode />} />
      </Routes>
    </Router>
  );
};

export default App;
