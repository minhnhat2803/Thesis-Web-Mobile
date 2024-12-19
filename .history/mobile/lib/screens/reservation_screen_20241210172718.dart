import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  final dynamic userData;

  ReservationScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reserve Slot',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Số cột trong lưới
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: 10, // Giả sử có 10 slot
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Xử lý khi chọn slot
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Confirm Reservation'),
                    content: Text('Do you want to reserve Slot ${index + 1}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Đóng dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Xử lý lưu thông tin đặt slot
                          Navigator.of(context).pop(); // Đóng dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Slot ${index + 1} reserved successfully!'),
                            ),
                          );
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Center(
                  child: Text(
                    'Slot ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
