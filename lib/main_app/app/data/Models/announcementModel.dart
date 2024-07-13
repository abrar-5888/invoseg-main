// ignore_for_file: file_names

class AnnouncementModel {
  final String id;
  final String date;
  final String description;
  final String imgUrl;
  final String pressedTime;
  final List<String> seenUids;
  final String societyName;
  final String time;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  AnnouncementModel({
    required this.id,
    required this.date,
    required this.description,
    required this.imgUrl,
    required this.pressedTime,
    required this.seenUids,
    required this.societyName,
    required this.time,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    var seenUidsFromJson = json['seenUids'] as List;
    List<String> seenUidsList = seenUidsFromJson.map((uid) => uid.toString()).toList();

    return AnnouncementModel(
      id: json['_id'],
      date: json['date'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      pressedTime: json['pressedTime'],
      seenUids: seenUidsList,
      societyName: json['societyName'],
      time: json['time'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
      'description': description,
      'imgUrl': imgUrl,
      'pressedTime': pressedTime,
      'seenUids': seenUids,
      'societyName': societyName,
      'time': time,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
