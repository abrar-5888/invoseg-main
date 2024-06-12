// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/app/Modules/feeds/feeds_view.dart';
import 'package:com.invoseg.innovation/app/Modules/grocery/grocery_view.dart';
import 'package:com.invoseg.innovation/app/Modules/history/history_view.dart';
import 'package:com.invoseg.innovation/app/Modules/home/home_view.dart';
import 'package:com.invoseg.innovation/app/Modules/plots/plots_view.dart';
import 'package:com.invoseg.innovation/app/data/Models/notificationModel.dart';
import 'package:com.invoseg.innovation/app/data/api/firebaseNodes.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// ignore_for_file: prefer_const_constructors

class MainPageController extends GetxController {
  RxList<NotificationModel> unReadNotifications = <NotificationModel>[].obs;
  RxList<NotificationModel> unReadNotificationsGrocery = <NotificationModel>[].obs;

  RxList<NotificationModel> unReadNotificationsMedical = <NotificationModel>[].obs;
  final RxInt selectScreen = 0.obs;
  final List<String> barTitles = ['Home', 'Feeds', 'Grocery', 'Plots & Houses', 'History'];
  final List<Widget> screens = <Widget>[
    const HomeScreen(),
    const Feeds(),
    Grocery(),
    const Plots(),
    const HistoryScreen(),
  ];
  Future<void> fetchNotifications() async {
    try {
      FirebaseFirestore.instance.collection(FirebaseNodes.NOTIFICATIONS).where('isRead', isEqualTo: false).snapshots().listen((event) {
        unReadNotifications.value = event.docs.map((e) => NotificationModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void fetchLogo(String sn) async {
    String url = "$ip/api/logo/$societyName";

    try {
      var response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
      } else {
        print("Not success${response.body}");
      }
    } catch (e) {
      print("ERROR : $e");
    }
  }

  void itemTap(int index) {
    // if (index == 2) {
    //   NotificationsApi.updateIsReadGrocery();
    // }
    // if (index == 3) {
    //   NotificationsApi.updateIsReadMedical();
    // }
    selectScreen.value = index;
  }
}
