// ignore_for_file: unnecessary_overrides, avoid_print

import 'dart:convert';

import 'package:com.invoseg.innovation/main_app/app/data/Models/complainModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/complainRequestModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/main_app/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/main_app/utils/getMobileTokens.dart';
import 'package:com.invoseg.innovation/main_app/utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

class ComplainController extends GetxController {
  var textController = TextEditingController().obs;
  RxList<ComplainModel> complains = <ComplainModel>[].obs;
  SharedPreferences? userInfo;
  String? jsonStringUser;
  String? jsonStringFM;
  UsersModel? userData;
  RxList<FamilyMembersModel> fmData = <FamilyMembersModel>[].obs;
  String docId = '';

  @override
  void onInit() {
    super.onInit();
    fetchComplain();
  }

  Future<void> initializeSharedPreferences() async {
    userInfo = await SharedPreferences.getInstance();
    jsonStringUser = userInfo!.getString('userInfo');

    var userdata = jsonDecode(jsonStringUser!);

    userData = UsersModel.fromJson(userdata);
  }

  Future<void> alertMe() async {
    EasyLoading.show();
    if (textController.value.text.isNotEmpty) {
      await initializeSharedPreferences();
      String fcmToken = await getMobileToken();
      ComplainRequestModel securityRequestModel = ComplainRequestModel(
        fcmToken: fcmToken,
        address: userData!.address ?? "",
        age: userData!.age ?? "",
        count: false,
        designation: userData!.designation ?? '',
        email: userData?.email ?? '',
        fatherPhoneNumber: userData!.fatherPhoneNumber,
        familyMemberName: fm1Name,
        familyMemberName1: fm2Name,
        fatherName: userData!.fatherName,
        name: name,
        notification: true,
        owner: userData!.owner,
        phoneNumber: phone,
        residentId: userData!.residentID,
        pressedTime: DateTime.now().toString(),
        pressedTime1: DateTime.now().toString(),
        complain: textController.value.text,
        complainStatus: false,
        societyName: userData!.societyName,
        response: "",
        userId: userData!.id,
        edit: false,
        buttonType: 'complain',
        fmphoneNo: "$fm1phone",
        fmphoneNo1: "$fm2phone",
      );

      final String url = '$ip/api/complain/create';
      var sendData = jsonEncode(securityRequestModel.toJson());
      try {
        var response = await http.post(
          Uri.parse(url),
          body: sendData,
          headers: {
            'Content-Type': 'application/json',
          },
        );
        var data = jsonDecode(response.body);
        if (response.statusCode == 201) {
          textController.value.clear();
          complains.clear();
          await fetchComplain();
          EasyLoading.dismiss();
        } else if (response.statusCode == 403) {
          var data = jsonDecode(response.body);
          EasyLoading.showError(data['error']);
        } else {
          EasyLoading.dismiss();
          EasyLoading.showError(data['message']);
          print("ERROR : ${response.body}");
        }
      } catch (e) {
        EasyLoading.dismiss();
        print("API Error : $e");
      }
    } else {
      EasyLoading.dismiss();
      Snackbars.errorSnackBar('Complain', 'Complain cannot be empty');
    }
  }

  Future<void> fetchComplain() async {
    final String url = '$ip/api/complain/$userId';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var i in data) {
          complains.add(ComplainModel.fromJson(i));
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print("ERROR $e");
    }
  }
}
