// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:com.invoseg.innovation/signup_app/constant.dart';
import 'package:com.invoseg.innovation/signup_app/global.dart';
import 'package:com.invoseg.innovation/signup_app/registar_FM.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupController {
  var name = TextEditingController();
  var remaining = 10;
  var email = TextEditingController();
  var password = TextEditingController();
  var phone = TextEditingController();
  var fName = TextEditingController();
  var fPhone = TextEditingController();
  var confirmPassword = TextEditingController();
  var age = TextEditingController();
  var familyName = TextEditingController();
  var address = TextEditingController();
  var mapUrl = TextEditingController();
  // var fmName = TextEditingController();
  // var fmphoneNo = TextEditingController();
  var societyBlock = TextEditingController();
  var plotSize = TextEditingController();
  var designation = TextEditingController();

  String familyId = '';
  String passAddress = '';
  String passOwner = '';
  String societyName = 'seochs';
  var isCheck = false;
  var api = ConstantStrings.apiUrl;

  Future<void> signup(BuildContext context) async {
    isCheck = true;
    var residentId = 'SG${generateRandomFourDigitCode()}';

    Uri? url;
    try {
      url = Uri.parse(api);
    } catch (e) {
      print('Error parsing URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up. Invalid URL.')),
      );
      isCheck = false;
      return;
    }

    try {
      var response = await http.post(url, body: {
        'name': name.text,
        'fName': fName.text,
        "residentId": residentId,
        'email': email.text,
        'password': password.text,
        'phonenumber': phone.text,
        'fPhoneNo': fPhone.text,
        'age': age.text,
        'owner': familyName.text,
        'designation': designation.text,
        'address': address.text,
        'societyName': societyName,
        'mapUrl': mapUrl.text,
        'societyBlock': societyBlock.text,
        'plotSize': plotSize.text
      });

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        mainUserData = data['user'];
        familyId = data['user']['familyID'];

        showDialog1(context);
        name.clear();
        email.clear();
        password.clear();
        phone.clear();
        confirmPassword.clear();
        age.clear();
        familyName.clear();
        designation.clear();
        societyBlock.clear();
        plotSize.clear();
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Already Registered.')),
        );
        print('Error: ${response.statusCode} - ${response.body}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign up. Please try again.')),
        );
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resident not registered. Please check your internet connection')),
      );
      print('Exception: $e');
      showToast(context, 'Oops, Internet not Connected', const Duration(seconds: 3));
    } finally {
      isCheck = false;
    }
  }

  Future<void> registerFM(BuildContext context) async {
    isCheck = true;
    var residentId = 'SG${generateRandomFourDigitCode()}';
    Uri? url;
    try {
      url = Uri.parse(api);
    } catch (e) {
      print('Error parsing URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up. Invalid URL.')),
      );
      isCheck = false;
      return;
    }

    print('Sending POST request to $url');
    print('Request body: ${{
      'name': name.text,
      'age': age.text,
      'residentId': residentId,
      'address': mainUserData['address'],
      'fName': mainUserData['fName'],
      'fPhoneNo': mainUserData['fPhoneNo'],
      'owner': mainUserData['owner'],
      'password': password.text,
      'phonenumber': phone.text,
      'familyID': mainUserData['familyID'],
      'societyName': mainUserData['societyName'],
      'mapUrl': mainUserData['mapUrl'],
      'societyBlock': mainUserData['societyBlock:'],
      'plotSize': mainUserData['plotSize'],
    }}');

    try {
      var response = await http.post(url, body: {
        'name': name.text,
        'age': age.text,
        'residentId': residentId,
        'address': mainUserData['address'],
        'fName': mainUserData['fName'],
        'fPhoneNo': mainUserData['fPhoneNo'],
        'owner': mainUserData['owner'],
        'password': password.text,
        'phonenumber': phone.text,
        'familyID': mainUserData['familyID'],
        'societyName': mainUserData['societyName'],
        'mapUrl': mainUserData['mapUrl'] ?? "",
        'societyBlock': mainUserData['societyBlock:'] ?? "",
        'plotSize': mainUserData['plotSize'] ?? "",
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        print('Family Member Added successfully');
        password.clear();
        name.clear();
        phone.clear();
        age.clear();
        remaining = remaining - 1;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Family Member Added successfully')),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number already exists.')),
        );
        print('Error: ${response.statusCode} - ${response.body}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign up. Please try again.')),
        );
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resident not registered. Please check your internet connection')),
      );
      print('Exception: $e');
      showToast(context, 'Oops, Internet not Connected', const Duration(seconds: 3));
    } finally {
      isCheck = false;
    }
  }

  // Future<void> registerFM(BuildContext context) async {
  //   isCheck = true;
  //   var residentId = 'SG${generateRandomFourDigitCode()}';
  //   var url = Uri.parse(api);
  //
  //   try {
  //     var response = await http.post(url, body: {
  //       'fmName': fmName.text,
  //       "residentId": residentId,
  //       'password': password.text,
  //       'fmphoneNo': fmphoneNo.text,
  //       'familyID': familyId
  //     });
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       print(data);
  //       print('Family Member Added successfully');
  //       password.clear();
  //       fmName.clear();
  //       fmphoneNo.clear();
  //       remaining = remaining - 1;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Family member added successfully')));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           content: Text('Failed to add family member. Please try again.')));
  //       print('Error: ${response.statusCode} - ${response.body}');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text(
  //             'Failed to add family member. Please check your internet connection')));
  //     print('Exception: $e');
  //   } finally {
  //     isCheck = false;
  //   }
  // }

  String generateRandomFourDigitCode() {
    Random random = Random();
    int code = random.nextInt(10000);

    // Ensure the code is four digits long (pad with leading zeros if necessary)
    return code.toString().padLeft(4, '0');
  }

  void showDialog1(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registered Successfully'),
            content: const Text('Do You want to add a family member?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your Details have been submitted ")));
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterFM())); // Close the dialog
                },
                child: const Text('Yes'),
              ),
            ],
          );
        });
  }

  void showToast(BuildContext context, String message, Duration duration) {
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              bottom: MediaQuery.of(context).size.height / 3,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Material(
                color: Colors.transparent,
                child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.signal_wifi_connected_no_internet_4,
                          color: Colors.black,
                          size: 50,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          message,
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ),
            ));
    Overlay.of(context).insert(overlayEntry);
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
