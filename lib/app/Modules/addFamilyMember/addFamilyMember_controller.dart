import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.invoseg.innovation/data/Models/familyMembersModel.dart';
import 'package:com.invoseg.innovation/data/Models/usersModel.dart';
import 'package:com.invoseg.innovation/data/api/firebaseNodes.dart';
import 'package:com.invoseg.innovation/utils/Snackbars/snackbar.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
// ignore_for_file: file_names

class AddFamilyMemberController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var sPassword = TextEditingController();
  var cPassword = TextEditingController();
  RxInt remaining = 10.obs;
  SharedPreferences? userInfo;
  String? jsonStringUser;
  String? jsonStringFM;
  UsersModel? userData;
  List<FamilyMembersModel> fm = <FamilyMembersModel>[].obs;
  FamilyMembersModel? familyMember;

  @override
  void onInit() {
    super.onInit();
    initializeSharedPreferences();
    fetchRemainingLength();
  }

  Future<void> initializeSharedPreferences() async {
    userInfo = await SharedPreferences.getInstance();
    jsonStringUser = userInfo!.getString('userInfo');

    var userdata = jsonDecode(jsonStringUser!);
    if (!userdata.toString().contains('ownermail')) {
      userData = UsersModel.fromJson(userdata);
    }
  }

  bool checkForm() {
    if (nameController.text.isEmpty || emailController.text.isEmpty || phoneController.text.isEmpty || cPassword.text.isEmpty || sPassword.text.isEmpty) {
      Snackbars.errorSnackBar('Family Member', 'Please fill all fields');
      return false;
    }
    if (sPassword.text.length < 6) {
      Snackbars.errorSnackBar('Family Member', 'Password must contain 6 digits');
      return false;
    }
    if (!emailController.text.endsWith('@gmail.com')) {
      Snackbars.errorSnackBar('Family Member', 'Email is not correct.');
      return false;
    }
    if (cPassword.text != sPassword.text) {
      Snackbars.errorSnackBar('Family Member', 'Password does\'nt match');
      return false;
    }
    if (phoneController.text.length > 11 || phoneController.text.length < 11) {
      Snackbars.errorSnackBar('Family Member', 'Phone number is not correct');
      return false;
    }
    return true;
  }

  void fetchRemainingLength() async {
    FirebaseFirestore.instance.collection(FirebaseNodes.USER_REQUEST).doc(FirebaseAuth.instance.currentUser!.uid).collection(FirebaseNodes.FAMILY_MEMBERS).snapshots().listen((event) {
      remaining.value = 10 - event.docs.length;
      for (var i in event.docs) {
        fm.add(FamilyMembersModel.fromJson(i.data()));
      }
      String fmJsonString = json.encode(fm);
      userInfo!.setString('fmUserInfo', fmJsonString);
    });
  }

  Future<void> addFM() async {
    if (remaining <= 10) {
      var collectionRef = FirebaseFirestore.instance.collection(FirebaseNodes.USER_REQUEST).doc(userData!.uid).collection(FirebaseNodes.FAMILY_MEMBERS);

      remaining.value = remaining.value - 1;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: sPassword.text).then((value) => {
            familyMember = FamilyMembersModel(
                phonenumber: phoneController.text,
                name: nameController.text,
                address: userData!.address,
                email: emailController.text,
                owner: userData!.name,
                ownermail: userData!.email,
                parentID: userData!.uid,
                password: sPassword.text,
                remaining: remaining.value,
                residentID: '',
                societyName: societyName,
                status: 'Approve',
                uid: value.user!.uid),
            collectionRef.doc(value.user!.uid).set(familyMember!.toJson()).then((value) => {
                  nameController.clear(),
                  emailController.clear(),
                  phoneController.clear(),
                  sPassword.clear(),
                  cPassword.clear(),
                })
          });
    } else {
      Snackbars.errorSnackBar('Family member', 'you have reached your limit ');
    }
  }
}
