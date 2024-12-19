import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  final dynamic userData;  // Nhận dữ liệu người dùng từ HomeScreen

  const ReservationScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome ${userData['email']}!',
              style: const TextStyle(fontSize: 24),
            ),
            // Bạn có thể thêm giao diện cho việc đặt chỗ ở đây
          ],
        ),
      ),
    );
  }
}
