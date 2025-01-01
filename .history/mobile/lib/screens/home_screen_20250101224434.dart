import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:mobile/screens/profile_screen.dart';
import 'package:mobile/screens/reservation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    userBill = {
      'userID': widget.userData['userID'],
      'slot': 'INACTIVE',
      'fee': '0',
      'timeIn': 'None',
    };
    updateState();
    loadReservationData();
  }

  void updateState() async {
    try {
      String url = 'http://10.0.2.2:8000/bills/${widget.userData['userID']}';
      Response response = await get(Uri.parse(url));
      var billData = jsonDecode(response.body);

      setState(() {
        userBill = billData.isNotEmpty ? billData[0] : userBill;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void loadReservationData() async {
    try {
      QuerySnapshot reservationSnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('email', isEqualTo: widget.userData['email'])
          .get();

      if (reservationSnapshot.docs.isNotEmpty) {
        var reservationData = reservationSnapshot.docs.first.data() as Map<String, dynamic>;
        Timestamp reservedAt = reservationData['reservedAt'] as Timestamp;
        String formattedTime = "${reservedAt.toDate().toLocal()}".split('.')[0]; 

        setState(() {
          userBill['slot'] = reservationData['slot'];
          userBill['timeIn'] = formattedTime;
        });
      } else {
        setState(() {
          userBill['slot'] = 'INACTIVE';
          userBill['timeIn'] = 'None';
        });
      }
    } catch (e) {
      print('Error loading reservation data: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
        onPressed: () {
          updateState();
          loadReservationData();
        },
        child: const Icon(Icons.refresh),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade800, Colors.green.shade400],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.condition == 'login'
                                  ? 'ASPS - Smart Parking App'
                                  : 'Welcome!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.email, color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  widget.userData['email'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.directions_car,
                                    color: Colors.green),
                                const SizedBox(width: 8),
                                Text(
                                  widget.userData['userLicensePlate'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                              leading: const Icon(Icons.access_time,
                                  color: Colors.green),
                              title: const Text(
                                'Time In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Text(
                                userBill['timeIn'] ?? 'None',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.local_parking,
                                  color: Colors.green),
                              title: const Text(
                                'Slot Number',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Text(
                                userBill['slot'] ?? 'None',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.money, color: Colors.green),
                              title: const Text(
                                'Parking Fee',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              subtitle: Text(
                                '${userBill['fee']} VND',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade700, Colors.green.shade900],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReservationScreen(
                                userData: widget.userData,
                              ),
                            ),
                          );

                          if (result == true) {
                            loadReservationData();
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.local_parking, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Reserve a Slot',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}