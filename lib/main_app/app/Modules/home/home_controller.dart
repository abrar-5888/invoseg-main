// ignore_for_file: avoid_print, unnecessary_overrides

import 'dart:convert';

import 'package:com.invoseg.innovation/main_app/app/Modules/history/history_controller.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/groceryRequestModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/plotsModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/securityRequestModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/api/plotsApi.dart';
import 'package:com.invoseg.innovation/main_app/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/main_app/utils/formatter.dart';
import 'package:com.invoseg.innovation/main_app/utils/getMobileTokens.dart';
import 'package:com.invoseg.innovation/main_app/utils/global.dart';
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

  @override
  void onInit() {
    super.onInit();
    fetchPlots();
    fetchFamilyMember();
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

    var userdata = jsonDecode(jsonStringUser!);
    // if (!userdata.toString().contains('ownermail')) {
    userData = UsersModel.fromJson(userdata);
  }

  Future<void> fetchFamilyMember() async {
    final String url = '$ip/api/users/find/$userId';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // print(data);
        var family = data['family'];
        print("family: $family");

        if (family != null && family is List) {
          if (family.isNotEmpty) {
            fm1Name = family[0]['name'];
            fm1phone = family[0]['fPhoneNo'];
            
            if (family.length > 1) {
              fm2Name = family[1]['name'];
              fm2phone = family[1]['fPhoneNo'];
            }
          }
        } else {
          print("No family members found");
        }
      } else {
        print("Error (${response.body})");
      }
    } catch (e) {
      print("Error : $e");
    }
  }

  Future<void> alertMe(String collectionName) async {
    EasyLoading.show();
    await initializeSharedPreferences();

    String fcmToken = await getMobileToken();
    var connectivityResult = await (Connectivity().checkConnectivity());
    print("Connectivity == ${connectivityResult.toString()}");
    if (connectivityResult == ConnectivityResult.none) {
      EasyLoading.dismiss();
      Snackbars.errorSnackBar('internet Connection', "Please connect to internet connection");
    } else {
      if (collectionName.toLowerCase() == 'button-one') {
        print(fm1phone);
        SecurityRequestModel securityRequestModel = SecurityRequestModel(
            fcmToken: fcmToken,
            address: userData?.address ?? "",
            age: userData?.age ?? "",
            count: false,
            designation: userData?.designation ?? '',
            email: userData?.email ?? '',
            fatherPhoneNumber: userData!.fatherPhoneNumber,
            familyMemberName: fm1Name,
            familyMemberName1: fm2Name,
            fatherName: userData?.fatherName ?? "",
            name: name,
            notification: true,
            owner: userData!.owner,
            phoneNumber: phone,
            residentId: userData!.residentID,
            pressedTime: DateTime.now().toString(),
            pressedTime1: DateTime.now().toString(),
            securityComplain: 'No complaint',
            securityStatus: false,
            societyName: userData!.societyName,
            response: "",
            userId: userData!.id,
            edit: false,
            buttonType: 'button-one',
            fmphoneNo: fm1phone.toString(),
            fmphoneNo1: fm2phone,
            date: formatDate(DateTime.now().millisecondsSinceEpoch),
            time: formatTime(DateTime.now().millisecondsSinceEpoch));

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
            print("SEC DATA $data");
            sendHistory('button-one').then((sas) {
              sendEmail(
                  name: name,
                  email: '',
                  message:
                      "type : button-one\n name : $name\nAddress : $address\nPhone No : $phone\nF-Phone No ${userData!.fatherPhoneNumber}\nF-Name : ${userData!.fatherName}\nDesignation :${userData?.designation ?? ""}\nage :${userData?.age ?? ""}\nOwner :${userData?.owner ?? ""}\nMapUrl :${userData?.mapUrl ?? ""}",
                  subject: "button-one");
            });

            Get.back();
            Get.until((route) {
              return !(Get.isDialogOpen!);
            });
            HistoryController controller = Get.put<HistoryController>(HistoryController());
            controller.histories.clear();
            controller.fetchHistories();
            EasyLoading.dismiss();
            Snackbars.successSnackBar('Smart Ghar', 'Your details has been sent');
          } else if (response.statusCode == 403) {
            var data = jsonDecode(response.body);
            EasyLoading.showError(data['error']);
          } else {
            // EasyLoading.dismiss();
            EasyLoading.showError(data['message']);
            print("ERROR : ${response.body}");
          }
        } catch (e) {
          EasyLoading.showError("Something went wrong");

          print("API Error : $e");
        }
      } else {
        print(fm1phone);
        GroceryRequestModel groceryRequestModel = GroceryRequestModel(
          date: formatDate(DateTime.now().millisecondsSinceEpoch),
          time: formatTime(DateTime.now().millisecondsSinceEpoch),
          fcmToken: fcmToken,
          address: userData?.address ?? '',
          age: userData?.age ?? '',
          count: false,
          designation: userData?.designation ?? '',
          email: userData?.email ?? '',
          fatherPhoneNumber: '1234567890',
          familyMemberName: fm1Name ?? "",
          familyMemberName1: fm2Name ?? "",
          fatherName: userData?.fatherName ?? "",
          name: name,
          notification: true,
          owner: userData?.owner ?? "",
          phoneNumber: phone,
          residentId: userData?.residentID ?? "",
          pressedTime: DateTime.now().toString(),
          pressedTime1: DateTime.now().toString(),
          societyName: userData!.societyName,
          response: "",
          userId: userData?.id ?? "",
          edit: false,
          buttonType: 'button-three',
          fmphoneNo: fm1phone.toString(),
          fmphoneNo1: fm2phone ?? "",
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
                      "type : button-three\n name : $name\nAddress :  $address\nPhone No : $phone\nF-Phone No ${userData!.fatherPhoneNumber}\nF-Name : ${userData!.fatherName}\nDesignation :${userData?.designation ?? ""}\nage :${userData?.age ?? ""}\nOwner :${userData?.owner ?? ""}\nMapUrl :${userData?.mapUrl ?? ""}",
                  subject: "button-three");
              HistoryController controller = Get.put<HistoryController>(HistoryController());
              controller.histories.clear();
              controller.fetchHistories();
            });
            Get.back();
            Get.until((route) {
              return !(Get.isDialogOpen!);
            });
            EasyLoading.dismiss();
            Snackbars.successSnackBar('Smart Ghar', 'Your details has been sent');
          } else if (response.statusCode == 403) {
            var data = jsonDecode(response.body);
            EasyLoading.showError(data['error']);
          } else {
            EasyLoading.dismiss();
            EasyLoading.showError(data['message']);
            print("ERROR : ${response.body}");
          }
        } catch (e) {
          print("error : $e");
          print(groceryRequestModel.toJson());
          EasyLoading.dismiss();
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
          'template_params': {'user_name': name, 'from_name': name, 'mail': "izmirinvoseg@gmail.com", 'user_subject': subject, 'to_email': "daniyalhumayun7@gmail.com", 'user_message': message},
        }),
        headers: {'origin': "http://localhost", 'Content-Type': 'application/json'});

    print(response.body);
  }
}
