class Message {
  final int id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      text: json['message_text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message_text': text,
    };
  }
}
