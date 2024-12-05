import 'package:flutter/material.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final dynamic userData;

  ProfileScreen({required this.userData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _avatarImage;

  // Hàm mở bộ sưu tập hoặc camera để chọn ảnh
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Chọn ảnh từ bộ sưu tập
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

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
                  userData: widget.userData, // Truyền dữ liệu người dùng về trang Home
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
                        backgroundImage: _avatarImage != null
                            ? FileImage(_avatarImage!)
                            : NetworkImage(widget.userData['userAvatar']) as ImageProvider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.userData['fullName'] ?? 'No name',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.userData['email'] ?? 'No email',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.userData['phoneNumber'] ?? 'No phone number',
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
                      // Upload new avatar (For simplicity, we'll use a button to pick an image)
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Choose New Avatar'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TextEditingController(text: widget.userData['fullName']),
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Email Field
                      TextField(
                        controller: TextEditingController(text: widget.userData['email']),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Phone Number Field
                      TextField(
                        controller: TextEditingController(text: widget.userData['phoneNumber']),
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: TextEditingController(text: widget.userData['licensePlate']),
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
              // ... (các phần khác không thay đổi)
            ],
          ),
        ),
      ),
    );
  }
}
