// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:com.invoseg.innovation/main_app/app/Modules/Main/main_view.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/main_app/generated/assets.dart';
import 'package:com.invoseg.innovation/main_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 3));
    await initializeSharedPreferences();
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
        appLogo.value = data['logo'];
      } else {
        print("Not success${response.body}");
      }
    } catch (e) {
      print("ERROR : $e");
    }
  }

  Future<void> fetchButton(String sn) async {
    final String url = "$ip/api/button/XYZ";

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print("ButtonsData::$data");
      } else {
        print("Error :${jsonDecode(response.body)}");
      }
    } catch (e) {
      print("ERROR : $e");
    }
  }

  Future<void> initializeSharedPreferences() async {
    var userInfo = await SharedPreferences.getInstance();
    String jsonStringUser = userInfo.getString('userInfo') ?? '';

    if (jsonStringUser.isEmpty) {
      Get.off(() => const LoginPage());
    } else {
      var userdata = jsonDecode(jsonStringUser);
      UsersModel userData = UsersModel.fromJson(userdata);
      print("userdata$userdata");
      societyName = userData.societyName;
      name = userData.name;
      phone = userData.phoneNumber;
      address = userData.address;
      familyId = userData.familyID;
      userId = userData.id;
      fetchLogo(userData.societyName);
      fetchButton(userData.societyName);

      Get.off(() => const MainPage(index: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F2164),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 270,
                width: 270,
                child: Image.asset(Assets.logo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
