import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Nhận dữ liệu người dùng từ HomeScreen

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Lưu trữ slot được chọn
  final List<String> availableSlots = [
    'A1',
    'A2',
    'B1',
    'B2',
    'C1',
    'C2',
    'D1',
    'D2',
  ]; // Các slot khả dụng

  void confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      await EasyLoading.show(
        status: 'Reserving slot...',
        maskType: EasyLoadingMaskType.black,
      );

      // Lấy email từ dữ liệu userData
      String userEmail = widget.userData['email'];

      // Lưu thông tin vào Firestore
      await FirebaseFirestore.instance.collection('reservations').add({
        'email': userEmail, // Email của người dùng đã đăng nhập
        'slot': selectedSlot, // Slot được chọn
        'reservedAt': FieldValue.serverTimestamp(), // Thời gian đặt chỗ
      });

      // Ẩn slot đã chọn khỏi danh sách
      setState(() {
        availableSlots.remove(selectedSlot);
        selectedSlot = null;
      });

      await EasyLoading.dismiss();
      await EasyLoading.showSuccess('Reservation successful');
    } catch (e) {
      await EasyLoading.dismiss();
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation',
          style: TextStyle(fontWeight: FontWeight.bold), // In đậm chữ "Reservation"
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Slots:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: availableSlots.length,
                itemBuilder: (context, index) {
                  String slot = availableSlots[index];
                  return ListTile(
                    title: Text(
                      'Slot $slot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: selectedSlot == slot
                            ? Colors.green
                            : Colors.black87,
                      ),
                    ),
                    trailing: selectedSlot == slot
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        selectedSlot = slot; // Cập nhật slot được chọn
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onPressed: confirmReservation,
              child: const Center(
                child: Text(
                  'Confirm Reservation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
