import 'package:flutter/material.dart';
import 'package:mobile/resuable_widgets/resuable_widgets.dart';
import 'package:mobile/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.userData,
    required this.userBill,
  });

  dynamic userData;
  dynamic userBill;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  userBill: widget.userBill,
                  userData: widget.userData,
                  condition: 'true',
                ),
              ),
            );
          },
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white, // Màu nền đổi thành màu trắng cho sạch sẽ hơn
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green,
                backgroundImage: widget.userData['userAvatar'] != null
                    ? NetworkImage(widget.userData['userAvatar'])
                    : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
              ),
              const SizedBox(height: 20),
              // Tên người dùng
              Text(
                widget.userData['fullName'] ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              // Email người dùng
              Text(
                widget.userData['email'] ?? 'No Email',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Các thông tin khác
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(0, 3),
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _infoRow('Phone Number', widget.userData['phoneNumber']),
                    const Divider(color: Colors.grey),
                    _infoRow('Site', widget.userData['site']),
                    const Divider(color: Colors.grey),
                    _infoRow('Slot', widget.userBill['slot']),
                    const Divider(color: Colors.grey),
                    _infoRow('Fee', "\$${widget.userBill['fee']}"),
                    const Divider(color: Colors.grey),
                    _infoRow('Time In', widget.userBill['timeIn']),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Nút Logout
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LogInScreen(),
                    ),
                  );
                },
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo hàng thông tin
  Widget _infoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value ?? 'Not Available',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
