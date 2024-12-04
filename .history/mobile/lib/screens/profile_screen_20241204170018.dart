import 'package:flutter/material.dart';
import 'package:mobile/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final dynamic userData;
  final dynamic userBill;

  ProfileScreen({required this.userData, required this.userBill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Điều hướng trở lại HomeScreen khi nhấn nút back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              // Điều hướng đến LoginScreen khi nhấn logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LogInScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData['userAvatar']),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData['fullName'] ?? 'No name',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData['email'] ?? 'No email',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData['phoneNumber'] ?? 'No phone number',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Billing Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.access_time, color: Colors.green),
                        title: const Text('Time In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        subtitle: Text(userBill[0]['timeIn'] ?? 'None', style: const TextStyle(fontSize: 18)),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.local_parking, color: Colors.green),
                        title: const Text('Slot Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        subtitle: Text(userBill[0]['slot'] ?? 'None', style: const TextStyle(fontSize: 18)),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.money, color: Colors.green),
                        title: const Text('Parking Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        subtitle: Text('${userBill[0]['fee']} VND', style: const TextStyle(fontSize: 18)),
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
