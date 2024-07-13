class SecurityRequestModel {
  final String fcmToken;
  final String address;
  final String age;
  final bool count;
  final String fmphoneNo;
  final String date;
  final String time;
  final String fmphoneNo1;
  final String designation;
  final bool edit;
  final String email;
  final String fatherPhoneNumber;
  final String familyMemberName;
  final String familyMemberName1;
  final String fatherName;
  final String name;
  final bool notification;
  final String owner;
  final String phoneNumber;
  final String residentId;
  final String pressedTime;
  final String buttonType;
  final String pressedTime1;
  final String securityComplain;
  final bool securityStatus;
  final String societyName;
  final String response;
  final String userId;

  SecurityRequestModel({
    required this.date,
    required this.time,
    required this.fmphoneNo,
    required this.fmphoneNo1,
    required this.edit,
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
    required this.buttonType,
    required this.notification,
    required this.owner,
    required this.phoneNumber,
    required this.residentId,
    required this.pressedTime,
    required this.pressedTime1,
    required this.securityComplain,
    required this.securityStatus,
    required this.societyName,
    required this.response,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'date': date,
      'FCMtoken': fcmToken,
      'address': address,
      'age': age,
      'fmphoneNo': fmphoneNo,
      'fmphoneNo1': fmphoneNo1,
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
      'securityComplain': securityComplain,
      'securityStatus': securityStatus,
      'societyName': societyName,
      'response': response,
      'uid': userId,
      'buttonType': buttonType,
    };
  }

  factory SecurityRequestModel.fromJson(Map<String, dynamic> json) {
    return SecurityRequestModel(
      fmphoneNo: json['fmphoneNo'] ?? '',
      fmphoneNo1: json['fmphoneNo1'] ?? '',
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
      securityComplain: json['securityComplain'] ?? '',
      securityStatus: json['securityStatus'] ?? false,
      societyName: json['societyName'] ?? '',
      response: json['response'] ?? '',
      userId: json['uid'] ?? '',
      edit: json['edit'],
      buttonType: json['type'],
      date: json['date'],
      time: json['time'],
    );
  }
}
