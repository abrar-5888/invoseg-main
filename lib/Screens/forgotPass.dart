import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  Future<void> _verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber:
            '+${_phoneNumberController.text.trim()}', // Add the country code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieve the verification code on some devices.
          await _auth.signInWithCredential(credential);
          _showSnackBar('Verification completed, signed in');
        },
        verificationFailed: (FirebaseAuthException e) {
          _showSnackBar('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _showSnackBar('Verification code sent');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          _showSnackBar('Auto Retrieval Timeout, use manual input');
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> _verifyCode() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _verificationCodeController.text.trim(),
      );

      await _auth.signInWithCredential(credential);
      _showSnackBar('Verification completed, signed in');
    } catch (e) {
      _showSnackBar('Error verifying code: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _verifyPhoneNumber();
              },
              child: const Text('Send Verification Code'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Verification Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _verifyCode();
              },
              child: const Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}








/* List<FocusNode> _focusNodes = [];
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();

    // Initialize focus nodes and controllers for each digit
    _focusNodes = List.generate(6, (index) => FocusNode());
    _controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose of the focus nodes and controllers to prevent memory leaks
    for (var node in _focusNodes) {
      node.dispose();
    }

    for (var controller in _controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  'https://w0.peakpx.com/wallpaper/395/822/HD-wallpaper-city-amoled-black-building-city-new-night-sky.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.dstATop),
            )),
            child: Container(
                child: Form(
                    // key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(),
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    height: 10.0,
                                    width: 1.0,
                                    color: Colors.grey.withOpacity(0.5),
                                    margin: const EdgeInsets.only(
                                        left: 00.0, right: 10.0),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'Email or PhoneNo',
                                        border: InputBorder.none,
                                        hintText:
                                            'Enter your Email Address or PhoneNo',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal :20.0,),
                              child: Container(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Enter Your Verfication Code Below ")),
                              ),
                            ),
                            RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (RawKeyEvent event) {
                                if (event.runtimeType == RawKeyDownEvent &&
                                    event.logicalKey ==
                                        LogicalKeyboardKey.backspace) {
                                  _moveFocusBackward();
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: List.generate(
                                    6,
                                    (index) => Container(
                                      width: 40.0,
                                      height: 40.0,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: TextFormField(
                                        controller: _controllers[index],
                                        focusNode: _focusNodes[index],
                                        keyboardType: TextInputType.number,
                                        // obscureText: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText:
                                              '', // Remove the character count
                                        ),
                                        maxLength: 1,
                                        onChanged: (value) {
                                          // Handle the code as it is entered
                                          if (value.isNotEmpty && index < 5) {
                                            _focusNodes[index + 1]
                                                .requestFocus();
                                          }
                                        },
                                        onEditingComplete: () {
                                          // Add any logic you want when editing is complete for the last digit
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      )))
                ])))));
  }

  void _moveFocusBackward() {
    for (var i = _focusNodes.length - 1; i > 0; i--) {
      if (_focusNodes[i].hasFocus) {
        _focusNodes[i - 1].requestFocus();
        break;
      }
    }
  }*/
