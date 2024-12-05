import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final dynamic userData;
  dynamic userBill;
  final String condition;

  HomeScreen({
    required this.userData,
    required this.userBill,
    required this.condition,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến để lưu trữ dữ liệu từ Firestore
  List<Map<String, dynamic>> licensePlates = [];

  // Hàm lấy dữ liệu từ Firebase Firestore
  Future<void> fetchLicensePlates() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('license-plate').get();

      // Xử lý dữ liệu và lưu vào biến
      final data = snapshot.docs.map((doc) {
        return {
          "imageUrl": doc['imageUrl'] ?? "",
          "licensePlate": doc['licensePlate'] ?? "",
          "slotID": doc['slotID'] ?? "",
          "status": doc['status'] ?? "",
          "time": doc['time']?.toDate() ?? DateTime.now(),
        };
      }).toList();

      setState(() {
        licensePlates = data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLicensePlates(); // Lấy dữ liệu khi màn hình load
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
          IconButton(
            icon: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              var userProfile = widget.userData;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userData: userProfile,
                    userBill: widget.userBill,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: fetchLicensePlates, // Làm mới dữ liệu
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: licensePlates.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Hiển thị khi đang load
            : ListView.builder(
                itemCount: licensePlates.length,
                itemBuilder: (context, index) {
                  final item = licensePlates[index];
                  return Card(
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
                            "License Plate: ${item['licensePlate']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Slot ID: ${item['slotID']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${item['status']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Time: ${item['time']}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          if (item['imageUrl'].isNotEmpty)
                            Image.network(item['imageUrl']),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
