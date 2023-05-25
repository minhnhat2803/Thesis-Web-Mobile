import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/resuable_widgets/resuable_widgets.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/profile_screen.dart';
import 'package:mobile/global_variables.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(
      {Key? key,
      required this.userData,
      required this.userBill,
      required this.condition})
      : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final userData;
  // ignore: prefer_typing_uninitialized_variables
  dynamic userBill;
  // ignore: prefer_typing_uninitialized_variables
  final condition;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //update state
  void updateState() async {
    String url = 'http://$ipAddr:$port/bills/${widget.userData['userID']}';
    Response response = await get(Uri.parse(url));
    var userBill = jsonDecode(response.body);
    if (userBill.length == 0) {
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

  String getSystemTime() {
    var now = DateTime.now();
    return now.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'HOMEPAGE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          updateState();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      var userProfile = widget.userData;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  userData: userProfile,
                                  userBill: widget.userBill)));
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()));
                    },
                    icon: const Icon(
                      Icons.logout,
                      size: 45,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //check if condition is login or register
                    widget.condition == 'login'
                        ? 'Welcome Back,'
                        : 'Welcome !!!',
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.userData['email']}",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.userData['userLicensePlate']}",
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                thickness: 2,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Time in:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                '${widget.userBill[0]['timeIn']}',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Slot Parking Number:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            boxGrid(context, '${widget.userBill[0]['slot']}', Colors.green),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Parking Fee:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            boxGrid(
                context, '${widget.userBill[0]['fee']}' + ' VND', Colors.green),
            const SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
