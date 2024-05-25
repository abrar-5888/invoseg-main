// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.invoseg.innovation/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/data/Models/notHomeModel.dart';
import 'package:com.invoseg.innovation/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';
import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/getMobileTokens.dart';

class NotHomeController extends GetxController {
  RxInt days = 0.obs;
  RxString notHomedocId = ''.obs;
  RxString from = ''.obs;
  RxString to = ''.obs;
  DateTime selectedDate = DateTime.now();
  int daysDifference = 0;
  TextEditingController dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController currentDate = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  SharedPreferences? userInfo;
  String? jsonStringUser;
  String? jsonStringFM;
  var userData;
  List<FamilyMembersModel> fmData = <FamilyMembersModel>[].obs;
  String docId = '';
  String fm2Name = '';
  String fm2phone = '';
  String fm1Name = '';
  String fm1phone = '';

  @override
  void onInit() {
    super.onInit();
    fetchNotHome();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null && !isSameDate(picked, DateTime.now())) {
      final days = picked.difference(DateTime.now()).inDays;
      selectedDate = picked;
      dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      daysDifference = days;
    } else {
      Snackbars.errorSnackBar('NotHome', 'Please select another date');
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
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
    if (!userdata.toString().contains('ownermail')) {
      userData = UsersModel.fromJson(userdata);
    } else {
      userData = FamilyMembersModel.fromJson(userdata);
    }
  }

  Future<void> sendData() async {
    initializeSharedPreferences();
    String fcmToken = await getMobileToken();
    NotHomeModel notHome = NotHomeModel(
        societyName: 'izmir',
        Address: userData!.address ?? "",
        Age: userData!.age ?? "",
        Designation: userData!.designation ?? "",
        Email: userData!.email ?? "",
        FCMtoken: fcmToken,
        ID: FirebaseAuth.instance.currentUser!.uid,
        Name: userData!.name ?? "",
        Owner: userData!.owner ?? "",
        PhoneNo: userData!.phone ?? "",
        Status: true,
        cancelled: false,
        days: daysDifference,
        edit: false,
        fPhoneNo: userData!.fatherPhoneNo ?? "",
        fmName: userData!.fatherName ?? "",
        fmName1: fm2Name ?? "",
        fmphoneNo: fm1phone ?? "",
        fmphoneNo1: fm2phone ?? "",
        fname: fm1Name ?? "",
        from: currentDate.text,
        nh: false,
        noti: true,
        pressedTime: DateTime.now().millisecondsSinceEpoch,
        time: DateTime.now().millisecondsSinceEpoch,
        to: dateController.text,
        uid: FirebaseAuth.instance.currentUser!.uid);

    await FirebaseFirestore.instance.collection(FirebaseNodes.NOTHOME).add(notHome.toJson()).then((value) {
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      Get.back();
      Snackbars.successSnackBar('Not Home', 'Your details has been sent');
    });
  }

  Future<void> fetchNotHome() async {
    FirebaseFirestore.instance
        .collection(FirebaseNodes.NOTHOME)
        .where('Status', isEqualTo: true)
        .orderBy('pressedTime', descending: true)
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        var data = doc.data();
        days.value = data['days'];
        from.value = data['from'];
        to.value = data['to'];
        notHomedocId.value = doc.id;
        if (to.value == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          FirebaseFirestore.instance.collection(FirebaseNodes.NOTHOME).doc(doc.id).update({
            'Status': false,
          });
        }
      }
    });
  }

  Future<void> cancelRequest() async {
    FirebaseFirestore.instance.collection(FirebaseNodes.NOTHOME).doc(notHomedocId.value).update({
      'Status': false,
      'cancelled': true,
    }).then((value) => {
          notHomedocId.value = '',
          Get.back(),
          Snackbars.successSnackBar('Not Home', 'Your Not Home request is cancelled'),
        });
  }
}
