import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Receive user data from HomeScreen

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Store selected slot
  List<String> availableSlots = []; // List to store available slots

  // Fetch slots from the server
  Future<void> _fetchSlots() async {
    try {
      String userID = widget.userData['userID'];
      String slotsUrl = 'http://10.0.2.2:8000/slots/$userID'; // Ensure the correct endpoint

      // Fetch the slots from the server
      var response = await http.get(Uri.parse(slotsUrl));

      if (response.statusCode == 200) {
        List<String> fetchedSlots = List<String>.from(jsonDecode(response.body));
        setState(() {
          availableSlots = fetchedSlots;
        });
      } else {
        // If no slots found, show an error
        setState(() {
          availableSlots = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']; // Fallback slots
        });
        await EasyLoading.showError('Slots not found, using default slots.');
      }
    } catch (e) {
      // Handle any errors, such as no internet connection
      await EasyLoading.showError('Failed to load slots. Please check the endpoint.');
      setState(() {
        availableSlots = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']; // Fallback slots
      });
    }
  }

  void confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      // Simulate successful slot reservation
      await EasyLoading.show(
        status: 'Reserving slot...',
        maskType: EasyLoadingMaskType.black,
      );

      // Here you can send the reservation request to the server if needed
      // Example:
      // String url = 'http://10.0.2.2:8000/reserve';
      // var response = await post(Uri.parse(url), body: {
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
  void initState() {
    super.initState();
    _fetchSlots(); // Fetch slots when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation',
          style: TextStyle(fontWeight: FontWeight.bold), // Bold text for "Reservation"
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
                        selectedSlot = slot; // Update selected slot
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
