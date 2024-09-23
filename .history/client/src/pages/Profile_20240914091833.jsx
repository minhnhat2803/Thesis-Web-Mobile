import React, { useState } from "react";
import styles from "../styles/pages/Profile.module.css";

function Profile() {
  const [isLogin, setIsLogin] = useState(true);
  const [selectedImage, setSelectedImage] = useState(null);
  const [userInfo, setUserInfo] = useState(null); // Lưu thông tin người dùng sau khi đăng nhập
  const [showPassword, setShowPassword] = useState(false); // Để ẩn/hiện mật khẩu

  const toggleForm = () => {
    setIsLogin(!isLogin);
  };

  const handleImageChange = (e) => {
    setSelectedImage(e.target.files[0]);
  };

  const handleLoginSubmit = (e) => {
    e.preventDefault();
    const email = e.target.elements[0].value;
    const password = e.target.elements[1].value;

    // Lấy thời gian hiện tại
    const currentDateTime = new Date().toLocaleString();

    // Giả sử đăng nhập thành công, lưu thông tin người dùng
    setUserInfo({
      email,
      password,
      profilePicture: userInfo?.profilePicture || selectedImage,
      fullName: userInfo?.fullName || "Nguyễn Văn A", // Thông tin ví dụ nếu chưa có
      workingHours: userInfo?.workingHours || "Ca sáng (7:00 - 15:00)",
      contactEmail: email,
      phoneNumber: userInfo?.phoneNumber || "0123456789",
      lastLogin: currentDateTime, // Thời gian đăng nhập gần nhất
      activityHistory: userInfo?.activityHistory || [
        "Thêm xe mới vào bãi lúc 08:55",
        "Sửa thông tin xe lúc 09:30",
      ],
      parkingInfo: userInfo?.parkingInfo || "Bãi xe số 1, 123 Đường A, Quận B",
      status: userInfo?.status || "Đang hoạt động",
    });
  };

  const handleRegisterSubmit = (e) => {
    e.preventDefault();
    const fullName = e.target.elements[0].value;
    const email = e.target.elements[1].value;
    const phoneNumber = e.target.elements[2].value;
    const password = e.target.elements[3].value;
    const confirmPassword = e.target.elements[4].value;

    if (password === confirmPassword) {
      // Lưu thông tin người dùng
      setUserInfo({
        fullName,
        email,
        phoneNumber,
        password,
        profilePicture: selectedImage,
        workingHours: "Ca sáng (7:00 - 15:00)",
        contactEmail: email,
        phoneNumber: phoneNumber,
        lastLogin: new Date().toLocaleString(),
        activityHistory: [
          "Thêm xe mới vào bãi lúc 08:55",
          "Sửa thông tin xe lúc 09:30",
        ],
        parkingInfo: "Bãi xe số 1, 123 Đường A, Quận B",
        status: "Đang hoạt động",
      });
      // Quay về màn hình đăng nhập sau khi đăng ký thành công
      setIsLogin(true);
      // Reset selectedImage sau khi đăng ký thành công
      setSelectedImage(null);
    } else {
      alert("Passwords do not match");
    }
  };

  const handleLogout = () => {
    setUserInfo(null); // Xóa thông tin người dùng
    setIsLogin(true); // Quay về trạng thái đăng nhập
  };

  return (
    <div className={styles.profileContainer}>
      <div className={styles.formContainer}>
        {userInfo ? (
          <div className={styles.profileDetails}>
            <h2>Profile Information</h2>
            {userInfo.profilePicture && (
              <img
                src={URL.createObjectURL(userInfo.profilePicture)}
                alt="Profile"
                width="100"
              />
            )}
            <p>Name: {userInfo.fullName}</p>
            <p>Email: {userInfo.contactEmail}</p>
            <p>Phone Number: {userInfo.phoneNumber}</p>
            <p>Working Hour: {userInfo.workingHours}</p>
            <p>Last Login: {userInfo.lastLogin}</p>
            <p>Activity History:</p>
            <ul>
              {userInfo.activityHistory.map((activity, index) => (
                <li key={index}>{activity}</li>
              ))}
            </ul>
            <p>Permission: {userInfo.permissions}</p>
            <p>Parking Information: {userInfo.parkingInfo}</p>
            <p>Status: {userInfo.status}</p>
            <p>
              Password:{" "}
              <span>
                {showPassword ? userInfo.password : "******"}
              </span>
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
              <label>
                Email:
                <input type="email" required />
              </label>
              <label>
                Password:
                <input type="password" required />
              </label>
              <button type="submit">Login</button>
            </form>
            <p className={styles.toggleForm}>
              Don't have an account?{" "}
              <span onClick={toggleForm} className={styles.registerLink}>
                Register
              </span>
            </p>
          </div>
        ) : (
          <div className={styles.registerForm}>
            <h2>Register</h2>
            <form onSubmit={handleRegisterSubmit}>
              <label>
                Full Name:
                <input type="text" required />
              </label>
              <label>
                Email:
                <input type="email" required />
              </label>
              <label>
                Phone Number:
                <input type="text" required />
              </label>
              <label>
                Password:
                <input type="password" required />
              </label>
              <label>
                Confirm Password:
                <input type="password" required />
              </label>
              <label>
                Profile Picture:
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleImageChange}
                />
              </label>
              {selectedImage && (
                <div>
                  <p>Selected image: {selectedImage.name}</p>
                  <img
                    src={URL.createObjectURL(selectedImage)}
                    alt="Selected"
                    width="100"
                  />
                </div>
              )}
              <button type="submit">Register</button>
            </form>
            <p className={styles.toggleForm}>
              Already have an account?{" "}
              <span onClick={toggleForm} className={styles.loginLink}>
                Login
              </span>
            </p>
          </div>
        )}
      </div>
    </div>
  );
}

export default Profile;
