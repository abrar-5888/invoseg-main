// history.dart

class HistoryModel {
  final String id;
  final String type;
  final String uid;
  final int createdAt;
  final DateTime updatedAt;
  final int version;

  HistoryModel({
    required this.id,
    required this.type,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  // Factory method to create a History instance from a JSON map
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['_id'] as String,
      type: json['type'] as String,
      uid: json['uid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).millisecondsSinceEpoch,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      version: json['__v'] as int,
    );
  }
}
