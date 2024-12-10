import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:mobile/screens/profile_screen.dart';
import 'package:mobile/screens/reservation_screen.dart';

class HomeScreen extends StatefulWidget {
  final dynamic userData;
  final String condition;

  const HomeScreen({
    Key? key,
    required this.userData,
    required this.condition,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late dynamic userBill;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userBill = {
      'userID': widget.userData['userID'],
      'slot': 'INACTIVE',
      'fee': '0',
      'timeIn': 'None',
    };
    updateState();
  }

  void updateState() async {
    try {
      String url = 'http://10.0.2.2:8000/bills/${widget.userData['userID']}';
      Response response = await get(Uri.parse(url));
      var billData = jsonDecode(response.body);

      setState(() {
        userBill = billData.isNotEmpty ? billData[0] : userBill;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void searchVehicle() async {
    String licensePlate = searchController.text;
    if (licensePlate.isNotEmpty) {
      try {
        String url = 'http://10.0.2.2:8000/vehicles/$licensePlate';
        Response response = await get(Uri.parse(url));
        var vehicleData = jsonDecode(response.body);

        if (vehicleData.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Vehicle Information'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(vehicleData[0]['imageUrl'] ?? ''),
                    const SizedBox(height: 8),
                    Text('License Plate: ${vehicleData[0]['licensePlate']}'),
                    Text('Slot Number: ${vehicleData[0]['slot']}'),
                    Text('Time In: ${vehicleData[0]['timeIn']}'),
                    Text('Parking Fee: ${vehicleData[0]['fee']} VND'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        } else {
          _showErrorDialog('No vehicle found with this license plate.');
        }
      } catch (e) {
        print('Error fetching vehicle data: $e');
        _showErrorDialog('Error fetching data.');
      }
    } else {
      _showErrorDialog('Please enter a license plate.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
        automaticallyImplyLeading: false, // Bỏ nút back
        actions: [
          IconButton(
            icon: const Icon(Icons.person, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.push(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: updateState,
        child: const Icon(Icons.refresh),
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
                          userBill['timeIn'] ?? 'None',
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
                          userBill['slot'] ?? 'None',
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
                          '${userBill['fee']} VND',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Reserve Slot Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationScreen(
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Reserve a Slot',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              // Search Vehicle Section
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Enter License Plate',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: searchVehicle,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
