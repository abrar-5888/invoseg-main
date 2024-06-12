import 'dart:async';
import 'dart:convert';

import 'package:com.invoseg.innovation/app/Modules/Main/main_view.dart';
import 'package:com.invoseg.innovation/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/generated/assets.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  Future<void> initializeSharedPreferences() async {
    var userInfo = await SharedPreferences.getInstance();
    String jsonStringUser = userInfo.getString('userInfo') ?? '';

    if (jsonStringUser.isEmpty) {
      Get.off(() => const LoginPage());
    } else {
      var userdata = jsonDecode(jsonStringUser);
      UsersModel userData = UsersModel.fromJson(userdata);
      print(userdata);
      societyName = userData.societyName;
      name = userData.name;
      phone = userData.phoneNumber;
      address = userData.address;
      familyId = userData.familyID;
      userId = userData.id;

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
