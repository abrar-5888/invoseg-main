import 'dart:convert';

import 'package:com.invoseg.innovation/main_app/app/data/Models/usersModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

class ProfileController extends GetxController {
  late Future<void> initializeSharedPreferencesFuture;
  SharedPreferences? userInfo;
  String? jsonString;
  UsersModel? userData;

  @override
  void onInit() {
    super.onInit();
    initializeSharedPreferencesFuture = initializeSharedPreferences();
  }

  // Future<void> initializeSharedPreferences() async {
  //   EasyLoading.show();
  //   userInfo = await SharedPreferences.getInstance();
  //   jsonString = userInfo!.getString('userInfo');

  //   var data = jsonDecode(jsonString!);
  //   if (!data.toString().contains('ownermail')) {
  //     userData = UsersModel.fromJson(data);
  //     EasyLoading.dismiss();
  //   } else {
  //     userData = FamilyMembersModel.fromJson(data);
  //     EasyLoading.dismiss();
  //   }
  // }
  Future<void> initializeSharedPreferences() async {
    userInfo = await SharedPreferences.getInstance();
    jsonString = userInfo!.getString('userInfo');

    var userdata = jsonDecode(jsonString!);
    // if (!userdata.toString().contains('ownermail')) {
    userData = UsersModel.fromJson(userdata);
  }
}
