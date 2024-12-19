import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'; // Thư viện HTTP để fetch dữ liệu từ API

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Nhận dữ liệu người dùng từ HomeScreen

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Lưu trữ slot được chọn
  List<String> availableSlots = []; // Danh sách các slot khả dụng
  bool isLoading = true; // Trạng thái loading khi fetch dữ liệu

  // Hàm fetch dữ liệu slots từ API
  void fetchSlots() async {
    try {
      String slotUrl = 'http://10.0.2.2:8000/slots'; // Endpoint API
      Response slotResponse = await get(Uri.parse(slotUrl));

      if (slotResponse.statusCode == 200) {
        var slotData = jsonDecode(slotResponse.body);

        // Kiểm tra nếu không có slots
        if (slotData.isEmpty) {
          setState(() {
            availableSlots = []; // Không có slot khả dụng
          });
        } else {
          setState(() {
            availableSlots = slotData
                .map<String>((slot) => slot['slot_id'].toString())
                .toList(); // Lấy danh sách slots từ API
          });
        }
      } else {
        throw Exception('Failed to fetch slots: ${slotResponse.body}');
      }
    } catch (e) {
      await EasyLoading.showError('Error fetching slots: $e');
    } finally {
      setState(() {
        isLoading = false; // Kết thúc trạng thái loading
      });
    }
  }

  // Hàm xác nhận đặt slot
  void confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      await EasyLoading.show(
          status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      // Gửi request xác nhận đặt slot đến API
      String reserveUrl = 'http://10.0.2.2:8000/reserve';
      Response response = await post(
        Uri.parse(reserveUrl),
        body: jsonEncode({
          'userID': widget.userData['userID'],
          'slot': selectedSlot,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['statusCode'] == '200') {
          await EasyLoading.showSuccess('Reservation successful');

          // Cập nhật lại danh sách slots sau khi xác nhận
          fetchSlots();
        } else {
          throw Exception(jsonResponse['message']);
        }
      } else {
        throw Exception('Failed to reserve slot: ${response.body}');
      }
    } catch (e) {
      await EasyLoading.showError('An error occurred: $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSlots(); // Fetch danh sách slots khi khởi tạo màn hình
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Slots:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: availableSlots.isEmpty
                        ? const Center(
                            child: Text(
                              'No available slots at the moment.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: availableSlots.length,
                            itemBuilder: (context, index) {
                              String slot = availableSlots[index];
                              return ListTile(
                                title: Text(
                                  'Slot $slot',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedSlot == slot
                                        ? Colors.green
                                        : Colors.black87,
                                  ),
                                ),
                                trailing: selectedSlot == slot
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      )
                                    : null,
                                onTap: () {
                                  setState(() {
                                    selectedSlot = slot; // Cập nhật slot được chọn
                                  });
                                },
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    onPressed: confirmReservation,
                    child: const Center(
                      child: Text(
                        'Confirm Reservation',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
