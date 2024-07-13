// ignore_for_file: file_names

import 'dart:convert';

import 'package:com.invoseg.innovation/main_app/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/main_app/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FamilymembersController extends GetxController {
  List<UsersModel> familyMembers = <UsersModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFamilyMember();
  }

  Future<void> fetchFamilyMember() async {
    final String url = '$ip/api/users/find/$userId';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        var family = data['family'];
        for (var fam in family) {
          familyMembers.add(UsersModel.fromJson(fam));
        }
      } else {
        print("Error (${response.body})");
      }
    } catch (e) {
      print("Error : $e");
    }
  }
}
