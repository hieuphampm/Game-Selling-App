import React, { useState } from "react";
import { firestore } from "../utilities/firebase";
import { doc, getDoc, updateDoc } from "firebase/firestore";


const AddGameCode = () => {
  const [gameId, setGameId] = useState("");
  const [newCode, setNewCode] = useState("");
  const [status, setStatus] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const handleAddCode = async () => {
  if (!gameId || !newCode) {
    setStatus("Vui lòng nhập đầy đủ thông tin.");
    return;
  }

  setIsLoading(true);

  try {
    const gameRef = doc(firestore, "game", gameId);
    const gameSnap = await getDoc(gameRef);

    if (!gameSnap.exists()) {
      setStatus("🚫 Game không tồn tại!");
    } else {
      const gameData = gameSnap.data();
      const existingCodes = gameData.codes || [];

      if (existingCodes.includes(newCode)) {
        setStatus("🚫 Mã code này đã tồn tại!");
      } else {
        const updatedCodes = [...existingCodes, newCode];
        await updateDoc(gameRef, { codes: updatedCodes });
        setStatus("✅ Thêm code thành công!");
        setNewCode("");
      }
    }
  } catch (error) {
    console.error("⚠️ Lỗi khi thêm code:", error);
    setStatus("⚠️ Lỗi khi thêm code.");
  }

  setIsLoading(false);
};


  const getStatusClass = () => {
    if (status.includes("✅")) return "alert alert-success border-0";
    if (status.includes("🚫") || status.includes("Lỗi")) return "alert alert-danger border-0";
    if (status.includes("⚠️")) return "alert alert-warning border-0";
    return "alert alert-info border-0";
  };

  return (
    <>
      {/* Bootstrap CSS CDN with Dark Theme */}
      <link 
        href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" 
        rel="stylesheet" 
      />
      <link 
        href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css" 
        rel="stylesheet" 
      />
      
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
        
        .game-header::before {
          content: '';
          position: absolute;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="game-pattern" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23game-pattern)"/></svg>');
          opacity: 0.3;
        }
        
        .game-header h3 {
          position: relative;
          z-index: 1;
          text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .game-body {
          background: rgba(255, 255, 255, 0.03);
          padding: 2.5rem;
          border-radius: 0 0 20px 20px;
        }
        
        .form-control {
          background: rgba(255, 255, 255, 0.05);
          border: 1px solid rgba(255, 255, 255, 0.1);
          color: #fff;
          border-radius: 12px;
          padding: 0.8rem 1rem;
          transition: all 0.3s ease;
        }
        
        .form-control:focus {
          background: rgba(255, 255, 255, 0.08);
          border-color: #667eea;
          box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
          color: #fff;
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
          transition: all 0.3s ease;
          box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-game-primary:hover:not(:disabled) {
          transform: translateY(-2px);
          box-shadow: 0 12px 35px rgba(102, 126, 234, 0.4);
          background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
        }
        
        .btn-game-primary:disabled {
          opacity: 0.6;
          transform: none;
          box-shadow: 0 4px 15px rgba(102, 126, 234, 0.2);
        }
        
        .form-label {
          color: #fff;
          font-weight: 600;
          margin-bottom: 0.8rem;
          text-transform: uppercase;
          font-size: 0.85rem;
          letter-spacing: 0.5px;
        }
        
        .help-card {
          background: rgba(255, 255, 255, 0.02);
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 16px;
          backdrop-filter: blur(10px);
        }
        
        .help-card .card-body {
          padding: 1.5rem;
        }
        
        .help-title {
          color: #64ffda;
          font-weight: 600;
          margin-bottom: 1rem;
        }
        
        .help-list li {
          color: rgba(255, 255, 255, 0.7);
          margin-bottom: 0.5rem;
          padding-left: 0.5rem;
        }
        
        .alert {
          border-radius: 12px;
          backdrop-filter: blur(10px);
          border: none;
          font-weight: 500;
        }
        
        .alert-success {
          background: rgba(76, 175, 80, 0.15);
          color: #4caf50;
          border: 1px solid rgba(76, 175, 80, 0.3);
        }
        
        .alert-danger {
          background: rgba(244, 67, 54, 0.15);
          color: #f44336;
          border: 1px solid rgba(244, 67, 54, 0.3);
        }
        
        .alert-warning {
          background: rgba(255, 193, 7, 0.15);
          color: #ffc107;
          border: 1px solid rgba(255, 193, 7, 0.3);
        }
        
        .btn-close {
          filter: invert(1);
          opacity: 0.8;
        }
        
        .spinner-border-sm {
          width: 1rem;
          height: 1rem;
        }
        
        .game-icon {
          font-size: 1.5rem;
          margin-right: 0.5rem;
          filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
        }
        
        @keyframes pulse-glow {
          0%, 100% { box-shadow: 0 0 20px rgba(102, 126, 234, 0.3); }
          50% { box-shadow: 0 0 30px rgba(102, 126, 234, 0.5); }
        }
        
        .form-control:focus {
          animation: pulse-glow 2s infinite;
        }
      `}</style>
      
      <div className="min-vh-100 d-flex align-items-center py-5">
        <div className="container">
          <div className="row justify-content-center">
            <div className="col-md-8 col-lg-6">
              <div className="game-container">
                <div className="game-header text-center">
                  <h3 className="mb-0">
                    <i className="bi bi-controller game-icon"></i>
                    Game Code Manager
                  </h3>
                  <p className="mb-0 mt-2 opacity-75">Thêm mã code cho game của bạn</p>
                </div>
                
                <div className="game-body">
                  <div className="mb-4">
                    <label htmlFor="gameId" className="form-label">
                      <i className="bi bi-hash me-2"></i>
                      ID Game
                    </label>
                    <div className="input-group">
                      <span className="input-group-text">
                        <i className="bi bi-joystick"></i>
                      </span>
                      <input
                        type="text"
                        className="form-control"
                        id="gameId"
                        placeholder="Nhập ID game (vd: game_01)"
                        value={gameId}
                        onChange={(e) => setGameId(e.target.value)}
                        disabled={isLoading}
                        onKeyPress={(e) => e.key === 'Enter' && handleAddCode()}
                      />
                    </div>
                  </div>

                  <div className="mb-4">
                    <label htmlFor="newCode" className="form-label">
                      <i className="bi bi-key me-2"></i>
                      Mã Code Mới
                    </label>
                    <div className="input-group">
                      <span className="input-group-text">
                        <i className="bi bi-shield-lock"></i>
                      </span>
                      <input
                        type="text"
                        className="form-control"
                        id="newCode"
                        placeholder="Nhập mã code mới"
                        value={newCode}
                        onChange={(e) => setNewCode(e.target.value)}
                        disabled={isLoading}
                        onKeyPress={(e) => e.key === 'Enter' && handleAddCode()}
                      />
                    </div>
                  </div>

                  <div className="d-grid gap-2 mb-4">
                    <button 
                      type="button"
                      className="btn btn-game-primary btn-lg"
                      disabled={isLoading || !gameId || !newCode}
                      onClick={handleAddCode}
                    >
                      {isLoading ? (
                        <>
                          <span className="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                          Đang xử lý...
                        </>
                      ) : (
                        <>
                          <i className="bi bi-plus-circle me-2"></i>
                          Thêm Code
                        </>
                      )}
                    </button>
                  </div>

                  {status && (
                    <div className={`${getStatusClass()} mb-0`} role="alert">
                      <div className="d-flex align-items-center">
                        <div className="flex-grow-1">
                          {status}
                        </div>
                        <button 
                          type="button" 
                          className="btn-close" 
                          aria-label="Close"
                          onClick={() => setStatus("")}
                        ></button>
                      </div>
                    </div>
                  )}
                </div>
              </div>

              {/* Help Card */}
              <div className="help-card mt-4">
                <div className="card-body">
                  <h6 className="help-title">
                    <i className="bi bi-lightbulb me-2"></i>
                    Hướng dẫn sử dụng
                  </h6>
                  <ul className="list-unstyled help-list mb-0">
                    <li><i className="bi bi-arrow-right-circle me-2 text-info"></i>Nhập ID của game bạn muốn thêm code</li>
                    <li><i className="bi bi-arrow-right-circle me-2 text-info"></i>Nhập mã code mới cần thêm vào game</li>
                    <li><i className="bi bi-arrow-right-circle me-2 text-info"></i>Nhấn "Thêm Code" để lưu vào cơ sở dữ liệu</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default AddGameCode;