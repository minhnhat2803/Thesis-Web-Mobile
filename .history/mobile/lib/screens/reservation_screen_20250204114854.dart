import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
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
      QuerySnapshot allReservations = await firestore.collection('reservations').get();
      QuerySnapshot userReservationsSnapshot = await firestore
          .collection('reservations')
          .where('userId', isEqualTo: 'currentUserId') // Replace with actual user ID
          .get();

      setState(() {
        userReservations = userReservationsSnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error loading user reservations: $e');
    }
  }

  void reserveSlot(String slotId) async {
    try {
      await firestore.collection('parkingSlots').doc(slotId).update({
        'activity': 'unavailable',
        'reservedBy': 'currentUserId', // Replace with actual user ID
      });

      setState(() {
        availableSlots.remove(slotId);
        userReservations.add(slotId);
      });
    } catch (e) {
      print('Error reserving slot: $e');
    }
  }

  void releaseSlot(String slotId) async {
    try {
      await firestore.collection('parkingSlots').doc(slotId).update({
        'activity': 'available',
        'reservedBy': null,
      });

      setState(() {
        availableSlots.add(slotId);
        userReservations.remove(slotId);
      });
    } catch (e) {
      print('Error releasing slot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Screen'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: Text('Select a slot'),
            value: selectedSlot,
            onChanged: (String? newValue) {
              setState(() {
                selectedSlot = newValue;
              });
            },
            items: availableSlots.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: selectedSlot != null ? () => reserveSlot(selectedSlot!) : null,
            child: Text('Reserve Slot'),
          ),
          ElevatedButton(
            onPressed: selectedSlot != null ? () => releaseSlot(selectedSlot!) : null,
            child: Text('Release Slot'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userReservations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Reserved Slot: ${userReservations[index]}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}