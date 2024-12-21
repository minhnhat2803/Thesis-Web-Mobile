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
  List<String> userReservations = []; // Lưu danh sách các slot đã đặt
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUserReservations(); // Load dữ liệu reservation khi màn hình mở
  }

  void loadUserReservations() async {
    try {
      QuerySnapshot reservations = await firestore
          .collection('reservations')
          .where('email', isEqualTo: widget.userData['email'])
          .get();

      setState(() {
        userReservations = reservations.docs
            .map((doc) => doc['slot'] as String)
            .where((slot) => slot.isNotEmpty) // Loại bỏ slot rỗng
            .toList();
      });
    } catch (e) {
      await EasyLoading.showError('Failed to load reservations: ${e.toString()}');
    }
  }

  void confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      if (userReservations.contains(selectedSlot)) {
        await EasyLoading.showError('This slot is already reserved');
        return;
      }

      await EasyLoading.show(
          status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      // Lưu thông tin reservation vào Firestore
      String reservationID = firestore.collection('reservations').doc().id;

      await firestore.collection('reservations').doc(reservationID).set({
        'email': widget.userData['email'],
        'reservationID': reservationID,
        'reservedAt': DateTime.now(),
        'slot': selectedSlot,
      });

      setState(() {
        userReservations.add(selectedSlot!); // Cập nhật danh sách slot đã đặt
        selectedSlot = null; // Reset lựa chọn slot
      });

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
              'Your Reservations:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            if (userReservations.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userReservations.length,
                itemBuilder: (context, index) {
                  String slot = userReservations[index];
                  return ListTile(
                    title: Text(
                      'Slot $slot',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    leading: const Icon(Icons.local_parking, color: Colors.blue),
                  );
                },
              )
            else
              const Text(
                'You have no reservations yet.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            const SizedBox(height: 16),
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
                        color: userReservations.contains(slot)
                            ? Colors.grey
                            : (selectedSlot == slot ? Colors.green : Colors.black87),
                      ),
                    ),
                    trailing: userReservations.contains(slot)
                        ? const Icon(Icons.block, color: Colors.red)
                        : (selectedSlot == slot
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null),
                    onTap: userReservations.contains(slot)
                        ? null
                        : () {
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
