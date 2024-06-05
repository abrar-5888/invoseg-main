class ComplainRequestModel {
  final String fcmToken;
  final String address;
  final String age;
  final bool count;
  final bool edit;
  final String designation;
  final String email;
  final String fatherPhoneNumber;
  final String familyMemberName;
  final String familyMemberName1;
  final String fatherName;
  final String name;
  final bool notification;
  final String owner;
  final String phoneNumber;
  final String buttonType;
  final String residentId;
  final String pressedTime;
  final String pressedTime1;
  final String complain;
  final bool complainStatus;
  final String societyName;

  final String response;
  final String userId;

  ComplainRequestModel({
    required this.buttonType,
    required this.fcmToken,
    required this.address,
    required this.edit,
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
    required this.complain,
    required this.complainStatus,
    required this.societyName,
    required this.response,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'buttonType': buttonType,
      'FCMtoken': fcmToken,
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
      'complain': complain,
      'complainStatus': complainStatus,
      'societyName': societyName,
      'response': response,
      'userId': userId,
    };
  }

  factory ComplainRequestModel.fromJson(Map<String, dynamic> json) {
    return ComplainRequestModel(
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
      complain: json['complain'] ?? '',
      complainStatus: json['complainStatus'] ?? false,
      societyName: json['societyName'] ?? '',
      response: json['response'] ?? '',
      userId: json['userId'] ?? '',
      edit: json['edit'],
      buttonType: json['buttonType'],
    );
  }
}
