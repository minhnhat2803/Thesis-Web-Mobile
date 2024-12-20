import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Nhận dữ liệu người dùng từ HomeScreen

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Lưu trữ slot được chọn
  List<String> availableSlots = []; // Các slot khả dụng, lấy từ API hoặc database

  @override
  void initState() {
    super.initState();
    fetchSlots(); // Fetch slots when screen is loaded
  }

  // Fetch slots from the API
  void fetchSlots() async {
    try {
      String slotsUrl = 'http://10.0.2.2:8000/slots/${widget.userData['userID']}';
      var response = await http.get(Uri.parse(slotsUrl));

      if (response.statusCode == 200) {
        var slotsData = jsonDecode(response.body);

        if (slotsData.isEmpty) {
          // If no slots are returned, use default slots
          slotsData = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
        }

        setState(() {
          availableSlots = List<String>.from(slotsData);
        });

        // Save slots to Firestore
        saveSlotsToFirestore(availableSlots);
      } else {
        await EasyLoading.showError('Failed to load slots. Status code: ${response.statusCode}');
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      await EasyLoading.showError('An error occurred: ${e.toString()}');
      print('Exception: $e');
    }
  }

  // Save slots to Firestore
  void saveSlotsToFirestore(List<String> slots) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Assuming you are saving slots in a collection 'slots'
      await firestore.collection('slots').doc('availableSlots').set({
        'slots': slots,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Slots saved to Firestore');
    } catch (e) {
      print('Error saving slots to Firestore: $e');
    }
  }

  // Confirm reservation
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
            Expanded(
              child: availableSlots.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
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
