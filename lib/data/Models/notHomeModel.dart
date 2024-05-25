// ignore_for_file: non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class NotHomeModel {
  final String Address;
  final String Age;
  final String Designation;
  final String Email;
  final String FCMtoken;
  final String ID;
  final String Name;
  final String Owner;
  final String PhoneNo;
  final bool Status;
  final bool cancelled;
  final int days;
  final bool edit;
  final String fPhoneNo;
  final String fmName;
  final String fmName1;
  final String fmphoneNo;
  final String fmphoneNo1;
  final String fname;
  final String from;
  final bool nh;
  final bool noti;
  final int pressedTime;
  final int time;
  final String to;
  final String uid;
  final String societyName;

  NotHomeModel({
    required this.societyName,
    required this.Address,
    required this.Age,
    required this.Designation,
    required this.Email,
    required this.FCMtoken,
    required this.ID,
    required this.Name,
    required this.Owner,
    required this.PhoneNo,
    required this.Status,
    required this.cancelled,
    required this.days,
    required this.edit,
    required this.fPhoneNo,
    required this.fmName,
    required this.fmName1,
    required this.fmphoneNo,
    required this.fmphoneNo1,
    required this.fname,
    required this.from,
    required this.nh,
    required this.noti,
    required this.pressedTime,
    required this.time,
    required this.to,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'societyName': societyName,
      'Address': Address,
      'Age': Age,
      'Designation': Designation,
      'Email': Email,
      'FCMtoken': FCMtoken,
      'ID': ID,
      'Name': Name,
      'Owner': Owner,
      'PhoneNo': PhoneNo,
      'Status': Status,
      'cancelled': cancelled,
      'days': days,
      'edit': edit,
      'fPhoneNo': fPhoneNo,
      'fmName': fmName,
      'fmName1': fmName1,
      'fmphoneNo': fmphoneNo,
      'fmphoneNo1': fmphoneNo1,
      'fname': fname,
      'from': from,
      'nh': nh,
      'noti': noti,
      'pressedTime': pressedTime,
      'time': time,
      'to': to,
      'uid': uid,
    };
  }

  factory NotHomeModel.fromJson(Map<String, dynamic> json) {
    return NotHomeModel(
      Address: json['Address'] ?? '',
      Age: json['Age'] ?? '',
      Designation: json['Designation'] ?? '',
      Email: json['Email'] ?? '',
      FCMtoken: json['FCMtoken'] ?? '',
      ID: json['ID'] ?? '',
      Name: json['Name'] ?? '',
      Owner: json['Owner'] ?? '',
      PhoneNo: json['PhoneNo'] ?? '',
      Status: json['Status'] ?? false,
      cancelled: json['cancelled'] ?? false,
      days: json['days'] ?? 0,
      edit: json['edit'] ?? false,
      fPhoneNo: json['fPhoneNo'] ?? '',
      fmName: json['fmName'] ?? '',
      fmName1: json['fmName1'] ?? '',
      fmphoneNo: json['fmphoneNo'] ?? '',
      fmphoneNo1: json['fmphoneNo1'] ?? '',
      fname: json['fname'] ?? '',
      from: json['from'] ?? '',
      nh: json['nh'] ?? false,
      noti: json['noti'] ?? false,
      pressedTime: (json['pressedTime'] as Timestamp).millisecondsSinceEpoch,
      time: (json['time'] as Timestamp).millisecondsSinceEpoch,
      to: json['to'] ?? '',
      uid: json['uid'] ?? '',
      societyName: json['societyName'],
    );
  }
}
