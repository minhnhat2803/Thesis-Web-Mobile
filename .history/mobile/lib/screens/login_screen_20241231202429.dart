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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.1,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                const Text(
                  'Smart Parking System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                logoWidget("assets/images/car.png", 200, 200),
                const SizedBox(height: 30),
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
                const SizedBox(height: 30),
                submitButton(context, 'LOGIN', () {
                  login(emailController.text.trim(),
                      passController.text.trim(), context);
                }),
                const SizedBox(height: 20),
                registerOption(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row registerOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          child: const Text(
            " Register here",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}