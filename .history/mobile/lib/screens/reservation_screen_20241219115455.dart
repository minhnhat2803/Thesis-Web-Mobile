import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic userData;

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<dynamic> availableSlots = []; // Danh sách slot khả dụng
  String? selectedSlot; // Slot được chọn
  bool isLoading = true; // Trạng thái loading

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  // Hàm fetch slot từ API
  void fetchSlots() async {
    try {
      String slotUrl = 'http://10.0.2.2:8000/slots'; // Thay bằng URL đúng
      Response slotResponse = await get(Uri.parse(slotUrl));

      if (slotResponse.statusCode == 200) {
        var slotData = jsonDecode(slotResponse.body);
        setState(() {
          availableSlots = slotData
              .where((slot) => slot['status'] == 'available')
              .toList();
        });
      } else {
        throw Exception(
            'Failed to fetch slots: ${slotResponse.statusCode} ${slotResponse.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching slots: $e');
      await EasyLoading.showError('Error fetching slots: $e');
    } finally {
      setState(() {
        isLoading = false;
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

      // Gửi dữ liệu xác nhận slot
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
        await EasyLoading.showSuccess('Reservation successful');
        fetchSlots(); // Cập nhật danh sách slot
      } else {
        throw Exception('Failed to reserve slot: ${response.body}');
      }
    } catch (e) {
      print('Error reserving slot: $e');
      await EasyLoading.showError('Error reserving slot: $e');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
                    child: ListView.builder(
                      itemCount: availableSlots.length,
                      itemBuilder: (context, index) {
                        var slot = availableSlots[index];
                        return ListTile(
                          title: Text(
                            'Slot ${slot['slot_id']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: selectedSlot == slot['slot_id']
                                  ? Colors.green
                                  : Colors.black87,
                            ),
                          ),
                          trailing: selectedSlot == slot['slot_id']
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              selectedSlot = slot['slot_id']; // Cập nhật slot được chọn
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
