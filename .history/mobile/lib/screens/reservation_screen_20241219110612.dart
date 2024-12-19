import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Nhận thông tin người dùng từ màn hình trước đó

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Lưu trữ slot được chọn
  List<Map<String, dynamic>> availableSlots = []; // Danh sách các slot khả dụng

  @override
  void initState() {
    super.initState();
    fetchAvailableSlots(); // Lấy danh sách các slot khả dụng khi load màn hình
  }

  // Lấy danh sách các slot từ Firestore
  Future<void> fetchAvailableSlots() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('slots')
          .where('status', isEqualTo: 'available')
          .get();

      setState(() {
        availableSlots = snapshot.docs.map((doc) {
          return {
            'slot_id': doc.id,
            'data': doc.data() as Map<String, dynamic>,
          };
        }).toList();
      });
    } catch (e) {
      await EasyLoading.showError('Error loading slots: ${e.toString()}');
    }
  }

  // Xác nhận đặt chỗ
  Future<void> confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      // Tìm slot được chọn trong danh sách
      final slot = availableSlots.firstWhere(
        (slot) => slot['slot_id'] == selectedSlot,
        orElse: () => {},
      );

      if (slot.isEmpty) {
        await EasyLoading.showError('Invalid slot selected');
        return;
      }

      // Cập nhật trạng thái slot trong Firestore
      await FirebaseFirestore.instance
          .collection('slots')
          .doc(selectedSlot)
          .update({
        'status': 'reserved',
        'reserved_by': widget.userData['userID'], // Lưu userID
        'reserved_at': FieldValue.serverTimestamp(), // Lưu thời gian đặt
      });

      // Hiển thị thông báo thành công
      await EasyLoading.showSuccess('Reservation successful');

      // Cập nhật lại danh sách các slot khả dụng
      fetchAvailableSlots();
      setState(() {
        selectedSlot = null; // Reset trạng thái chọn slot
      });
    } catch (e) {
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
              child: ListView.builder(
                itemCount: availableSlots.length,
                itemBuilder: (context, index) {
                  final slot = availableSlots[index];
                  final slotId = slot['slot_id'];
                  final slotData = slot['data'];

                  return ListTile(
                    title: Text(
                      'Slot ${slotId}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: selectedSlot == slotId
                            ? Colors.green
                            : Colors.black87,
                      ),
                    ),
                    trailing: selectedSlot == slotId
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        selectedSlot = slotId; // Cập nhật slot được chọn
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
