class NotHomeModel {
  final String fcmToken;
  final String address;
  final String age;
  final String email;
  final String designation;
  final String name;
  final String fmName;
  final String fmName1;
  final String fmPhoneNo;
  final String fmPhoneNo1;
  final String phoneNo;
  final String fPhoneNo;

  final String fname;
  final String from;
  final String to;
  final int time;
  final bool nh;
  final bool noti;
  final int pressedTime;
  final String owner;
  final String societyName;
  final bool status;
  final bool cancelled;
  final bool edit;
  final int days;
  final String uid;

  NotHomeModel({
    required this.fcmToken,
    required this.address,
    required this.age,
    required this.email,
    required this.designation,
    required this.name,
    required this.fmName,
    required this.fmName1,
    required this.fmPhoneNo,
    required this.fmPhoneNo1,
    required this.phoneNo,
    required this.fPhoneNo,
    required this.fname,
    required this.from,
    required this.to,
    required this.time,
    required this.nh,
    required this.noti,
    required this.pressedTime,
    required this.owner,
    required this.societyName,
    required this.status,
    required this.cancelled,
    required this.edit,
    required this.days,
    required this.uid,
  });

  factory NotHomeModel.fromJson(Map<String, dynamic> json) {
    return NotHomeModel(
      fcmToken: json['FCMtoken'],
      address: json['Address'],
      age: json['Age'],
      email: json['Email'],
      designation: json['Designation'],
      name: json['Name'],
      fmName: json['fmName'],
      fmName1: json['fmName1'],
      fmPhoneNo: json['fmphoneNo'],
      fmPhoneNo1: json['fmphoneNo1'],
      phoneNo: json['PhoneNo'],
      fPhoneNo: json['fPhoneNo'],
      fname: json['fname'],
      from: json['from'],
      to: json['to'],
      time: json['time'],
      nh: json['nh'],
      noti: json['noti'],
      pressedTime: json['pressedTime'],
      owner: json['Owner'],
      societyName: json['societyName'],
      status: json['Status'],
      cancelled: json['cancelled'],
      edit: json['edit'],
      days: json['days'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FCMtoken': fcmToken,
      'Address': address,
      'Age': age,
      'Email': email,
      'Designation': designation,
      'Name': name,
      'fmName': fmName,
      'fmName1': fmName1,
      'fmphoneNo': fmPhoneNo,
      'fmphoneNo1': fmPhoneNo1,
      'PhoneNo': phoneNo,
      'fPhoneNo': fPhoneNo,
      'fname': fname,
      'from': from,
      'to': to,
      'time': time,
      'nh': nh,
      'noti': noti,
      'pressedTime': pressedTime,
      'Owner': owner,
      'societyName': societyName,
      'Status': status,
      'cancelled': cancelled,
      'edit': edit,
      'days': days,
      'uid': uid,
    };
  }
}
