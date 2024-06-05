class ComplainModel {
  final String id;
  final String complain;
  final String complainStatus;
  final String response;

  ComplainModel({
    required this.response,
    required this.id,
    required this.complain,
    required this.complainStatus,
  });

  factory ComplainModel.fromJson(Map<String, dynamic> json) {
    return ComplainModel(
      id: json['_id'],
      complain: json['complain'],
      complainStatus: json['complainStatus'],
      response: json['response'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'complain': complain,
      'complainStatus': complainStatus,
      'response': response,
    };
  }
}
