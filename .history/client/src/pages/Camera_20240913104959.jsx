import React, { useEffect, useState } from 'react';
import styles from '../styles/pages/Camera.module.css';

const Camera = () => {
  const [cameraFeeds, setCameraFeeds] = useState([]);

  // Giả sử bạn có danh sách các camera RTSP URL từ Raspberry Pi
  const cameraUrls = [
    'rtsp://raspberrypi1:8554/cam1',
    'rtsp://raspberrypi2:8554/cam2',
    'rtsp://raspberrypi2:8554/cam2',
    'rtsp://raspberrypi2:8554/cam2',
    'rtsp://raspberrypi2:8554/cam2',
    'rtsp://raspberrypi2:8554/cam2',
    'rtsp://raspberrypi2:8554/cam2',
    'rtsp://raspberrypi2:8554/cam2',
    'rtsp://raspberrypi2:8554/cam2',
  
    // Thêm URL camera theo số lượng
  ];

  useEffect(() => {
    // Lấy thông tin danh sách camera từ backend hoặc API
    setCameraFeeds(cameraUrls);
  }, []);

  return (
    <div>
      {/* <h1>Camera Feeds</h1> */}
      <div className={styles.cameraContainer}>
        {cameraFeeds.map((url, index) => (
          <div key={index} className={styles.cameraFeed}>
            <h2 className={styles.cameraTitle}>Camera {index + 1}</h2>
            <video
              className={styles.cameraVideo}
              controls
              autoPlay
              muted
              src={url}
            />
          </div>
        ))}
      </div>
    </div>
  );
};

export default Camera;
