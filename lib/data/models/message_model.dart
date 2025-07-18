import 'package:hive/hive.dart';
part 'message_model.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final String senderId;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  bool isSynced;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.timestamp,
    this.isSynced = false,
  });

  factory Message.fromJson(Map<String, dynamic> j) => Message(
    id: j['id'],
    content: j['content'],
    senderId: j['senderId'],
    timestamp: DateTime.parse(j['timestamp']),
    isSynced: true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'senderId': senderId,
    'timestamp': timestamp.toIso8601String(),
  };
}
