// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:com.invoseg.innovation/app/data/Models/groceryModel.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EReciptController extends GetxController {
  RxString id = ''.obs;
  GroceryModel? grocery;
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    isLoading.value = true;
    final String url = '$ip/api/orders/order/$id';
    print(url);
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        grocery = GroceryModel.fromJson(data[0]);

        isLoading.value = false;
      } else {
        print("Error : ${response.body}");
        isLoading.value = false;
      }
    } catch (e) {
      print("ERROR : $e");
      isLoading.value = false;
    }
  }
}
