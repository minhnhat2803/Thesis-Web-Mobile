import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:mobile/global_variables.dart';
import 'package:mobile/resuable_widgets/resuable_widgets.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/register_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void login(String email, String pass, context) async {
    try {
      if (email.isEmpty || pass.isEmpty) {
        await EasyLoading.showError('Please fill all the fields');
        return;
      }

      String url = 'http://10.0.2.2:8000/auth/login';
      Response response = await post(Uri.parse(url), body: {
        'email': email,
        'password': pass,
      });

      var jsonResp = jsonDecode(response.body);
      if (jsonResp['statusCode'] == '200') {
        var userData = jsonResp['data'];

        String url2 = 'http://10.0.2.2:8000/bills/${userData['userID']}';
        Response response2 = await get(Uri.parse(url2));
        var userBill = jsonDecode(response2.body);

        // Kiểm tra dữ liệu của userBill để tránh lỗi truy cập phần tử không hợp lệ
        if (userBill == null || userBill.isEmpty) {
          userBill = [
            {
              'userID': userData['userID'],
              'slot': 'INACTIVE',
              'fee': '0',
              'timeIn': 'None',
            }
          ];
        }

        await EasyLoading.show(
                status: 'Logging in...', maskType: EasyLoadingMaskType.black)
            .then((value) => EasyLoading.dismiss());
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                    userData: userData,
                    userBill: userBill,
                    condition: 'login')));
      } else {
        await EasyLoading.showError(jsonResp['message']);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.green,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.05, 20, 0),
              child: Column(
                children: <Widget>[
                  const Text('Smart Parking System',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  logoWidget("assets/images/car.png", 400, 200),
                  reusableTextField(
                      "Enter your email", Icons.email, false, emailController),
                  const SizedBox(
                    height: 25,
                  ),
                  reusableTextField(
                      "Enter your password", Icons.lock, true, passController),
                  const SizedBox(
                    height: 25,
                  ),
                  submitButton(context, 'LOGIN', () {
                    login(emailController.text.toString(),
                        passController.text.toString(), context);
                  }),
                  const SizedBox(
                    height: 25,
                  ),
                  registerOption(),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ))));
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
                MaterialPageRoute(
                    builder: (context) => const RegisterScreen()));
          },
          child: const Text(
            " Register here",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
