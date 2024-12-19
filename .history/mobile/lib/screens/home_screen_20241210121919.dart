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
  TextEditingController searchController = TextEditingController();
  List<dynamic> slots = [];
  String searchResult = 'No results found';

  // Fetch available slots
  Future<void> fetchSlots() async {
    String url = 'http://10.0.2.2:8000/slots'; // API lấy danh sách slot
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        slots = jsonDecode(response.body);
      });
    }
  }

  // Handle booking a slot
  Future<void> bookSlot(String slot) async {
    String url = 'http://10.0.2.2:8000/bookSlot';
    Response response = await post(
      Uri.parse(url),
      body: jsonEncode({'slot': slot, 'userID': widget.userData['userID']}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot booked successfully!')),
      );
    }
  }

  // Search for vehicle
  Future<void> searchVehicle(String query) async {
    String url = 'http://10.0.2.2:8000/searchVehicle?query=$query';
    Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        searchResult = response.body.isEmpty
            ? 'No results found'
            : jsonDecode(response.body)['message'];
      });
    }
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userData: widget.userData,
                  ),
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
                          'None', // Thay bằng dữ liệu thực tế nếu cần
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
                          'None', // Thay bằng dữ liệu thực tế nếu cần
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
                          '0 VND', // Thay bằng dữ liệu thực tế nếu cần
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Search Section
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search by email or license plate',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      searchVehicle(searchController.text);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(searchResult),

              const SizedBox(height: 16),
              // Booking Section
              ElevatedButton(
                onPressed: () async {
                  await fetchSlots();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Available Slots'),
                        content: slots.isEmpty
                            ? const Text('No available slots')
                            : SizedBox(
                                width: double.maxFinite,
                                height: 300,
                                child: ListView.builder(
                                  itemCount: slots.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text('Slot ${slots[index]}'),
                                      onTap: () {
                                        bookSlot(slots[index]);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                      );
                    },
                  );
                },
                child: const Text('Book a Slot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
