import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/global_Variables.dart';
import 'package:mobile/resuable_widgets/resuable_widgets.dart';
import 'package:mobile/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();

  var imageString = '';

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return null;
      final imageTemporary = await image.readAsBytes();
      setState(() {
        imageString = base64Encode(imageTemporary);
      });
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  void register(String email, String pass, String userLicensePlate, context) async {
    try {
      if (email.isEmpty || pass.isEmpty || userLicensePlate.isEmpty || imageString.isEmpty) {
        await EasyLoading.showError('Please fill all the fields');
        return;
      }

      await EasyLoading.show(status: 'Registering...', maskType: EasyLoadingMaskType.black);

      String url = 'http://10.0.2.2:8000/auth/register';
      Map<String, dynamic> body = {
        'email': email,
        'password': pass,
        'userLicensePlate': userLicensePlate,
        'userAvatar': imageString,
      };

      Response response = await post(Uri.parse(url), body: body);
      var jsonResp = jsonDecode(response.body);
      print(jsonResp);

      if (jsonResp['statusCode'] == '200') {
        // Dismiss EasyLoading before navigating
        await EasyLoading.dismiss();

        // Show success message for a moment before navigating
        await EasyLoading.showSuccess('Register successful');
        await Future.delayed(Duration(seconds: 2)); // Optional delay for smooth transition

        // Navigate to login screen
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LogInScreen()));
      } else {
        await EasyLoading.showError(jsonResp['message']);
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      await EasyLoading.showError('An error occurred, please try again.');
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
            padding: const EdgeInsets.fromLTRB(20, 90, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/Notes.png", 150, 150),
                const SizedBox(height: 20),
                const Text('REGISTER',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5)),
                const SizedBox(height: 30),
                // Custom Text Field for Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter your email',
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.green.shade700),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Custom Text Field for Password
                TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    prefixIcon: Icon(Icons.lock_outlined, color: Colors.green.shade700),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Custom Text Field for License Plate
                TextField(
                  controller: licensePlateController,
                  decoration: InputDecoration(
                    labelText: '50F2-567.89',
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                    prefixIcon: Icon(Icons.directions_car, color: Colors.green.shade700),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade700),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    cameraButton(context, 'Gallery', () => pickImage(ImageSource.gallery)),
                    const SizedBox(width: 35),
                    cameraButton(context, 'Camera', () => pickImage(ImageSource.camera)),
                  ],
                ),
                const SizedBox(height: 30),
                submitButton(context, "Register", () {
                  register(
                    emailController.text.toString(),
                    passController.text.toString(),
                    licensePlateController.text.toString(),
                    context,
                  );
                }),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}