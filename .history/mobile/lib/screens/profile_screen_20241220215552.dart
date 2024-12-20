import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final dynamic userData;

  ProfileScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 30, color: Colors.white),
            onPressed: () {
              // Gọi hàm đăng xuất để quay lại màn hình đăng nhập
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Phần thông tin người dùng
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(userData['userAvatar']),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userData['fullName'] ?? 'No name',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userData['email'] ?? 'No email',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userData['phoneNumber'] ?? 'No phone number',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm đăng xuất và quay về màn hình đăng nhập
  void _logout(BuildContext context) {
    // Xóa bất kỳ dữ liệu người dùng nào (nếu có)
    // Ví dụ: SharedPreferences.remove('userToken') nếu có lưu thông tin đăng nhập

    // Điều hướng về màn hình đăng nhập
    Navigator.pushReplacementNamed(context, '/login');
  }
}
