// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:com.invoseg.innovation/app/data/Models/announcementModel.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AnnouncementDialogController extends GetxController {
  RxBool showAnnouncementDialog = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  AnnouncementModel? announcement;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    final String url = '$ip/api/announcement/$userId';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          announcement = AnnouncementModel.fromJson(data[0]);

          showAnnouncementDialog.value = true;
        } else {
          print('Data is null');
        }
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("ERROR $e");
    }
  }

  Future<void> updateAnnouncements() async {
    List<String> updatedSeenUids = List<String>.from(announcement!.seenUids);
    updatedSeenUids.add(userId);
    final String url = '$ip/api/announcement/${announcement!.id}';
    var body = jsonEncode({'seenUids': updatedSeenUids});

    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        showAnnouncementDialog.value = false;
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("ERROR $e");
    }
  }
}
