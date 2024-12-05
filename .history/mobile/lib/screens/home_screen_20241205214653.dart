import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:mobile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final dynamic userData;
  final String condition;

  HomeScreen({
    required this.userData,
    required this.condition,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      // Không cần cập nhật userBill nữa
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Homepage',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          // Profile Button
          IconButton(
            icon: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              var userProfile = widget.userData;
              // Không truyền userBill vào ProfileScreen nữa
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userData: userProfile, // Chỉ truyền userData
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
              // User Info Section
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
                            ? 'Welcome Back!'
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
              // Parking Info Section
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
                          'None', // Bạn có thể thay thế đây bằng thông tin từ userBill hoặc giữ nguyên 'None'
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
                          'None', // Thay thế bằng dữ liệu thực tế nếu cần
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
                          '0 VND', // Thay thế nếu cần
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
