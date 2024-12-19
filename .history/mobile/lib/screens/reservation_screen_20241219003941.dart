import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    'C2'
  ]; // Các slot khả dụng, cô có thể lấy từ API hoặc database

  // Lấy email người dùng hiện tại từ Firebase Auth
  Future<String> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ?? '';
  }

  // Lưu thông tin đặt chỗ vào Firestore
  Future<void> saveReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      await EasyLoading.show(
          status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      // Lấy email người dùng
      String email = await getUserEmail();

      // Lưu thông tin đặt chỗ vào Firestore
      await FirebaseFirestore.instance.collection('reservations').add({
        'userEmail': email,
        'slot': selectedSlot,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await EasyLoading.dismiss();
      await EasyLoading.showSuccess('Reservation successful');
    } catch (e) {
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  void confirmReservation() {
    saveReservation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
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
