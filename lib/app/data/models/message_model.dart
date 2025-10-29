// Model untuk data pesan
class Message {
  final String id;
  final String text;
  final String senderId; // 'user' atau 'admin'
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
  });
}
