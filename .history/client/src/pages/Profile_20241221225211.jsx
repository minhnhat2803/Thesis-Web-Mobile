import React, { useState, useEffect } from "react";
import styles from "../styles/pages/Profile.module.css";
import { auth } from "../config/firebase";
import { createUserWithEmailAndPassword, signInWithEmailAndPassword } from "firebase/auth";
import { useAuth } from "../config/AuthContext"; // Import AuthContext để quản lý đăng nhập

function Profile() {
  const { login, logout } = useAuth(); // Lấy các hàm login và logout từ AuthContext
  const [isLogin, setIsLogin] = useState(true);
  const [userInfo, setUserInfo] = useState(null);
  const [showPassword, setShowPassword] = useState(false);

  useEffect(() => {
    const storedUserInfo = localStorage.getItem("userInfo");
    if (storedUserInfo) {
      setUserInfo(JSON.parse(storedUserInfo));
    }
  }, []);

  useEffect(() => {
    if (userInfo) {
      localStorage.setItem("userInfo", JSON.stringify(userInfo));
    }
  }, [userInfo]);

  const handleLoginSubmit = async (e) => {
    e.preventDefault();
    const email = e.target.elements[0].value;
    const password = e.target.elements[1].value;

    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const currentDateTime = new Date().toLocaleString();
      const loggedInUserInfo = {
        email: userCredential.user.email,
        lastLogin: currentDateTime,
      };

      login(loggedInUserInfo); // Cập nhật trạng thái đăng nhập trong AuthContext
      setUserInfo(loggedInUserInfo);
    } catch (error) {
      alert("Login failed: " + error.message);
    }
  };

  const handleRegisterSubmit = async (e) => {
    e.preventDefault();
    const email = e.target.elements[0].value;
    const password = e.target.elements[1].value;
    const confirmPassword = e.target.elements[2].value;

    if (password !== confirmPassword) {
      alert("Passwords do not match!");
      return;
    }

    try {
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);
      const registeredUserInfo = {
        email: userCredential.user.email,
        lastLogin: new Date().toLocaleString(),
      };

      login(registeredUserInfo); // Cập nhật trạng thái đăng nhập trong AuthContext
      setUserInfo(registeredUserInfo);
      setIsLogin(true);
    } catch (error) {
      alert("Registration failed: " + error.message);
    }
  };

  const handleLogout = () => {
    setUserInfo(null);
    logout(); // Xóa trạng thái đăng nhập từ AuthContext
    localStorage.removeItem("userInfo");
  };

  return (
    <div className={styles.profileContainer}>
      <div className={styles.formContainer}>
        {userInfo ? (
          <div className={styles.profileDetails}>
            <h2>Profile Information</h2>
            <p>Email: {userInfo.email}</p>
            <p>Last Login: {userInfo.lastLogin}</p>
            <p>
              Password: <span>{showPassword ? userInfo.password : "******"}</span>
              <button onClick={() => setShowPassword(!showPassword)}>
                {showPassword ? "Hide" : "Show"}
              </button>
            </p>
            <button onClick={handleLogout}>Logout</button>
          </div>
        ) : isLogin ? (
          <div className={styles.loginForm}>
            <h2>LOGIN</h2>
            <form onSubmit={handleLoginSubmit}>
              <label>Email: <input type="email" required /></label>
              <label>Password: <input type="password" required /></label>
              <button type="submit">Login</button>
            </form>
            <p className={styles.toggleForm}>
              Don't have an account?{" "}
              <span onClick={() => setIsLogin(false)} className={styles.registerLink}>Register</span>
            </p>
          </div>
        ) : (
          <div className={styles.registerForm}>
            <h2>REGISTER</h2>
            <form onSubmit={handleRegisterSubmit}>
              <label>Email: <input type="email" required /></label>
              <label>Password: <input type="password" required /></label>
              <label>Confirm Password: <input type="password" required /></label>
              <button type="submit">Register</button>
            </form>
            <p className={styles.toggleForm}>
              Already have an account?{" "}
              <span onClick={() => setIsLogin(true)} className={styles.loginLink}>Login</span>
            </p>
          </div>
        )}
      </div>
    </div>
  );
}

export default Profile;
