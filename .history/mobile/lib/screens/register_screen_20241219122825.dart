import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? selectedSlot; // Add a field for the selected slot

  final List<String> availableSlots = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  // Pick image from gallery or camera
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

  // Register the user and save the data to Firebase
  void register(String email, String pass, String userLicensePlate, String? userSlot, context) async {
    try {
      if (email.isEmpty || pass.isEmpty || userLicensePlate.isEmpty || imageString.isEmpty || userSlot == null) {
        await EasyLoading.showError('Please fill all the fields and select a slot');
        return;
      }

      await EasyLoading.show(status: 'Registering...', maskType: EasyLoadingMaskType.black);

      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'slot': userSlot,
        'userLicensePlate': userLicensePlate,
        'userAvatar': imageString,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Show success message and navigate to the login screen
      await EasyLoading.showSuccess('Register successful');
      await Future.delayed(Duration(seconds: 2)); // Optional delay for smooth transition
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LogInScreen()));

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
                
                // Add dropdown for selecting slot
                const Text(
                  'Select Slot:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  hint: const Text('Select Slot'),
                  value: selectedSlot,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSlot = newValue;
                    });
                  },
                  items: availableSlots.map<DropdownMenuItem<String>>((String slot) {
                    return DropdownMenuItem<String>(
                      value: slot,
                      child: Text(slot),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    cameraButton(context, 'Gallery', () => pickImage(ImageSource.gallery)),
                    const SizedBox(width: 35),
                    cameraButton(context, 'Camera', () => pickImage(ImageSource.camera)),
                  ],
                ),
                const SizedBox(height: 25),
                submitButton(context, "Register", () {
                  register(
                    emailController.text.toString(),
                    passController.text.toString(),
                    licensePlateController.text.toString(),
                    selectedSlot, // Pass the selected slot to register method
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
