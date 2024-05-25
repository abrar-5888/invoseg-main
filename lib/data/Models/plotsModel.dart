import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: file_names

class PlotsModel {
  final String address;
  final String area;
  final String bath;
  final String price;
  final String category;
  final String paymentType;
  final String name;
  final String title;
  final String id;
  final String room;
  final String description;
  final String phone;
  final String societyName;
  final String time;
  final String date;
  final String type;
  final int timestamp;
  final List<dynamic> mediaUrls;

  PlotsModel({
    required this.price,
    required this.paymentType,
    required this.address,
    required this.area,
    required this.bath,
    required this.category,
    required this.name,
    required this.title,
    required this.id,
    required this.room,
    required this.description,
    required this.phone,
    required this.societyName,
    required this.time,
    required this.date,
    required this.type,
    required this.timestamp,
    required this.mediaUrls,
  });

  factory PlotsModel.fromJson(Map<String, dynamic> data) {
    return PlotsModel(
      address: data['address'] ?? "",
      area: data['area'] ?? "",
      bath: data['bath'] ?? "",
      category: data['category'] ?? "",
      name: data['name'] ?? "",
      title: data['title'] ?? "",
      id: data['id'] ?? "",
      room: data['room'] ?? "",
      description: data['description'] ?? "",
      phone: data['phone'] ?? "",
      societyName: data['societyName'] ?? "",
      time: data['time'] ?? "",
      date: data['date'] ?? "",
      type: data['type'] ?? "",
      timestamp: (data['timestamp'] as Timestamp).millisecondsSinceEpoch,
      mediaUrls: List<dynamic>.from(data['mediaUrls'] ?? []),
      paymentType: data['category'],
      price: data['price'],
    );
  }
}
