// ignore_for_file: avoid_print, unnecessary_overrides

import 'dart:convert';

import 'package:com.invoseg.innovation/app/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/groceryRequestModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/plotsModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/securityRequestModel.dart';
import 'package:com.invoseg.innovation/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/app/data/api/plotsApi.dart';
import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/getMobileTokens.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

class HomeController extends GetxController {
  RxList<PlotsModel> plots = <PlotsModel>[].obs;
  SharedPreferences? userInfo;
  String? jsonStringUser;
  String? jsonStringFM;
  UsersModel? userData;
  List<FamilyMembersModel> fmData = <FamilyMembersModel>[].obs;
  String docId = '';
  String fm2Name = '';
  String fm2phone = '';
  String fm1Name = '';
  String fm1phone = '';

  @override
  void onInit() {
    super.onInit();
    fetchPlots();
  }

  void fetchPlots() async {
    try {
      PlotsAPI.plotsQuery.snapshots().listen((event) {
        plots.value = event.docs.map((e) => PlotsModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      print(e);
    }
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
    // if (!userdata.toString().contains('ownermail')) {
    userData = UsersModel.fromJson(userdata);
  }

  Future<void> alertMe(String collectionName) async {
    await initializeSharedPreferences();

    String fcmToken = await getMobileToken();
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("Connectivity == ${connectivityResult.toString()}");
    if (connectivityResult == ConnectivityResult.none) {
      Snackbars.errorSnackBar('internet Connection', "Please connect to internet connection");
    } else {
      if (collectionName.toLowerCase() == 'button-one') {
        SecurityRequestModel securityRequestModel = SecurityRequestModel(
          fcmToken: fcmToken,
          address: userData?.address ?? "",
          age: userData?.age ?? "",
          count: false,
          designation: userData?.designation ?? '',
          email: 'example@example.com',
          fatherPhoneNumber: '1234567890',
          familyMemberName: 'John',
          familyMemberName1: 'Doe',
          fatherName: userData?.fatherName ?? "",
          name: name,
          notification: true,
          owner: userData!.owner,
          phoneNumber: phone,
          residentId: 'res123',
          pressedTime: DateTime.now().toString(),
          pressedTime1: DateTime.now().toString(),
          securityComplain: 'No complaint',
          securityStatus: true,
          societyName: userData!.societyName,
          response: "",
          userId: userData!.id,
          edit: false,
          buttonType: 'button-one',
        );

        final String url = '$ip/api/security/create';
        var sendData = jsonEncode(securityRequestModel.toJson());
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
            sendHistory('button-one').then((sas) {
              sendEmail(
                  name: name,
                  email: '',
                  message:
                      "type : button-one\n name : $name\nAddress : ${userData!.address}\nPhone No : ${userData!.phoneNumber}\nF-Phone No ${userData!.fatherPhoneNumber}\nF-Name : ${userData!.fatherName}\nDesignation :${userData?.designation ?? ""}\nage :${userData?.age ?? ""}\nOwner :${userData?.owner ?? ""}",
                  subject: "test subject");
            });

            Get.back();
            Get.until((route) {
              return !(Get.isDialogOpen!);
            });

            Snackbars.successSnackBar('Invoseg', 'Your details has been sent');
          } else {
            EasyLoading.showError(data['message']);
            print("ERROR : ${response.body}");
          }
        } catch (e) {
          print("API Error : $e");
        }
      } else {
        GroceryRequestModel groceryRequestModel = GroceryRequestModel(
          fcmToken: fcmToken,
          address: userData?.address ?? '',
          age: userData?.age ?? '',
          count: false,
          designation: userData?.designation ?? '',
          email: 'example@example.com',
          fatherPhoneNumber: '1234567890',
          familyMemberName: 'John',
          familyMemberName1: 'Doe',
          fatherName: userData!.fatherName,
          name: name,
          notification: true,
          owner: userData!.owner,
          phoneNumber: phone,
          residentId: 'res123',
          pressedTime: DateTime.now().toString(),
          pressedTime1: DateTime.now().toString(),
          societyName: userData!.societyName,
          response: "",
          userId: userData!.id,
          edit: false,
          buttonType: 'button-three',
        );

        final String url = '$ip/api/grocery/create';
        var sendData = jsonEncode(groceryRequestModel.toJson());
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
            sendHistory('button-three').then((sas) {
              sendEmail(
                  name: name,
                  email: '',
                  message:
                      "type : button-three\n name : $name\nAddress : ${userData!.address}\nPhone No : ${userData!.phoneNumber}\nF-Phone No ${userData!.fatherPhoneNumber}\nF-Name : ${userData!.fatherName}\nDesignation :${userData?.designation ?? ""}\nage :${userData?.age ?? ""}\nOwner :${userData?.owner ?? ""}",
                  subject: "test subject");
            });
            Get.back();
            Get.until((route) {
              return !(Get.isDialogOpen!);
            });

            Snackbars.successSnackBar('Invoseg', 'Your details has been sent');
          } else {
            EasyLoading.showError(data['message']);
            print("ERROR : ${response.body}");
          }
        } catch (e) {
          Snackbars.errorSnackBar('internet Connection', "Your internet connection is not stable");
        }
      }
    }
  }

  Future<void> sendHistory(String type) async {
    final String url = '$ip/api/history';
    var body = jsonEncode({'type': type, 'uid': userId});
    try {
      var response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 201) {
        print("Success");
      } else {
        print("Error :${response.body}");
      }
    } catch (e) {
      print("ERROR :$e");
    }
  }

  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
  
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    var serviceId = 'service_s7hyzpr';
    var templateId = 'template_0yvlqvj';
    var userId = 'Jg-9ZFPX61IpyTv1w';
    final response = await http.post(url,
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {'user_name': name, 'from_name': name, 'mail': "venrablejutt310@gmail.com", 'user_subject': subject, 'to_email': "daniyalhumayun7@gmail.com", 'user_message': message},
        }),
        headers: {'origin': "http://localhost", 'Content-Type': 'application/json'});

    print(response.body);
  }
}
