import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Firebase Firestore import
import 'package:http/http.dart' as http;  // Import http package
import 'dart:convert';  // Import dart:convert for jsonDecode

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Nhận dữ liệu người dùng từ HomeScreen

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Lưu trữ slot được chọn
  List<String> availableSlots = []; // Các slot khả dụng, sẽ fetch từ API

  @override
  void initState() {
    super.initState();
    fetchSlots(); // Gọi hàm fetch slots khi màn hình khởi tạo
  }

  void fetchSlots() async {
    try {
      // Giả lập fetch từ API
      String slotsUrl = 'http://10.0.2.2:8000/slots/${widget.userData['userID']}'; // Lấy thông tin slots của user
      var response = await http.get(Uri.parse(slotsUrl));  // Use http.get

      if (response.statusCode == 200) {
        var slotsData = jsonDecode(response.body);  // Use jsonDecode

        // Giả lập dữ liệu nếu không có response từ server
        if (slotsData.isEmpty) {
          slotsData = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']; // Dữ liệu mặc định
        }

        setState(() {
          availableSlots = List<String>.from(slotsData);
        });

        // Lưu slots vào Firestore
        await saveSlotsToFirestore(availableSlots);
      } else {
        await EasyLoading.showError('Failed to load slots');
      }
    } catch (e) {
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  void saveSlotsToFirestore(List<String> slots) async {
    try {
      // Lưu thông tin slot vào Firestore
      await FirebaseFirestore.instance.collection('slots').doc(widget.userData['userID']).set({
        'slots': slots,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("Slots saved to Firestore successfully!");
    } catch (e) {
      print("Failed to save slots to Firestore: ${e.toString()}");
    }
  }

  void confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      // Giả lập xác nhận đặt slot thành công
      await EasyLoading.show(
          status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      // Thêm code gửi dữ liệu đến server nếu cần
      // Ví dụ:
      // String url = 'http://10.0.2.2:8000/reserve';
      // Response response = await post(Uri.parse(url), body: {
      //   'userID': widget.userData['userID'],
      //   'slot': selectedSlot,
      // });
      // var jsonResponse = jsonDecode(response.body);
      // if (jsonResponse['statusCode'] == '200') {
      //   ...
      // }

      await EasyLoading.dismiss();
      await EasyLoading.showSuccess('Reservation successful');
    } catch (e) {
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
            availableSlots.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Loading indicator khi chưa có dữ liệu
                : Expanded(
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
