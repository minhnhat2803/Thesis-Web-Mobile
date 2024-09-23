import React, { useEffect, useState } from 'react';

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
    // Thêm URL camera theo số lượng
  ];

  useEffect(() => {
    // Lấy thông tin danh sách camera từ backend hoặc API
    // Giả sử cameraUrls là danh sách RTSP URL
    setCameraFeeds(cameraUrls);
  }, []);

  return (
    <div>
      <h1>Camera Feeds</h1>
      <div style={{ display: 'flex', flexWrap: 'wrap' }}>
        {cameraFeeds.map((url, index) => (
          <div key={index} style={{ margin: '10px' }}>
            <h2>Camera {index + 1}</h2>
            {/* Dùng thẻ video để phát luồng camera */}
            <video
              width="400"
              height="300"
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
