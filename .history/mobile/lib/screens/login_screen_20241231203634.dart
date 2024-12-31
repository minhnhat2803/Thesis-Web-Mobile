import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:mobile/resuable_widgets/resuable_widgets.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/register_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  // Controllers cho email và password
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  // Hàm xử lý đăng nhập
  void login(String email, String pass, BuildContext context) async {
    try {
      // Kiểm tra nếu thông tin đăng nhập bị bỏ trống
      if (email.isEmpty || pass.isEmpty) {
        await EasyLoading.showError('Please fill all the fields');
        return;
      }

      // Gửi yêu cầu đăng nhập
      String loginUrl = 'http://10.0.2.2:8000/auth/login';
      Response loginResponse = await post(Uri.parse(loginUrl), body: {
        'email': email,
        'password': pass,
      });

      var loginData = jsonDecode(loginResponse.body);

      // Xử lý khi đăng nhập thành công
      if (loginResponse.statusCode == 200 && loginData['statusCode'] == '200') {
        var userData = loginData['data'];

        // Lấy thông tin bill
        String billUrl = 'http://10.0.2.2:8000/bills/${userData['userID']}';
        Response billResponse = await get(Uri.parse(billUrl));
        var userBill = jsonDecode(billResponse.body);

        // Nếu không có bill, tạo dữ liệu mặc định
        if (userBill.isEmpty) {
          userBill = [
            {
              'userID': userData['userID'],
              'slot': 'INACTIVE',
              'fee': '0',
              'timeIn': 'None',
            }
          ];
        }

        // Hiển thị thông báo thành công và chuyển hướng sang HomeScreen
        await EasyLoading.show(
                status: 'Logging in...', maskType: EasyLoadingMaskType.black)
            .then((value) => EasyLoading.dismiss());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userData: userData,
              condition: 'login',
            ),
          ),
        );
      } else {
        // Hiển thị thông báo lỗi từ server
        await EasyLoading.showError(loginData['message']);
      }
    } catch (e) {
      // Xử lý lỗi không mong đợi
      print('Error: ${e.toString()}');
      await EasyLoading.showError('An unexpected error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade800, Colors.green.shade400],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Column(
              children: <Widget>[
                // Animated Logo
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login to continue',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                // Card for Input Fields
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        reusableTextField(
                          "Enter your email",
                          Icons.email,
                          false,
                          emailController,
                        ),
                        const SizedBox(height: 20),
                        reusableTextField(
                          "Enter your password",
                          Icons.lock,
                          true,
                          passController,
                        ),
                        const SizedBox(height: 20),
                        // Login Button
                        ElevatedButton(
                          onPressed: () {
                            login(emailController.text.trim(),
                                passController.text.trim(), context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Register Option
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register here",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,

                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}