import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:mobile/screens/profile_screen.dart';
import 'package:mobile/screens/reservation_screen.dart';

class HomeScreen extends StatefulWidget {
  final dynamic userData;
  final String condition;

  const HomeScreen({
    Key? key,
    required this.userData,
    required this.condition,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late dynamic userBill;
  late String reservationSlot;
  late String reservationTime;

  @override
  void initState() {
    super.initState();
    userBill = {
      'userID': widget.userData['userID'],
      'slot': 'INACTIVE',
      'fee': '0',
      'timeIn': 'None',
    };
    reservationSlot = 'None';
    reservationTime = 'None';
    updateState();
  }

  void updateState() async {
    try {
      String url = 'http://10.0.2.2:8000/bills/${widget.userData['userID']}';
      Response response = await get(Uri.parse(url));
      var billData = jsonDecode(response.body);

      setState(() {
        userBill = billData.isNotEmpty ? billData[0] : userBill;
        reservationSlot = billData.isNotEmpty ? billData[0]['slot'] : 'None';
        reservationTime = billData.isNotEmpty
            ? DateTime.parse(billData[0]['reservedAt'])
                .toLocal()
                .toString()
                .split('.')[0]
            : 'None';
      });
    } catch (e) {}
  }

  void navigateToReservationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          userData: widget.userData,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        reservationSlot = result['slot'];
        reservationTime = DateTime.parse(result['reservedAt'])
            .toLocal()
            .toString()
            .split('.')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userData: widget.userData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: updateState,
        child: const Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.local_parking,
                            color: Colors.green),
                        title: const Text(
                          'Reserved Slot',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text(
                          reservationSlot,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.schedule, color: Colors.green),
                        title: const Text(
                          'Reservation Time',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text(
                          reservationTime,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onPressed: navigateToReservationScreen,
                child: const Text(
                  'Reserve a Slot',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReservationScreen extends StatefulWidget {
  final dynamic userData;

  const ReservationScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  void reserveSlot() {
    final reservationData = {
      'slot': 'A12',
      'reservedAt': DateTime.now().toString(),
    };

    Navigator.pop(context, reservationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: reserveSlot,
          child: const Text('Confirm Reservation'),
        ),
      ),
    );
  }
}
