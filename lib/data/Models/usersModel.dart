// ignore_for_file: file_names

import 'package:com.invoseg.innovation/data/Models/familyMembersModel.dart';

class UsersModel {
  final FamilyMembersModel? famillyMembers;
  final String fcmToken;
  final String name;
  final String societyName;
  final String address;
  final String age;
  final String designation;
  final String phone;
  final String fatherName;
  final String fatherPhoneNo;
  final String owner;
  final String email;
  final String password;
  final String status;
  final String uid;
  final String residentId;
  final int totalFamilyMembers;

  UsersModel({
    required this.societyName,
    required this.famillyMembers,
    required this.fcmToken,
    required this.name,
    required this.address,
    required this.age,
    required this.designation,
    required this.phone,
    required this.fatherName,
    required this.fatherPhoneNo,
    required this.owner,
    required this.email,
    required this.password,
    required this.status,
    required this.uid,
    required this.residentId,
    required this.totalFamilyMembers,
  });

  Map<String, dynamic> toMap() {
    return {
      'FMData': famillyMembers?.toJson(),
      'FCMtoken': fcmToken,
      'Name': name,
      'address': address,
      'age': age,
      'designation': designation,
      'phonenumber': phone,
      'fName': fatherName,
      'societyName': societyName,
      'fPhonenumber': fatherPhoneNo,
      'owner': owner,
      'email': email,
      'password': password,
      'status': status,
      'uid': uid,
      'residentID': residentId,
      'TFM': totalFamilyMembers,
    };
  }

  factory UsersModel.fromJson(Map<String, dynamic> data) {
    return UsersModel(
      famillyMembers: data['FMData'] != null ? FamilyMembersModel.fromJson(data['FMData']) : null,
      fcmToken: data['FCMtoken'] ?? '',
      name: data['Name'] ?? '',
      address: data['address'] ?? '',
      age: data['age'] ?? '',
      designation: data['designation'] ?? '',
      phone: data['phonenumber'] ?? '',
      fatherName: data['fName'] ?? '',
      fatherPhoneNo: data['fPhonenumber'] ?? '',
      owner: data['owner'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      status: data['status'] ?? '',
      uid: data['uid'] ?? '',
      residentId: data['residentID'] ?? '',
      totalFamilyMembers: data['TFM'] ?? 0,
      societyName: data['societyName'],
    );
  }
}
