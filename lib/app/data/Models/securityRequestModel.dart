class SecurityRequestModel {
  final String fcmToken;
  final String address;
  final String age;
  final bool count;
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
      'securityComplain': securityComplain,
      'securityStatus': securityStatus,
      'societyName': societyName,
      'response': response,
      'userId': userId,
      'buttonType':buttonType,
    };
  }

  factory SecurityRequestModel.fromJson(Map<String, dynamic> json) {
    return SecurityRequestModel(
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
      userId: json['userId'] ?? '',
      edit: json['edit'],
      buttonType: json['type'],
    );
  }
}
