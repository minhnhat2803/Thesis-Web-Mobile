import 'package:flutter/material.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final dynamic userData;

  ProfileScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Điều hướng trở về trang HomeScreen khi nhấn nút back
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  userData: userData, // Truyền dữ liệu người dùng về trang Home
                  condition: 'login', // Điều kiện (login)
                ),
              ),
            );
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
              const SizedBox(height: 20),

              // Update Personal Information Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Update Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 10),
                      // Upload new avatar (For simplicity, we'll use a TextField here)
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Upload New Avatar',
                          prefixIcon: Icon(Icons.camera_alt),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(text: userData['fullName']),
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                       const SizedBox(height: 10),
                      // Email Field
                      TextField(
                        controller: TextEditingController(text: userData['email']),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                       const SizedBox(height: 10),
                      // Phone Number Field
                      TextField(
                        controller: TextEditingController(text: userData['phoneNumber']),
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: TextEditingController(text: userData['licensePlate']),
                        decoration: InputDecoration(
                          labelText: 'License Plate Number',
                          prefixIcon: Icon(Icons.directions_car),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle the information update here
                          // (Upload data to server or navigate to other screen)
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Change Password Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle password change logic here
                        },
                        child: const Text('Change Password'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Link Bank Card Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Link Bank Card for Online Payments',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Card Expiry Date',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Card Holder Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle card linking logic here
                        },
                        child: const Text('Link Card'),
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
