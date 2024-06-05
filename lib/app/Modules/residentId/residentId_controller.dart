import 'dart:convert';

import 'package:com.invoseg.innovation/app/data/Models/usersModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: file_names

class ResidentIdController extends GetxController {
  SharedPreferences? userInfo;
  String? jsonStringUser;
  UsersModel? userData;
  RxString residentId = ''.obs;

  Future<void> initializeSharedPreferences() async {
    userInfo = await SharedPreferences.getInstance();
    jsonStringUser = userInfo!.getString('userInfo');

    var userdata = jsonDecode(jsonStringUser!);

    userData = UsersModel.fromJson(userdata);
  }

  void fetchResidentId() async {
    await initializeSharedPreferences();
    residentId.value = userData!.residentID;
  }
}
