import 'package:qurinomsolutions/models/LoginModel/user_model.dart';
import 'message_model.dart';

class ChatModel {
  final String id;
  final bool isGroupChat;
  final List<UserModel> participants;
  final MessageModel? lastMessage;

  ChatModel({
    required this.id,
    required this.isGroupChat,
    required this.participants,
    this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      isGroupChat: json['isGroupChat'] ?? false,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e))
              .toList() ??
          [],
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
    );
  }
}
