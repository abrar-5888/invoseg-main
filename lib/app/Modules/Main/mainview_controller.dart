import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/data/Models/notificationModel.dart';
import 'package:com.invoseg.innovation/data/api/notificationsApi.dart';
import 'package:com.invoseg.innovation/utils/global.dart';

import '../feeds/feeds_view.dart';
import '../grocery/grocery_view.dart';
import '../home/home_view.dart';
import '../medical/medical_view.dart';
import '../plots/plots_view.dart';

// ignore_for_file: prefer_const_constructors

class MainPageController extends GetxController {
  RxList<NotificationModel> unReadNotifications = <NotificationModel>[].obs;
  RxList<NotificationModel> unReadNotificationsGrocery = <NotificationModel>[].obs;

  RxList<NotificationModel> unReadNotificationsMedical = <NotificationModel>[].obs;
  RxInt notiLength = 0.obs;
  RxInt groceryCount = 0.obs;
  RxString logo = ''.obs;
  RxInt medicalCount = 0.obs;
  final RxInt selectScreen = 0.obs;
  final List<String> barTitles = ['Home', 'Feeds', 'Grocery', 'Medical', 'Plots & Houses'];
  final List<Widget> screens = <Widget>[const HomeScreen(), const Feeds(), Grocery(), const Medical(), const Plots()];

  void itemTap(int index) {
    if (index == 2) {
      NotificationsApi.updateIsReadGrocery();
    }
    if (index == 3) {
      NotificationsApi.updateIsReadMedical();
    }
    selectScreen.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotiLength();
    fetchLogo();
  }

  Future<void> fetchNotiLength() async {
    NotificationsApi.notificationQuery.where('isRead', isEqualTo: false).snapshots().listen((event) {
      unReadNotifications.value = event.docs.map((e) => NotificationModel.fromJson(e.data())).toList();

      for (var noti in unReadNotifications) {
        if (noti.title.toLowerCase() == 'grocery') {
          unReadNotificationsGrocery.add(noti);
        }
        if (noti.title.toLowerCase() == 'medical') {
          unReadNotificationsGrocery.add(noti);
        }
      }
      notiLength.value = unReadNotifications.length;
      groceryCount.value = unReadNotificationsGrocery.length;
      medicalCount.value = unReadNotificationsMedical.length;
    });
  }

  void fetchLogo() async {
    FirebaseFirestore.instance.collection('Logo').where('societyName', isEqualTo: societyName).limit(1).snapshots().listen((event) {
      var data = event.docs.first.data();
      logo.value = data['logoId'];
    });
  }
}
