import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
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
  late dynamic userBill;

  @override
  void initState() {
    super.initState();
    // Khởi tạo userBill từ widget
    userBill = widget.userBill;
  }

  void updateState() async {
    String url = 'http://10.0.2.2:8000/bills/${widget.userData['userID']}';
    try {
      Response response = await get(Uri.parse(url));
      var updatedUserBill = jsonDecode(response.body);
      if (updatedUserBill.isEmpty) {
        updatedUserBill = [
          {
            'userID': widget.userData['userID'],
            'slot': 'INACTIVE',
            'fee': '0',
            'timeIn': 'None',
          }
        ];
      }
      setState(() {
        userBill = updatedUserBill;
      });
    } catch (e) {
      // Xử lý lỗi khi fetch dữ liệu
      print("Error fetching user bill: $e");
    }
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
        onPressed: updateState,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              userData: widget.userData,
                              userBill: userBill,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogInScreen()),
                        );
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.condition == 'login'
                          ? 'Welcome Back,'
                          : 'Welcome !!!',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 5),
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
              ),
              const Divider(
                thickness: 2,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Time in:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${userBill[0]['timeIn']}',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Slot Parking Number:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    boxGrid(context, '${userBill[0]['slot']}', Colors.green),
                    const SizedBox(height: 10),
                    Text(
                      "Parking Fee:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    boxGrid(context,
                        '${userBill[0]['fee']}' + ' VND', Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
