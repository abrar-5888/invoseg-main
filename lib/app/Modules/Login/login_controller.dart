import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/app/Modules/Main/main_view.dart';
import 'package:com.invoseg.innovation/app/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: avoid_print

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var emailOrPhone = TextEditingController().obs;
  var pass = TextEditingController().obs;
  UsersModel? user;
  List<FamilyMembersModel> fm = <FamilyMembersModel>[].obs;
  FamilyMembersModel? familyMemberUser;
  String mainCollectionId = '';
  String phoneEmail = '';
  String phoneSubCollectionId = '';
  RxBool showPass = true.obs;

  bool checkForm() {
    if (emailOrPhone.value.text.isEmpty || pass.value.text.isEmpty) {
      Snackbars.errorSnackBar('Login', 'Please fill all fields');
      return false;
    }
    if (pass.value.text.length < 6) {
      Snackbars.errorSnackBar('Login', 'Password must contain 6 digits');
      return false;
    }

    return true;
  }

  void fetchLogo(String sn) async {
    String url = "$ip/api/logo/$societyName";

    try {
      var response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
      } else {
        print("Not success${response.body}");
      }
    } catch (e) {
      print("ERROR : $e");
    }
  }

  void loginWithNode() async {
    SharedPreferences userInfo = await SharedPreferences.getInstance();
    final String url = '$ip/api/users/login';
    try {
      var response = await http.post(Uri.parse(url), body: {
        "phonenumber": emailOrPhone.value.text,
        "password": pass.value.text,
      });
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        user = UsersModel.fromJson(data);
        var userJsonString = json.encode(user!.toJson());
        await userInfo.setString('userInfo', userJsonString);
        name = user!.name;
        phone = user!.phoneNumber;
        address = user!.address;
        familyId = user!.familyID;
        societyName = user!.societyName;
        userId = user!.id;
        fetchLogo(user!.societyName);
        Get.off(() => const MainPage(index: 0));
      } else {
        EasyLoading.showError(data['message']);
        print("ERROR : ${response.body}");
      }
    } catch (e) {
      print("API Error : $e");
    }
  }
}
