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
  List<String> availableSlots = []; // Danh sách các slot khả dụng

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  // Fetch slots from the server
  Future<void> _fetchSlots() async {
    try {
      String userID = widget.userData['userID'];
      String slotsUrl = 'http://10.0.2.2:8000/slots/$userID'; // Adjust the URL if needed
      final response = await http.get(Uri.parse(slotsUrl));

      if (response.statusCode == 200) {
        List<String> fetchedSlots = List<String>.from(jsonDecode(response.body));
        setState(() {
          availableSlots = fetchedSlots;
        });
      } else if (response.statusCode == 404) {
        await EasyLoading.showError('Slots not found. Please check the endpoint.');
      } else {
        await EasyLoading.showError('Failed to load slots. Status code: ${response.statusCode}');
      }
    } catch (e) {
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  // Save slots to Firestore
  Future<void> saveSlotsToFirestore(List<String> slots) async {
    try {
      // Assuming 'userID' is part of widget.userData
      String userID = widget.userData['userID'];

      CollectionReference slotsRef = FirebaseFirestore.instance.collection('slots');
      for (var slot in slots) {
        await slotsRef.add({
          'userID': userID,
          'slot': slot,
          'status': 'available', // Adjust status if needed
        });
      }

      await EasyLoading.showSuccess('Slots saved to Firestore');
    } catch (e) {
      await EasyLoading.showError('Failed to save slots: ${e.toString()}');
    }
  }

  void confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      await EasyLoading.show(status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      // Save the selected slot to Firestore
      await saveSlotsToFirestore([selectedSlot!]);

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
                ? const Center(child: CircularProgressIndicator())
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
