import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Nhận dữ liệu người dùng từ HomeScreen

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Lưu trữ slot được chọn
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> availableSlots = []; // Danh sách slot khả dụng

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots();
  }

  Future<void> fetchAvailableSlots() async {
    try {
      final snapshot = await _firestore
          .collection('slots')
          .where('status', isEqualTo: 'available')
          .get();

      setState(() {
        availableSlots = snapshot.docs.map((doc) => doc['slot_id'] as String).toList();
      });
    } catch (e) {
      await EasyLoading.showError('Failed to fetch slots: ${e.toString()}');
    }
  }

  Future<void> confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      await EasyLoading.show(
          status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      // Lấy thông tin userID từ widget.userData
      final String userID = widget.userData['userID'];

      // Cập nhật thông tin slot trong Firestore
      await _firestore.collection('slots').doc(selectedSlot).update({
        'status': 'reserved',
        'reserved_by': userID,
        'reserved_at': FieldValue.serverTimestamp(),
      });

      await EasyLoading.dismiss();
      await EasyLoading.showSuccess('Reservation successful');

      // Cập nhật lại danh sách slot khả dụng
      fetchAvailableSlots();

      setState(() {
        selectedSlot = null; // Reset lựa chọn
      });
    } catch (e) {
      await EasyLoading.dismiss();
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
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
              child: availableSlots.isEmpty
                  ? const Center(child: Text('No available slots'))
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
