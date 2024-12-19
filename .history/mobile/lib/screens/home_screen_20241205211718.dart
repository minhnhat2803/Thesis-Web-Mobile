import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  List<dynamic> licensePlates = []; // Lưu danh sách license-plate

  // Fetch license-plate data from Firestore via REST API
  Future<void> fetchLicensePlates() async {
    final url =
        'https://firestore.googleapis.com/v1/projects/iot-smart-parking-72f94/databases/(default)/documents/license-plate'; // Thay YOUR_PROJECT_ID bằng project ID của bạn
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          licensePlates = data['documents'] ?? [];
        });
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLicensePlates(); // Gọi API khi HomeScreen được khởi tạo
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
              var userProfile = widget.userData;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userData: userProfile,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: fetchLicensePlates, // Cập nhật dữ liệu khi nhấn nút refresh
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // License Plate List Section
              licensePlates.isEmpty
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: licensePlates.length,
                      itemBuilder: (context, index) {
                        final plate = licensePlates[index];
                        final fields = plate['fields'];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              fields['licensePlate']['stringValue'] ?? 'Unknown',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Slot ID: ${fields['slotID']['stringValue'] ?? 'N/A'}\n'
                              'Status: ${fields['status']['stringValue'] ?? 'N/A'}\n'
                              'Time: ${fields['time']['timestampValue'] ?? 'N/A'}',
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
