class GroceryRequestModel {
  final String fcmToken;
  final String address;
  final String age;
  final bool count;
  final String designation;
  final String date;
  final String time;
  final String email;
  final String fatherPhoneNumber;
  final String familyMemberName;
  final String familyMemberName1;
  final String fatherName;
  final String name;
  final bool notification;
  final String owner;
  final String buttonType;
  final String phoneNumber;
  final String residentId;
  final String pressedTime;
  final String pressedTime1;
  final String societyName;
  final String response;
  final bool edit;
  final String fmphoneNo;

  final String fmphoneNo1;
  final String userId;

  GroceryRequestModel({
    required this.date,
    required this.time,
    required this.fmphoneNo,
    required this.fmphoneNo1,
    required this.edit,
    required this.buttonType,
    required this.fcmToken,
    required this.address,
    required this.age,
    required this.count,
    required this.designation,
    required this.email,
    required this.fatherPhoneNumber,
    required this.familyMemberName,
    required this.familyMemberName1,
    required this.fatherName,
    required this.name,
    required this.notification,
    required this.owner,
    required this.phoneNumber,
    required this.residentId,
    required this.pressedTime,
    required this.pressedTime1,
    required this.societyName,
    required this.response,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'FCMtoken': fcmToken,
      'fmphoneNo1': fmphoneNo1,
      'fmphoneNo': fmphoneNo,
      'time': time,
      'date': date,
      'address': address,
      'age': age,
      'count': count,
      'designation': designation,
      'email': email,
      'fPhoneNo': fatherPhoneNumber,
      'fmName': familyMemberName,
      'fmName1': familyMemberName1,
      'fname': fatherName,
      'name': name,
      'noti': notification,
      'owner': owner,
      'phoneNo': phoneNumber,
      'residentId': residentId,
      'pressedTime': pressedTime,
      'pressedTime1': pressedTime1,
      'societyName': societyName,
      'response': response,
      'uid': userId,
      'buttonType': buttonType
    };
  }

  factory GroceryRequestModel.fromJson(Map<String, dynamic> json) {
    return GroceryRequestModel(
      fmphoneNo: json['fmphoneNo'],
      fmphoneNo1: json['fmphoneNo1'],
      fcmToken: json['FCMtoken'] ?? '',
      address: json['address'] ?? '',
      age: json['age'] ?? '',
      count: json['count'] ?? false,
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      fatherPhoneNumber: json['fPhoneNo'] ?? '',
      familyMemberName: json['fmName'] ?? '',
      familyMemberName1: json['fmName1'] ?? '',
      fatherName: json['fname'] ?? '',
      name: json['name'] ?? '',
      notification: json['noti'] ?? false,
      owner: json['owner'] ?? '',
      phoneNumber: json['phoneNo'] ?? '',
      residentId: json['residentId'] ?? '',
      pressedTime: json['pressedTime'] ?? '',
      pressedTime1: json['pressedTime1'] ?? '',
      societyName: json['societyName'] ?? '',
      response: json['response'] ?? '',
      userId: json['uid'] ?? '',
      edit: false,
      buttonType: json['buttonType'],
      date: json['date'],
      time: json['time'],
    );
  }
}
