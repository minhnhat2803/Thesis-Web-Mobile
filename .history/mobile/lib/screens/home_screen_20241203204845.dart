import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.userData,
    required this.userBill,
    required this.condition,
  }) : super(key: key);

  final dynamic userData;
  final dynamic userBill;
  final String condition;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //update state
  void updateState() async {
    String url = 'http://10.0.2.2:8000/bills/${widget.userData['userID']}';
    Response response = await get(Uri.parse(url));
    var userBill = jsonDecode(response.body);
    if (userBill.isEmpty) {
      userBill = [
        {
          'userID': widget.userData['userID'],
          'slot': 'INACTIVE',
          'fee': '0',
          'timeIn': 'None',
        }
      ];
    }
    setState(() {
      widget.userBill = userBill;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Homepage',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: updateState,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildInfoTile(
                label: 'Time In',
                value: widget.userBill[0]['timeIn'] ?? 'None',
              ),
              _buildInfoTile(
                label: 'Slot Parking Number',
                value: widget.userBill[0]['slot'] ?? 'INACTIVE',
              ),
              _buildInfoTile(
                label: 'Parking Fee',
                value: '${widget.userBill[0]['fee'] ?? '0'} VND',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userData: widget.userData,
                        userBill: widget.userBill,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.person, size: 30, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogInScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, size: 30, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green,
          radius: 40,
          child: const Icon(Icons.person, color: Colors.white, size: 50),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.condition == 'login' ? 'Welcome Back,' : 'Welcome !!!',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            Text(
              widget.userData['email'] ?? '',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.userData['userLicensePlate'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTile({required String label, required String value}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: const TextStyle(color: Colors.green)),
      ),
    );
  }
}
