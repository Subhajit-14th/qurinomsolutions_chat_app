import 'package:qurinomsolutions/models/ChatModel/message_model.dart';

abstract class ChatEvent {}

class LoadChats extends ChatEvent {
  final String userId;

  LoadChats(this.userId);
}

class LoadMessages extends ChatEvent {
  final String chatId;

  LoadMessages(this.chatId);
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String content;

  SendMessageEvent(this.chatId, this.senderId, this.content);
}

class RecentMessageLocally extends ChatEvent {
  final MessageModel message;
  RecentMessageLocally(this.message);
}
