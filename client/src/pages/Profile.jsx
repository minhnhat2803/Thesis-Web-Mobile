import React, { useState } from "react";
import styles from "../styles/pages/Profile.module.css";
import { auth } from "../config/firebase"; // Import auth từ Firebase config
import { createUserWithEmailAndPassword, signInWithEmailAndPassword } from "firebase/auth";

function Profile() {
  const [isLogin, setIsLogin] = useState(true);
  const [userInfo, setUserInfo] = useState(null);
  const [showPassword, setShowPassword] = useState(false);
  const [selectedImage, setSelectedImage] = useState(null);

  // Đăng nhập
  const handleLoginSubmit = async (e) => {
    e.preventDefault();
    const email = e.target.elements[0].value;
    const password = e.target.elements[1].value;

    try {
      // Đăng nhập với Firebase
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const currentDateTime = new Date().toLocaleString();

      setUserInfo({
        email: userCredential.user.email,
        lastLogin: currentDateTime,
      });
    } catch (error) {
      alert("Login failed: " + error.message);
    }
  };

  // Đăng ký
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
      // Đăng ký với Firebase
      const userCredential = await createUserWithEmailAndPassword(auth, email, password);

      setUserInfo({
        email: userCredential.user.email,
        lastLogin: new Date().toLocaleString(),
        profilePicture: selectedImage,
      });

      setIsLogin(true);
    } catch (error) {
      alert("Registration failed: " + error.message);
    }
  };

  const handleImageChange = (e) => {
    setSelectedImage(e.target.files[0]);
  };

  const handleLogout = () => {
    setUserInfo(null);
  };

  return (
    <div className={styles.profileContainer}>
      <div className={styles.formContainer}>
        {userInfo ? (
          <div className={styles.profileDetails}>
            <h2>Profile Information</h2>
            {userInfo.profilePicture && (
              <img src={URL.createObjectURL(userInfo.profilePicture)} alt="Profile" width="100" />
            )}
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
              <label>Profile Picture: <input type="file" accept="image/*" onChange={handleImageChange} /></label>
              {selectedImage && (
                <div>
                  <p>Selected image: {selectedImage.name}</p>
                  <img src={URL.createObjectURL(selectedImage)} alt="Selected" width="100" />
                </div>
              )}
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
