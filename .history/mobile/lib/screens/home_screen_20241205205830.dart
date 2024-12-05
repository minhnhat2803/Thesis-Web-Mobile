import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final dynamic userData;
  final dynamic userBill;
  final String condition;

  const HomeScreen({
    Key? key,
    required this.userData,
    required this.userBill,
    required this.condition,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Biến lưu trữ dữ liệu từ Firestore
  List<Map<String, dynamic>> licensePlates = [];
  bool isLoading = true; // Biến trạng thái loading

  // Hàm lấy dữ liệu từ Firestore
  Future<void> fetchLicensePlates() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('license-plate').get();

      // Chuyển đổi dữ liệu snapshot thành danh sách map
      final data = snapshot.docs.map((doc) {
        final map = doc.data() as Map<String, dynamic>;
        return {
          "imageUrl": map['imageUrl'] ?? "",
          "licensePlate": map['licensePlate'] ?? "N/A",
          "slotID": map['slotID'] ?? "N/A",
          "status": map['status'] ?? "Unknown",
          "time": map['time'] != null ? map['time'].toDate() : DateTime.now(),
        };
      }).toList();

      setState(() {
        licensePlates = data;
        isLoading = false; // Kết thúc trạng thái loading
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Kết thúc trạng thái loading ngay cả khi lỗi
      });
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLicensePlates(); // Lấy dữ liệu khi màn hình được tải
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
          // Nút chuyển đến màn hình Profile
          IconButton(
            icon: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userData: widget.userData,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Hiển thị khi đang load
          : licensePlates.isEmpty
              ? const Center(child: Text("No data available"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
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
