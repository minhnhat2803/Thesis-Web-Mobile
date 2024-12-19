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

      await EasyLoading.show(
              status: 'Registering...', maskType: EasyLoadingMaskType.black)
          .then((value) => EasyLoading.dismiss());

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
        await EasyLoading.show(
                status: 'Logging in...', maskType: EasyLoadingMaskType.black)
            .then((value) => EasyLoading.dismiss());
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LogInScreen()));
      } else {
        await EasyLoading.showError(jsonResp['message']);
      }
    } catch (e) {
      print('Error: ${e.toString()}');
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
