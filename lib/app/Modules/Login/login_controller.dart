import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.invoseg.innovation/app/Modules/Main/main_view.dart';
import 'package:com.invoseg.innovation/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';
import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
// ignore_for_file: avoid_print

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var emailOrPhone = TextEditingController().obs;
  var pass = TextEditingController().obs;
  UsersModel? user;
  List<FamilyMembersModel> fm = <FamilyMembersModel>[].obs;
  FamilyMembersModel? familyMemberUser;
  String mainCollectionId = '';
  String phoneEmail = '';
  String phoneSubCollectionId = '';
  RxBool showPass = true.obs;

  bool checkForm() {
    if (emailOrPhone.value.text.isEmpty || pass.value.text.isEmpty) {
      Snackbars.errorSnackBar('Login', 'Please fill all fields');
      return false;
    }
    if (pass.value.text.length < 6) {
      Snackbars.errorSnackBar('Login', 'Password must contain 6 digits');
      return false;
    }
    return true;
  }

  Future<bool> checkEmailInMainCollection(String email) async {
    var checkQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).where('email', isEqualTo: email).get();
    if (checkQuery.docs.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<bool> checkEmailInSubCollections(String email) async {
    var checkQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).get();
    for (var queryData in checkQuery.docs) {
      var checkSubCollectionQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).doc(queryData.id).collection(FirebaseNodes.FAMILY_MEMBERS).where('email', isEqualTo: email).get();

      if (checkSubCollectionQuery.docs.isNotEmpty) {
        mainCollectionId = queryData.id;
        return true;
      }
    }

    return false;
  }

  Future<bool> checkPhoneInSubCollection() async {
    var checkQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).get();
    for (var queryData in checkQuery.docs) {
      var checkSubCollectionQuery =
          await firestore.collection(FirebaseNodes.USER_REQUEST).doc(queryData.id).collection(FirebaseNodes.FAMILY_MEMBERS).where('phonenumber', isEqualTo: emailOrPhone.value.text).get();
      if (checkSubCollectionQuery.docs.isNotEmpty) {
        mainCollectionId = queryData.id;
        phoneSubCollectionId = checkSubCollectionQuery.docs.first.id;
        return true;
      }
    }
    return false;
  }

  void login() async {
    EasyLoading.dismiss();

    SharedPreferences userInfo = await SharedPreferences.getInstance();
    try {
      if (emailOrPhone.value.text.endsWith('@gmail.com')) {
        if (await checkEmailInMainCollection(emailOrPhone.value.text)) {
          await signInWithEmailMainCollection(userInfo, emailOrPhone.value.text);
        } else if (await checkEmailInSubCollections(emailOrPhone.value.text)) {
          await sigInWithEmailFamilyMember(userInfo, emailOrPhone.value.text);
        } else {
          EasyLoading.dismiss();
          Snackbars.errorSnackBar('Login', 'your Email is incorrect');
        }
      } else {
        var fetchEmailQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).where('phone', isEqualTo: emailOrPhone.value.text).get();

        if (fetchEmailQuery.docs.isNotEmpty) {
          phoneEmail = fetchEmailQuery.docs.first['email'];

          if (await checkEmailInMainCollection(phoneEmail)) {
            await signInWithEmailMainCollection(userInfo, phoneEmail);
          } else {
            EasyLoading.dismiss();
            Snackbars.errorSnackBar('Login', 'your Phone is incorrect');
          }
        } else {
          if (await checkPhoneInSubCollection()) {
            var query = await firestore.collection(FirebaseNodes.USER_REQUEST).doc(mainCollectionId).collection(FirebaseNodes.FAMILY_MEMBERS).doc(phoneSubCollectionId).get();
            if (query.data()!.isNotEmpty) {
              var data = query.data() as Map<String, dynamic>;
              phoneEmail = data['email'];
              sigInWithEmailFamilyMember(userInfo, phoneEmail);
            } else {
              EasyLoading.dismiss();
              Snackbars.errorSnackBar('Login', 'your Phone is incorrect');
            }
          } else {
            EasyLoading.dismiss();
            Snackbars.errorSnackBar('Login', 'your Phone is incorrect');
          }
        }
      }
    } catch (e) {
      if (e.toString().contains('credential is incorrect')) {
        Snackbars.errorSnackBar('Login', 'credentials are incorrect');
      }
    }
  }

  Future<void> sigInWithEmailFamilyMember(SharedPreferences userInfo, String email) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass.value.text);

      var dataQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).doc(mainCollectionId).collection(FirebaseNodes.FAMILY_MEMBERS).doc(auth.currentUser!.uid).get();

      familyMemberUser = FamilyMembersModel.fromJson(dataQuery.data()!);

      if (familyMemberUser!.status == 'Approve') {
        String jsonString = json.encode(familyMemberUser!.toJson());

        await userInfo.setString('userInfo', jsonString);

        Snackbars.successSnackBar('Login', 'Login Successfully');
        name = familyMemberUser!.name;
        phone = familyMemberUser!.phonenumber;
        societyName = familyMemberUser!.societyName;
        emailOrPhone.value.clear();
        pass.value.clear();

        Get.off(() => const MainPage(
              index: 0,
            ));
      } else {
        Snackbars.errorSnackBar('Login', 'Sorry! Your Account is blocked.');
      }
    } catch (e) {
      if (e.toString().contains('credential is incorrect')) {
        Snackbars.errorSnackBar('Login', 'credentials are incorrect');
      }
    }
  }

  Future<void> signInWithEmailMainCollection(SharedPreferences userInfo, String email) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass.value.text);

      var dataQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).doc(auth.currentUser!.uid).get();

      var data = dataQuery.data() as Map<String, dynamic>;
      var fmDataQuery = await firestore.collection(FirebaseNodes.USER_REQUEST).doc(dataQuery.id).collection(FirebaseNodes.FAMILY_MEMBERS).get();
      if (fmDataQuery.docs.isNotEmpty) {
        for (var i in fmDataQuery.docs) {
          fm.add(FamilyMembersModel.fromJson(i.data()));
        }
        String fmJsonString = json.encode(fm);
        await userInfo.setString('fmUserInfo', fmJsonString);
      }
      user = UsersModel.fromJson(data);

      if (user!.status == 'Approve') {
        String jsonString = json.encode(user!.toMap());

        await userInfo.setString('userInfo', jsonString);

        Snackbars.successSnackBar('Login', 'Login Successfully');
        name = user!.name;
        phone = user!.phone;
        societyName = user!.societyName;
        emailOrPhone.value.clear();
        pass.value.clear();
        Get.off(() => const MainPage(
              index: 0,
            ));

        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        Snackbars.errorSnackBar('Login', 'Sorry! Your Account is blocked.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (e.toString().contains('credential is incorrect')) {
        Snackbars.errorSnackBar('Login', 'credentials are incorrect');
      }
    }
  }
}
