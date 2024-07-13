// ignore_for_file: file_names

class UsersModel {
  final String id;
  final String name;
  final int totalFamilyMembers;
  final String address;
  final String fatherName;
  final String fatherPhoneNumber;
  final String owner;
  final String password;
  final String phoneNumber;
  final String designation;
  final String age;
  final String email;
  final String residentID;
  final String societyName;
  final String status;
  final String familyID;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final String mapUrl;

  UsersModel({
    required this.designation,
    required this.age,
    required this.id,
    required this.mapUrl,
    required this.name,
    required this.email,
    required this.totalFamilyMembers,
    required this.address,
    required this.fatherName,
    required this.fatherPhoneNumber,
    required this.owner,
    required this.password,
    required this.phoneNumber,
    required this.residentID,
    required this.societyName,
    required this.status,
    required this.familyID,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'TFM': totalFamilyMembers,
      'email': email,
      'address': address,
      'fName': fatherName,
      'mapUrl': mapUrl,
      'fPhoneNo': fatherPhoneNumber,
      'owner': owner,
      'password': password,
      'phonenumber': phoneNumber,
      'residentId': residentID,
      'societyName': societyName,
      'status': status,
      'familyID': familyID,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'designation': designation,
      'age': age,
      '_id': id,
      'mapUrl': mapUrl,
      'name': name,
      'TFM': totalFamilyMembers,
      'address': address,
      'fName': fatherName,
      'fPhoneNo': fatherPhoneNumber,
      'owner': owner,
      'password': password,
      'email': email,
      'phonenumber': phoneNumber,
      'residentId': residentID,
      'societyName': societyName,
      'status': status,
      'familyID': familyID,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': version,
    };
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      designation: json['designation'] ?? '',
      age: json['age'] ?? '',
      email: json['email'] ?? "",
      id: json['_id'] ?? '',
      mapUrl: json['mapUrl'] ?? "",
      name: json['name'] ?? '',
      totalFamilyMembers: json['TFM'] ?? 0,
      address: json['address'] ?? '',
      fatherName: json['fName'] ?? '',
      fatherPhoneNumber: json['fPhoneNo'].toString(),
      owner: json['owner'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phonenumber'].toString(),
      residentID: json['residentId'].toString(),
      societyName: json['societyName'] ?? '',
      status: json['status'] ?? '',
      familyID: json['familyID'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'] ?? 0,
    );
  }
}
