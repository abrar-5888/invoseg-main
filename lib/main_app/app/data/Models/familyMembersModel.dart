// ignore_for_file: file_names

class FamilyMembersModel {
  final String name;
  final String address;
  final String email;
  final String owner;
  final String phonenumber;
  final String ownermail;
  final String parentID;
  final String societyName;
  final String password;
  final int remaining;
  final String residentID;
  final String status;
  final String uid;

  FamilyMembersModel({
    required this.societyName,
    required this.phonenumber,
    required this.name,
    required this.address,
    required this.email,
    required this.owner,
    required this.ownermail,
    required this.parentID,
    required this.password,
    required this.remaining,
    required this.residentID,
    required this.status,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'address': address,
      'email': email,
      'Phoneno': phonenumber,
      'owner': owner,
      'ownermail': ownermail,
      'parentID': parentID,
      'password': password,
      'remaining': remaining,
      'residentID': residentID,
      'status': status,
      'societyName': societyName,
      'uid': uid,
    };
  }

  factory FamilyMembersModel.fromJson(Map<String, dynamic> data) {
    return FamilyMembersModel(
      name: data['Name'] ?? '',
      phonenumber: data['Phoneno'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      owner: data['owner'] ?? '',
      ownermail: data['ownermail'] ?? '',
      parentID: data['parentID'] ?? '',
      password: data['password'] ?? '',
      remaining: data['remaining'] ?? 0,
      residentID: data['residentID'] ?? '',
      status: data['status'] ?? '',
      uid: data['uid'] ?? '',
      societyName: data['societyName'],
    );
  }
}
