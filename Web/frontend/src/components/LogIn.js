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
      setStatus("✅ Đăng nhập thành công!");
      setTimeout(() => navigate("/add-game-code"), 1000);
    } else {
      setStatus("🚫 Sai tên đăng nhập hoặc mật khẩu.");
    }
  } catch (error) {
    console.error("Login error:", error);
    setStatus("⚠️ Có lỗi xảy ra khi đăng nhập.");
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
      <link 
        href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" 
        rel="stylesheet" 
      />
      <link 
        href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" 
        rel="stylesheet" 
      />
      
      <div className="min-vh-100 d-flex align-items-center py-5" style={{ background: "linear-gradient(135deg, #0f0f23 0%, #1a1a2e 50%, #16213e 100%)" }}>
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-8 col-lg-6">
              <div className="p-4 rounded shadow-lg" style={{ background: "rgba(255,255,255,0.02)", backdropFilter: "blur(10px)", color: "#fff" }}>
                <div className="text-center mb-4">
                  <h3><i className="bi bi-shield-lock me-2"></i>Admin Login</h3>
                  <p className="opacity-75">Đăng nhập để tiếp tục</p>
                </div>

                <div className="mb-3">
                  <label className="form-label">Tên đăng nhập</label>
                  <div className="input-group">
                    <span className="input-group-text"><i className="bi bi-person-circle"></i></span>
                    <input
                      type="text"
                      className="form-control"
                      value={username}
                      onChange={(e) => setUsername(e.target.value)}
                      onKeyPress={(e) => e.key === 'Enter' && handleLogin()}
                      disabled={isLoading}
                    />
                  </div>
                </div>

                <div className="mb-4">
                  <label className="form-label">Mật khẩu</label>
                  <div className="input-group">
                    <span className="input-group-text"><i className="bi bi-key"></i></span>
                    <input
                      type="password"
                      className="form-control"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      onKeyPress={(e) => e.key === 'Enter' && handleLogin()}
                      disabled={isLoading}
                    />
                  </div>
                </div>

                <div className="d-grid mb-3">
                  <button 
                    className="btn btn-game-primary btn-lg" 
                    style={{ background: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)", color: "#fff" }}
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
    </>
  );
};

export default Login;
