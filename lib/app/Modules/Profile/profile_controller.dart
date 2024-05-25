import 'dart:convert';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/data/Models/usersModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:com.invoseg.innovation/data/Models/familyMembersModel.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

class ProfileController extends GetxController {
  late Future<void> initializeSharedPreferencesFuture;
  SharedPreferences? userInfo;
  String? jsonString;
  var userData;

  @override
  void onInit() {
    super.onInit();
    initializeSharedPreferencesFuture = initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    EasyLoading.show();
    userInfo = await SharedPreferences.getInstance();
    jsonString = userInfo!.getString('userInfo');

    var data = jsonDecode(jsonString!);
    if (!data.toString().contains('ownermail')) {
      userData = UsersModel.fromJson(data);
      EasyLoading.dismiss();
    } else {
      userData = FamilyMembersModel.fromJson(data);
      EasyLoading.dismiss();
    }
  }
}
