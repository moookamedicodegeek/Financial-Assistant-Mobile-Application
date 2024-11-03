class NotificationModel {
  final String id;
  final String message;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.message,
    required this.date,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      message: data['message'],
      date: DateTime.parse(data['date']),
    );
  }
}
