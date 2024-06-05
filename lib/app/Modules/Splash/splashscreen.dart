import 'dart:async';
import 'dart:convert';

import 'package:com.invoseg.innovation/app/Modules/Main/main_view.dart';
import 'package:com.invoseg.innovation/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/generated/assets.dart';
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
    await initializeSharedPreferences();

    await Future.delayed(const Duration(seconds: 3));

    if (userData == null) {
      Get.off(() => const LoginPage());
    } else {
      Get.to(const MainPage(index: 0));
    }
  }

  UsersModel? userData;
  Future<void> initializeSharedPreferences() async {
    var userInfo = await SharedPreferences.getInstance();
    var jsonStringUser = userInfo.getString('userInfo');

    var userdata = jsonDecode(jsonStringUser!);
    userData = UsersModel.fromJson(userdata);
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
