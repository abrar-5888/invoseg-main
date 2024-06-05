// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:com.invoseg.innovation/app/data/Models/groceryModel.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GroceryController extends GetxController {
  RxList<GroceryModel> groceries = <GroceryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchGrocery();
  }

  Future<void> fetchGrocery() async {
    final String url = '$ip/api/orders/$userId';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        for (var i in data) {
          groceries.add(GroceryModel.fromJson(i));
        }
      } else {
        print("ERRORS:${response.body}");
      }
    } catch (e) {
      print("ERRORS : $e");
    }
  }
}
