// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, file_names, avoid_print

import 'dart:convert';

import 'package:com.invoseg.innovation/main_app/app/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/notHomeModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/main_app/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/main_app/utils/getMobileTokens.dart';
import 'package:com.invoseg.innovation/main_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  UsersModel? userData;
  List<FamilyMembersModel> fmData = <FamilyMembersModel>[].obs;
  String docId = '';

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

    var userdata = jsonDecode(jsonStringUser!);
    // if (!userdata.toString().contains('ownermail')) {
    userData = UsersModel.fromJson(userdata);
  }

  Future<void> sendData() async {
    initializeSharedPreferences();
    String fcmToken = await getMobileToken();
    NotHomeModel notHome = NotHomeModel(
        fcmToken: fcmToken,
        address: userData?.address ?? "",
        age: userData?.age ?? "",
        email: "",
        designation: userData?.designation ?? "",
        name: userData?.name ?? "",
        fmName: fm1Name ?? "",
        fmName1: fm2Name ?? "",
        fmPhoneNo: "$fm1phone" ?? "",
        fmPhoneNo1: "$fm2phone" ?? "",
        phoneNo: userData?.phoneNumber ?? "",
        fPhoneNo: userData?.fatherPhoneNumber ?? "",
        fname: userData?.fatherName ?? "",
        from: currentDate.text ?? "",
        to: dateController.text ?? "",
        time: DateTime.now().millisecondsSinceEpoch,
        nh: false,
        noti: true,
        pressedTime: DateTime.now().millisecondsSinceEpoch,
        owner: userData?.owner ?? "",
        societyName: societyName ?? "",
        status: true,
        cancelled: false,
        edit: false,
        days: daysDifference ?? 0,
        uid: userData?.id ?? "",
        fmphoneNo: "$fm1phone" ?? "",
        fmphoneNo1: '$fm2phone' ?? "");

    final String url = '$ip/api/nothome';
    var sendData = jsonEncode(notHome.toJson());
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
        Get.back();
        Get.until((route) {
          return !(Get.isDialogOpen!);
        });

        Snackbars.successSnackBar('Smart Ghar', 'Your details has been sent');
        fetchNotHome();
      } else if (response.statusCode == 403) {
        var data = jsonDecode(response.body);
        EasyLoading.showError(data['error']);
      } else {
        EasyLoading.showError(data['message']);
        print("ERROR : ${response.body}");
      }
    } catch (e) {
      print("API Error : $e");
    }
  }

  Future<void> fetchNotHome() async {
    final String url = "$ip/api/nothome/$userId";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        notHomedocId.value = data[0]['_id'];
      } else {
        print("Error:${response.body}");
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }

  Future<void> cancelRequest() async {
    final String url = '$ip/api/nothome/${notHomedocId.value}';
    var body = jsonEncode({'status': false, 'cancelled': true});
    try {
      var response = await http.put(
        Uri.parse(url),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        },
      ).then((onValue) {
        notHomedocId.value = '';
        Get.back();
        Get.until((route) {
          return !(Get.isDialogOpen!);
        });

        Snackbars.successSnackBar('Smart Ghar', 'Your request has been cancelled');
      });
    } catch (e) {
      print("ERROR:$e");
    }
  }
}
