class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final String messageType;
  final String fileUrl;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.fileUrl,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      senderId: json['senderId'] ?? '',
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
