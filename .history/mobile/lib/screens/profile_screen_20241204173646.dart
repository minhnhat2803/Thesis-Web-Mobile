import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic userData;

  ProfileScreen({required this.userData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update user info in Firestore
  Future<void> updateUserInfo() async {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      // Handle validation error
      return;
    }

    try {
      // Update user data in Firestore
      await _firestore.collection('users').doc(widget.userData['userID']).update({
        'name': name,
        'email': email,
        'phone': phone,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User info updated successfully!')),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user info: $e')),
      );
    }
  }

  // Update password in Firestore
  Future<void> changePassword() async {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      // Handle validation error
      return;
    }

    if (newPassword != confirmPassword) {
      // Handle password mismatch
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // Check current password in Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(widget.userData['userID']).get();
      String storedPassword = userDoc['password'];

      // Verify if current password matches
      if (storedPassword == currentPassword) {
        // Update password in Firestore
        await _firestore.collection('users').doc(widget.userData['userID']).update({
          'password': newPassword,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Current password is incorrect')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error changing password: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the homepage
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                        backgroundImage: NetworkImage(widget.userData['userAvatar']),
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
              const SizedBox(height: 16),

              // Update Info Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: updateUserInfo,
                        child: const Text('Update Info'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Change Password Section
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Current Password'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'New Password'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Confirm New Password'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: changePassword,
                        child: const Text('Change Password'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
