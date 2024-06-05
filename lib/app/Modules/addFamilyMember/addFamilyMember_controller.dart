// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// ignore_for_file: file_names

class AddFamilyMemberController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var sPassword = TextEditingController();
  var cPassword = TextEditingController();
  RxInt remaining = 10.obs;
  @override
  void onInit() {
    super.onInit();
    fetchCount();
  }

  String generateRandomFourDigitCode() {
    Random random = Random();
    int code = random.nextInt(10000);

    return code.toString().padLeft(4, '0');
  }

  Future<void> fetchCount() async {
    final String url = '$ip/api/users/family/$familyId';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        int count = data['userCount'] - 1;
        remaining.value = remaining.value - count;
      } else {
        print("Error : ${response.body}");
      }
    } catch (e) {
      print("ERROR :$e");
    }
  }

  Future<void> registerFM(BuildContext context) async {
    var residentId = 'SG${generateRandomFourDigitCode()}';
    var url = Uri.parse('$ip/api/users');
    if (remaining.value != 0) {
      var response = await http.post(url, body: {
        'Name': nameController.text,
        "residentId": residentId,
        'email': emailController.text,
        'password': sPassword.text,
        'phonenumber': phoneController.text,
        'familyID': familyId,
        "societyName": societyName
      });
      try {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data);
          print('Family Member Added successfully');
          sPassword.clear();
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          remaining = remaining - 1;
          Snackbars.successSnackBar('Smart Ghar', 'Family member added successfully');
        } else {
          Snackbars.errorSnackBar('Smart Ghar', 'Please check your internet connection');
        }
      } catch (e) {
        Snackbars.errorSnackBar('Smart Ghar', 'Please check your internet connection');
      }
    } else {
      Snackbars.errorSnackBar('Smart Ghar', 'You have exceed your limit');
    }
  }
}
