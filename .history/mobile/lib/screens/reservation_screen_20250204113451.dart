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
  List<String> availableSlots = [];
  List<String> userReservations = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUserReservations();
    _listenToSlots();
  }

  void _listenToSlots() {
    firestore.collection('parkingSlots').snapshots().listen((snapshot) {
      setState(() {
        availableSlots = snapshot.docs
            .where((doc) => doc['activity'] == 'available')
            .map((doc) => doc.id)
            .toList();
      });
    });
  }

  void loadUserReservations() async {
    try {
      QuerySnapshot userReservationsSnapshot = await firestore
          .collection('reservations')
          .where('email', isEqualTo: widget.userData['email'])
          .get();

      QuerySnapshot unavailableSlots = await firestore
          .collection('parkingSlots')
          .where('activity', isEqualTo: 'unavailable')
          .get();

      setState(() {
        userReservations = userReservationsSnapshot.docs
            .map((doc) => doc['slot'] as String)
            .toList();

        availableSlots.removeWhere((slot) =>
            userReservations.contains(slot) ||
            unavailableSlots.docs.any((doc) => doc.id == slot));
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

      DocumentSnapshot slotSnapshot = await firestore
          .collection('parkingSlots')
          .doc(selectedSlot)
          .get();

      if (slotSnapshot['activity'] != 'available') {
        await EasyLoading.showError('This slot is no longer available');
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

      await firestore.collection('parkingSlots').doc(selectedSlot).update({
        'activity': 'unavailable',
      });

      setState(() {
        userReservations.add(selectedSlot!);
        availableSlots.remove(selectedSlot);
        selectedSlot = null;
      });

      await EasyLoading.dismiss();
      await EasyLoading.showSuccess('Reservation successful');

      Navigator.pop(context, true);
    } catch (e) {
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  void cancelReservation() async {
    try {
      if (userReservations.isEmpty) {
        await EasyLoading.showError('No reservation to cancel');
        return;
      }

      await EasyLoading.show(
          status: 'Cancelling reservation...', maskType: EasyLoadingMaskType.black);

      QuerySnapshot userReservationSnapshot = await firestore
          .collection('reservations')
          .where('email', isEqualTo: widget.userData['email'])
          .get();

      if (userReservationSnapshot.docs.isNotEmpty) {
        String reservationID = userReservationSnapshot.docs.first.id;
        String cancelledSlot = userReservations.first;

        await firestore.collection('reservations').doc(reservationID).delete();
        await firestore.collection('parkingSlots').doc(cancelledSlot).update({
          'activity': 'available',
        });

        setState(() {
          userReservations.clear();
          availableSlots.add(cancelledSlot);
        });

        await EasyLoading.dismiss();
        await EasyLoading.showSuccess('Reservation cancelled successfully');

        Navigator.pop(context, true);
      } else {
        await EasyLoading.showError('No reservation found to cancel');
      }
    } catch (e) {
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Reservations:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            userReservations.isNotEmpty
                ? Column(children: userReservations.map((slot) => ListTile(title: Text('Slot $slot'))).toList())
                : const Text('You have no reservations yet.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Available Slots:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: availableSlots.length,
                itemBuilder: (context, index) {
                  String slot = availableSlots[index];
                  return ListTile(
                    title: Text('Slot $slot', style: TextStyle(fontSize: 18)),
                    onTap: () {
                      setState(() {
                        selectedSlot = slot;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: confirmReservation, child: const Text('Confirm'))),
                const SizedBox(width: 16),
                Expanded(child: ElevatedButton(onPressed: userReservations.isNotEmpty ? cancelReservation : null, child: const Text('Cancel'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
