import 'package:flutter/material.dart';
import 'package:mobile/resuable_widgets/resuable_widgets.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key, required this.userData, required this.userBill});
  // ignore: prefer_typing_uninitialized_variables
  final userData;
  // ignore: prefer_typing_uninitialized_variables
  final userBill;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                        userBill: widget.userBill,
                        userData: widget.userData,
                        condition: 'true')));
          },
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Hompage',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.green,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.05, 20, 0),
            child: Column(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                boxProfile(
                    context,
                    "${widget.userData['fullName']}",
                    "${widget.userData['email']}",
                    "${widget.userData['phoneNumber']}",
                    "${widget.userData['site']}",
                    "${widget.userData['userAvatar']}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
