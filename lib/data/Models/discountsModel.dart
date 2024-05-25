// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountsModel {
  final String date;
  final String address;
  final String discount;
  final String description;
  final String societyName;
  final String title;
  final String name;
  final Map<String, dynamic> logo;
  final List<String> mediaUrls;
  final String category;
  final String time;
  final Timestamp timestamp;

  DiscountsModel({
    required this.date,
    required this.address,
    required this.discount,
    required this.description,
    required this.societyName,
    required this.title,
    required this.name,
    required this.logo,
    required this.mediaUrls,
    required this.category,
    required this.time,
    required this.timestamp,
  });

  factory DiscountsModel.fromJson(Map<String, dynamic> data) {
    return DiscountsModel(
      date: data['date'],
      address: data['address'],
      discount: data['discount'],
      description: data['description'],
      societyName: data['societyName'],
      title: data['title'],
      name: data['Name'],
      logo: data['logo'],
      mediaUrls: List<String>.from(data['mediaUrls']),
      category: data['category'],
      time: data['time'],
      timestamp: data['timestamp'],
    );
  }
}
