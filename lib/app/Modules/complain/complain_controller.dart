// ignore_for_file: unnecessary_overrides

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.invoseg.innovation/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/data/Models/sendRequestModel.dart';
import 'package:com.invoseg.innovation/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';
import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/formatter.dart';
import 'package:com.invoseg.innovation/utils/getMobileTokens.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

class ComplainController extends GetxController {
  var textController = TextEditingController().obs;

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
    if (!userdata.toString().contains('ownermail')) {
      userData = UsersModel.fromJson(userdata);
    } else {
      userData = FamilyMembersModel.fromJson(userdata);
    }
  }

  Future<void> alertMe() async {
    if (textController.value.text.isNotEmpty) {
      initializeSharedPreferences();
      String fcmToken = await getMobileToken();
      SendRequestModel sendRequestModel = SendRequestModel(
          fcmToken: fcmToken,
          address: userData.address,
          age: userData.age,
          date: formatDate(DateTime.now().millisecondsSinceEpoch),
          designation: userData.designation,
          email: userData.email,
          fatherPhoneNo: userData.fatherPhoneNo ?? "",
          fatherName: userData.fatherName ?? "",
          fm1Name: fm1Name,
          fm1PhoneNo: fm1phone,
          fm2Name: fm2Name,
          fm2phoneNo: fm2phone,
          name: userData.name,
          phone: userData.phone,
          noti: true,
          owner: userData.owner,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          residentId: '',
          societyName: 'izmir',
          time: formatTime(DateTime.now().millisecondsSinceEpoch),
          uid: FirebaseAuth.instance.currentUser!.uid,
          edit: false,
          type: 'complain');
      FirebaseFirestore.instance.collection(FirebaseNodes.COMPLAIN).add(sendRequestModel.toJson()).then((value) async {
        await FirebaseFirestore.instance.collection(FirebaseNodes.COMPLAIN).doc(value.id).update({'complain': textController.value.text});
        textController.value.clear();
        Snackbars.successSnackBar("Complain", "Complain has been sent");
      });
    } else {
      Snackbars.errorSnackBar('Complain', 'Complain cannot be empty');
    }
  }
}
