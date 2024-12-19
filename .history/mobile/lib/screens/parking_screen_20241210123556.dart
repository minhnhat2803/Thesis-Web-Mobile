import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({Key? key}) : super(key: key);

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách slot từ Firestore
  Future<List<Map<String, dynamic>>> fetchSlots() async {
    QuerySnapshot snapshot =
        await _firestore.collection('parkingSlots').get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id, // ID của document (VD: Slot 1)
        ...doc.data() as Map<String, dynamic>,
      };
    }).toList();
  }

  // Đặt slot
  Future<void> bookSlot(String slotId, String licensePlate) async {
    DocumentReference slotRef =
        _firestore.collection('parkingSlots').doc(slotId);

    await slotRef.update({
      'status': 'occupied',
      'licensePlate': licensePlate,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Slot $slotId booked successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Slots'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSlots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final slots = snapshot.data ?? [];

          return ListView.builder(
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              final isAvailable = slot['status'] == 'available';

              return ListTile(
                title: Text(
                  slot['id'],
                  style: TextStyle(
                    color: isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  isAvailable ? 'Available' : 'Occupied',
                  style: const TextStyle(fontSize: 16),
                ),
                onTap: isAvailable
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final licenseController = TextEditingController();

                            return AlertDialog(
                              title: const Text('Enter License Plate'),
                              content: TextField(
                                controller: licenseController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your license plate',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final licensePlate =
                                        licenseController.text.trim();
                                    if (licensePlate.isNotEmpty) {
                                      await bookSlot(
                                          slot['id'], licensePlate);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
