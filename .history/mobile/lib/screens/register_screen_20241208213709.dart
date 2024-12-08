import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterScreen(),
      builder: EasyLoading.init(),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderNameController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String selectedPaymentMethod = 'Cash';
  String imageString = '';

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

      await EasyLoading.show(
              status: 'Registering...', maskType: EasyLoadingMaskType.black)
          .then((value) => EasyLoading.dismiss());

      // Prepare data to save in Firestore
      Map<String, dynamic> userData = {
        'email': email,
        'password': pass,
        'userLicensePlate': userLicensePlate,
        'userAvatar': imageString,
        'paymentMethod': selectedPaymentMethod,
        'createdAt': DateTime.now(),
      };

      if (selectedPaymentMethod == 'Card') {
        userData.addAll({
          'cardNumber': cardNumberController.text,
          'cardHolderName': cardHolderNameController.text,
          'expiryDate': expiryDateController.text,
          'cvv': cvvController.text,
        });
      }

      // Save data to Firestore
      final collectionRef = FirebaseFirestore.instance.collection('users');
      await collectionRef.add(userData);

      // Show success and navigate to login screen
      await EasyLoading.showSuccess('Registration Successful!');
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const LogInScreen()),
      );
    } catch (e) {
      print('Error: ${e.toString()}');
      await EasyLoading.showError('Registration Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: licensePlateController,
              decoration: InputDecoration(labelText: 'License Plate'),
            ),
            DropdownButton<String>(
              value: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
              items: ['Cash', 'Card']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
            ),
            if (selectedPaymentMethod == 'Card') ...[
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
              ),
              TextField(
                controller: cardHolderNameController,
                decoration: InputDecoration(labelText: 'Card Holder Name'),
              ),
              TextField(
                controller: expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date'),
              ),
              TextField(
                controller: cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
              ),
            ],
            ElevatedButton(
              onPressed: () => register(
                emailController.text,
                passwordController.text,
                licensePlateController.text,
                context,
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
