import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
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

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  var imageString = '';
  String selectedPaymentMethod = 'Card'; // Default payment method

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

  void register(String email, String pass, String userLicensePlate, BuildContext context) async {
    try {
      if (email.isEmpty || pass.isEmpty || userLicensePlate.isEmpty || imageString.isEmpty) {
        await EasyLoading.showError('Please fill all the fields');
        return;
      }

      if (selectedPaymentMethod == 'Card' &&
          (cardNumberController.text.isEmpty ||
              cardHolderNameController.text.isEmpty ||
              expiryDateController.text.isEmpty ||
              cvvController.text.isEmpty)) {
        await EasyLoading.showError('Please complete your card details');
        return;
      }

      // Hiển thị trạng thái đang đăng ký
      await EasyLoading.show(status: 'Registering...', maskType: EasyLoadingMaskType.black);

      // Tạo document ID ngẫu nhiên
      String docId = FirebaseFirestore.instance.collection('users').doc().id;

      // Chuẩn bị dữ liệu để lưu
      Map<String, dynamic> userData = {
        'userID': docId,
        'email': email,
        'password': pass, // Lưu ý: Nên hash mật khẩu trước khi lưu
        'userLicensePlate': userLicensePlate,
        'userAvatar': imageString,
        'paymentMethod': selectedPaymentMethod,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      if (selectedPaymentMethod == 'Card') {
        userData.addAll({
          'cardNumber': cardNumberController.text,
          'cardHolderName': cardHolderNameController.text,
          'expiryDate': expiryDateController.text,
          'cvv': cvvController.text,
        });
      }

      // Lưu vào Firestore
      await FirebaseFirestore.instance.collection('users').doc(docId).set(userData);

      // Hiển thị thông báo thành công
      await EasyLoading.showSuccess('Registered Successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInScreen()));
    } catch (e) {
      await EasyLoading.showError('Registration Failed: ${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Widget paymentOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: const Text(
            "Payment Method",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPaymentMethod == 'Card' ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  selectedPaymentMethod = 'Card';
                });
              },
              child: const Text("Card"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPaymentMethod == 'Wallet' ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  selectedPaymentMethod = 'Wallet';
                });
              },
              child: const Text("E-Wallet"),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (selectedPaymentMethod == 'Card') ...[
          reusableTextField("Card Number", Icons.credit_card, false, cardNumberController),
          const SizedBox(height: 15),
          reusableTextField("Card Holder Name", Icons.person, false, cardHolderNameController),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: reusableTextField("Expiry Date (MM/YY)", Icons.date_range, false, expiryDateController),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: reusableTextField("CVV", Icons.lock, true, cvvController),
              ),
            ],
          ),
        ] else if (selectedPaymentMethod == 'Wallet') ...[
          Center(
            child: const Text(
              "Supported wallets: Momo, ZaloPay",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate to wallet payment logic
              },
              child: const Text("Connect to Wallet"),
            ),
          ),
        ],
      ],
    );
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
        color: Colors.green,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 90, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/Notes.png", 300, 200),
                const Text('REGISTER',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                reusableTextField("Enter your email", Icons.person_outline, false, emailController),
                const SizedBox(height: 15),
                reusableTextField("Enter your password", Icons.lock_outlined, true, passController),
                const SizedBox(height: 15),
                reusableTextField("50F2-567.89", Icons.directions_car, false, licensePlateController),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    cameraButton(context, 'Gallery', () => pickImage(ImageSource.gallery)),
                    const SizedBox(width: 35),
                    cameraButton(context, 'Camera', () => pickImage(ImageSource.camera)),
                  ],
                ),
                const SizedBox(height: 15),
                paymentOptions(context),
                const SizedBox(height: 25),
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
