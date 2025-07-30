import React, { useState } from "react";
import { firestore } from "../utilities/firebase";
import { useNavigate } from "react-router-dom";
import { collection, getDocs } from "firebase/firestore";

const Login = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [status, setStatus] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();

  const handleLogin = async () => {
    if (!username || !password) {
      setStatus("⚠️ Vui lòng nhập đủ thông tin.");
      return;
    }

    setIsLoading(true);
    try {
      const querySnapshot = await getDocs(collection(firestore, "users"));
      let found = false;

      querySnapshot.forEach((docSnap) => {
        const userData = docSnap.data();
        const inputUsername = username.trim().toLowerCase();
        const storedUsername = userData.user_name.trim().toLowerCase();
        const inputPassword = password.trim();
        const storedPassword = userData.password.trim();

        if (inputUsername === storedUsername && inputPassword === storedPassword) {
          found = true;
        }
      });

      if (found) {
        setStatus("Đăng nhập thành công!");
        setTimeout(() => navigate("/add-game-code"), 1000);
      } else {
        setStatus("Sai tên đăng nhập hoặc mật khẩu.");
      }
    } catch (error) {
      console.error("Login error:", error);
      setStatus("Có lỗi xảy ra khi đăng nhập.");
    }
    setIsLoading(false);
  };

  const getStatusClass = () => {
    if (status.includes("✅")) return "alert alert-success border-0";
    if (status.includes("🚫") || status.includes("lỗi")) return "alert alert-danger border-0";
    if (status.includes("⚠️")) return "alert alert-warning border-0";
    return "alert alert-info border-0";
  };

  return (
    <>
      {/* Bootstrap */}
      <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet" />
      <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" rel="stylesheet" />

      {/* Copy CSS từ AddGameCode */}
      <style>{`
        body {
          background: linear-gradient(135deg, #0f0f23 0%, #1a1a2e 50%, #16213e 100%);
          min-height: 100vh;
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .game-container {
          background: rgba(255, 255, 255, 0.02);
          backdrop-filter: blur(20px);
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 20px;
          box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
        }
        .game-header {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          border-radius: 20px 20px 0 0;
          padding: 2rem;
          position: relative;
          overflow: hidden;
        }
        .game-header h3 {
          position: relative;
          z-index: 1;
          color: #fff;
        }
        .game-body {
          background: rgba(255, 255, 255, 0.03);
          padding: 2.5rem;
          border-radius: 0 0 20px 20px;
        }
        .form-label {
          color: #fff;
          font-weight: 600;
          margin-bottom: 0.8rem;
          text-transform: uppercase;
          font-size: 0.85rem;
          letter-spacing: 0.5px;
        }
        .form-control {
          background: rgba(255, 255, 255, 0.05);
          border: 1px solid rgba(255, 255, 255, 0.1);
          color: #fff;
          border-radius: 12px;
          padding: 0.8rem 1rem;
        }
        .form-control::placeholder {
          color: rgba(255, 255, 255, 0.5);
        }
        .input-group-text {
          background: rgba(255, 255, 255, 0.08);
          border: 1px solid rgba(255, 255, 255, 0.1);
          color: #667eea;
          border-radius: 12px 0 0 12px;
        }
        .btn-game-primary {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          border: none;
          border-radius: 12px;
          padding: 1rem 2rem;
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.5px;
          color: #fff;
        }
        .alert {
          border-radius: 12px;
          backdrop-filter: blur(10px);
          border: none;
          font-weight: 500;
        }
      `}</style>

      <div className="min-vh-100 d-flex align-items-center py-5">
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-8 col-lg-6">
              <div className="game-container">
                <div className="game-header text-center">
                  <h3><i className="bi bi-shield-lock me-2"></i>Admin Login</h3>
                  <p className="mb-0 mt-2 opacity-75">Đăng nhập để tiếp tục</p>
                </div>
                <div className="game-body">
                  <div className="mb-4">
                    <label className="form-label">
                      <i className="bi bi-person-circle me-2"></i>Tên đăng nhập
                    </label>
                    <div className="input-group">
                      <span className="input-group-text"><i className="bi bi-person"></i></span>
                      <input
                        type="text"
                        className="form-control"
                        placeholder="Nhập tên đăng nhập"
                        value={username}
                        onChange={(e) => setUsername(e.target.value)}
                        onKeyPress={(e) => e.key === 'Enter' && handleLogin()}
                        disabled={isLoading}
                      />
                    </div>
                  </div>

                  <div className="mb-4">
                    <label className="form-label">
                      <i className="bi bi-key me-2"></i>Mật khẩu
                    </label>
                    <div className="input-group">
                      <span className="input-group-text"><i className="bi bi-shield-lock"></i></span>
                      <input
                        type="password"
                        className="form-control"
                        placeholder="Nhập mật khẩu"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        onKeyPress={(e) => e.key === 'Enter' && handleLogin()}
                        disabled={isLoading}
                      />
                    </div>
                  </div>

                  <div className="d-grid gap-2 mb-4">
                    <button
                      type="button"
                      className="btn btn-game-primary btn-lg"
                      onClick={handleLogin}
                      disabled={isLoading || !username || !password}
                    >
                      {isLoading ? (
                        <>
                          <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                          Đang đăng nhập...
                        </>
                      ) : (
                        <>
                          <i className="bi bi-box-arrow-in-right me-2"></i>
                          Đăng nhập
                        </>
                      )}
                    </button>
                  </div>

                  {status && (
                    <div className={`${getStatusClass()} mt-2`} role="alert">
                      {status}
                    </div>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Login;