import 'package:flutter/material.dart';
import 'package:mobile/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final dynamic userData;

  ProfileScreen({required this.userData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current user data
    _nameController.text = widget.userData['fullName'] ?? '';
    _emailController.text = widget.userData['email'] ?? '';
    _phoneController.text = widget.userData['phoneNumber'] ?? '';
  }

  // Function to handle updating personal information
  void updateUserInfo() {
    // Here you would send updated data to your backend or Firebase
    print('Updated Info: ${_nameController.text}, ${_emailController.text}, ${_phoneController.text}');
    // Example success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Information updated successfully!')));
  }

  // Function to handle changing password
  void changePassword() {
    if (_newPasswordController.text == _confirmPasswordController.text) {
      // Here you would send password change request to your backend or Firebase
      print('Password changed to: ${_newPasswordController.text}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
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
                        backgroundImage: NetworkImage(widget.userData['userAvatar'] ?? 'https://via.placeholder.com/150'),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Update Personal Information
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Full Name Update
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          icon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Email Update
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          icon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Phone Number Update
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          icon: const Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: updateUserInfo,
                        child: const Text('Update Info'),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
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
                    children: [
                      // Current Password Input
                      TextField(
                        controller: _currentPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Current Password',
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // New Password Input
                      TextField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Confirm New Password Input
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm New Password',
                          icon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: changePassword,
                        child: const Text('Change Password'),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
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
