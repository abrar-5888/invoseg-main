import 'dart:convert';

import 'package:com.invoseg.innovation/app/data/Models/historyModel.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// ignore_for_file: avoid_print

class HistoryController extends GetxController {
  RxList<HistoryModel> histories = <HistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistories();
  }

  Future<void> fetchHistories() async {
    final String url = '$ip/api/history/$userId';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        // histories.add(HistoryModel.fromJson(data));
      } else {
        print("Error ${response.body}");
      }
    } catch (e) {
      print("Error :$e");
    }
  }
}
