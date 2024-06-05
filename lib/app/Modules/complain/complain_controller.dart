// ignore_for_file: unnecessary_overrides, avoid_print

import 'dart:convert';

import 'package:com.invoseg.innovation/app/data/Models/complainModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/complainRequestModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/getMobileTokens.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
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
  var userData;
  RxList<FamilyMembersModel> fmData = <FamilyMembersModel>[].obs;
  String docId = '';
  String fm2Name = '';
  String fm2phone = '';
  String fm1Name = '';
  String fm1phone = '';

  @override
  void onInit() {
    super.onInit();
    fetchComplain();
  }

  Future<void> initializeSharedPreferences() async {
    userInfo = await SharedPreferences.getInstance();
    jsonStringUser = userInfo!.getString('userInfo');
    jsonStringFM = userInfo!.getString('fmUserInfo');
    if (jsonStringFM != null) {
      var fmUserdata = jsonDecode(jsonStringFM!);
      for (var fm in fmUserdata) {
        fmData.add(FamilyMembersModel.fromJson(fm));
        if (fmData.isNotEmpty) {
          fm1Name = fmData.first.name;
          fm1phone = fmData.first.phonenumber;
          if (fmData.length > 1) {
            fm2Name = fmData[1].name;
            fm2phone = fmData[1].phonenumber;
          }
        }
      }
    }

    var userdata = jsonDecode(jsonStringUser!);

    userData = UsersModel.fromJson(userdata);
  }

  Future<void> alertMe() async {
    if (textController.value.text.isNotEmpty) {
      await initializeSharedPreferences();
      String fcmToken = await getMobileToken();
      ComplainRequestModel securityRequestModel = ComplainRequestModel(
        fcmToken: fcmToken,
        address: userData!.address ?? "",
        age: userData!.age ?? "",
        count: false,
        designation: userData!.designation ?? '',
        email: 'example@example.com',
        fatherPhoneNumber: '1234567890',
        familyMemberName: 'John',
        familyMemberName1: 'Doe',
        fatherName: userData!.fatherName,
        name: name,
        notification: true,
        owner: userData!.owner,
        phoneNumber: phone,
        residentId: 'res123',
        pressedTime: DateTime.now().toString(),
        pressedTime1: DateTime.now().toString(),
        complain: textController.value.text,
        complainStatus: false,
        societyName: userData!.societyName,
        response: "",
        userId: userData!.id,
        edit: false,
        buttonType: 'complain',
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

          Snackbars.successSnackBar('Invoseg', 'Your details has been sent');
        } else {
          EasyLoading.showError(data['message']);
          print("ERROR : ${response.body}");
        }
      } catch (e) {
        print("API Error : $e");
      }
    } else {
      Snackbars.errorSnackBar('Complain', 'Complain cannot be empty');
    }
  }

  Future<void> fetchComplain() async {
    final String url = '$ip/api/complain/6655aa3b63aefb20300501cb';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var i in data) {
          complains.add(ComplainModel.fromJson(i));
          print(complains);
        }
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print("ERROR $e");
    }
  }
}
