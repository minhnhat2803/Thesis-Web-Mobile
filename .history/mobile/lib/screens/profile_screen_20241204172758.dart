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

  // Update user info
  void updateUserInfo() {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      // Handle validation error
      return;
    }

    // Call API to update user info (update API request here)
    // For example, make an API request to update the user data
  }

  // Change password
  void changePassword() {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      // Handle validation error
      return;
    }

    if (newPassword != confirmPassword) {
      // Handle password mismatch
      return;
    }

    // Call API to change the password (change password API request here)
    // For example, make an API request to change the password
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
