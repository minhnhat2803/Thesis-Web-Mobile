import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ReservationScreen extends StatefulWidget {
  final dynamic userData; // Nhận dữ liệu người dùng từ HomeScreen

  const ReservationScreen({super.key, required this.userData});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String? selectedSlot; // Lưu trữ slot được chọn
  final List<String> availableSlots = [
    'A1',
    'A2',
    'B1',
    'B2',
    'C1',
    'C2',
    
  ]; // Các slot khả dụng, cô có thể lấy từ API hoặc database

  void confirmReservation() async {
    try {
      if (selectedSlot == null) {
        await EasyLoading.showError('Please select a slot before confirming');
        return;
      }

      // Giả lập xác nhận đặt slot thành công
      await EasyLoading.show(
          status: 'Reserving slot...', maskType: EasyLoadingMaskType.black);

      // Thêm code gửi dữ liệu đến server nếu cần
      // Ví dụ:
      // String url = 'http://10.0.2.2:8000/reserve';
      // Response response = await post(Uri.parse(url), body: {
      //   'userID': widget.userData['userID'],
      //   'slot': selectedSlot,
      // });
      // var jsonResponse = jsonDecode(response.body);
      // if (jsonResponse['statusCode'] == '200') {
      //   ...
      // }

      await EasyLoading.dismiss();
      await EasyLoading.showSuccess('Reservation successful');
    } catch (e) {
      await EasyLoading.showError('An error occurred: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation',
          style: TextStyle(fontWeight: FontWeight.bold), // In đậm chữ "Reservation"
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
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
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onPressed: confirmReservation,
              child: const Center(
                child: Text(
                  'Confirm Reservation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
