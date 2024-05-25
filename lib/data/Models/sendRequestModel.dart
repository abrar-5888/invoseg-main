// ignore_for_file: file_names

class SendRequestModel {
  final String fcmToken;
  final String address;
  final String age;
  final String date;
  final String designation;
  final String email;
  final String fatherPhoneNo;
  final String fatherName;
  final String fm1Name;
  final String fm1PhoneNo;
  final String fm2Name;
  final String fm2phoneNo;
  final String name;
  final String phone;
  final bool noti;
  final bool edit;
  final String owner;
  final int timestamp;
  final String residentId;
  final String societyName;
  final String time;
  final String type;
  final String uid;

  SendRequestModel(
      {required this.edit,
      required this.fcmToken,
      required this.address,
      required this.age,
      required this.date,
      required this.designation,
      required this.email,
      required this.fatherPhoneNo,
      required this.fatherName,
      required this.fm1Name,
      required this.fm1PhoneNo,
      required this.fm2Name,
      required this.fm2phoneNo,
      required this.name,
      required this.phone,
      required this.noti,
      required this.owner,
      required this.timestamp,
      required this.residentId,
      required this.societyName,
      required this.time,
      required this.type,
      required this.uid});

  Map<String, dynamic> toJson() {
    return {
      'FCMtoken': fcmToken,
      'edit': edit,
      'address': address,
      'age': age,
      'date': date,
      'designation': designation,
      'email': email,
      'fPhoneNo': fatherPhoneNo,
      'fname': fatherName,
      'fmName': fm1Name,
      'fmphoneNo': fm1PhoneNo,
      'fmName1': fm2Name,
      'fmphoneNo1': fm2phoneNo,
      'name': name,
      'phoneNo': phone,
      'noti': noti,
      'owner': owner,
      'pressedTime': timestamp,
      'residentId': residentId,
      'societyName': societyName,
      'time': time,
      'type': type,
      'uid': uid,
    };
  }
}
