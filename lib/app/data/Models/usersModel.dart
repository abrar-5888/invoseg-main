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
  final String residentID;
  final String societyName;
  final String status;
  final String familyID;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  UsersModel({
    required this.designation,
    required this.age,
    required this.id,
    required this.name,
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
      'address': address,
      'fName': fatherName,
      'fPhoneNumber': fatherPhoneNumber,
      'owner': owner,
      'password': password,
      'phonenumber': phoneNumber,
      'residentID': residentID,
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
      'name': name,
      'TFM': totalFamilyMembers,
      'address': address,
      'fName': fatherName,
      'fPhoneNumber': fatherPhoneNumber,
      'owner': owner,
      'password': password,
      'phonenumber': phoneNumber,
      'residentID': residentID,
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
      id: json['_id'] ?? '',
      name: json['Name'] ?? '',
      totalFamilyMembers: json['TFM'] ?? 0,
      address: json['address'] ?? '',
      fatherName: json['fName'] ?? '',
      fatherPhoneNumber: json['fPhoneNumber'].toString(),
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
