import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic userData;

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot;
  final List<String> availableSlots = [
    'A1',
    'A2',
    'B1',
    'B2',
    'C1',
    'C2',
    'D1',
    'D2',
  ];
  List<String> userReservations = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUserReservations();
  }

  void loadUserReservations() async {
    try {
      QuerySnapshot allReservations = await firestore.collection('reservations').get();
      QuerySnapshot userReservationsSnapshot = await firestore
          .collection('reservations')
          .where('email', isEqualTo: widget.userData['email'])
          .get();

      setState(() {
        userReservations = userReservationsSnapshot.docs
            .map((doc) => doc['slot'] as String)
            .toList();

        for (var doc in allReservations.docs) {
          availableSlots.remove(doc['slot']);
        }
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

      QuerySnapshot existingReservation = await firestore
          .collection('reservations')
          .where('email', isEqualTo: widget.userData['email'])
          .get();

      if (existingReservation.docs.isNotEmpty) {
        await EasyLoading.showError('You have already reserved a slot');
        return;
      }

      QuerySnapshot slotCheck = await firestore
          .collection('reservations')
          .where('slot', isEqualTo: selectedSlot)
          .get();

      if (slotCheck.docs.isNotEmpty) {
        await EasyLoading.showError('This slot has already been reserved');
        return;
      }

      await EasyLoading.show(
          status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      String reservationID = firestore.collection('reservations').doc().id;

      await firestore.collection('reservations').doc(reservationID).set({
        'email': widget.userData['email'],
        'reservationID': reservationID,
        'reservedAt': DateTime.now(),
        'slot': selectedSlot,
      });

      setState(() {
        userReservations.add(selectedSlot!);
        selectedSlot = null;
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
          style: TextStyle(fontWeight: FontWeight.bold),
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
                              selectedSlot = slot;
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
