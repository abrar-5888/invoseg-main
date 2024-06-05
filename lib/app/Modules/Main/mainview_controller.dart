import 'package:com.invoseg.innovation/app/Modules/feeds/feeds_view.dart';
import 'package:com.invoseg.innovation/app/Modules/grocery/grocery_view.dart';
import 'package:com.invoseg.innovation/app/Modules/history/history_view.dart';
import 'package:com.invoseg.innovation/app/Modules/home/home_view.dart';
import 'package:com.invoseg.innovation/app/Modules/plots/plots_view.dart';
import 'package:com.invoseg.innovation/app/data/Models/notificationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
