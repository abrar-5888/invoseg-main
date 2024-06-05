class NotificationModel {
  final String description;
  final String image;
  final bool isRead;
  final String title;
  final String uid;
  final String id;
  final String pressedTime;
  final String time;
  final String date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  NotificationModel({
    required this.description,
    required this.image,
    required this.isRead,
    required this.title,
    required this.uid,
    required this.id,
    required this.pressedTime,
    required this.time,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      description: json['description'],
      image: json['image'],
      isRead: json['isRead'],
      title: json['title'],
      uid: json['uid'],
      id: json['_id'],
      pressedTime: json['pressedTime'],
      time: json['time'],
      date: json['date'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'isRead': isRead,
      'title': title,
      'uid': uid,
      '_id': id,
      'pressedTime': pressedTime,
      'time': time,
      'date': date,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
