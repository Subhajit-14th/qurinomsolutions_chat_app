import 'package:qurinomsolutions/models/ChatModel/chat_model.dart';
import 'package:qurinomsolutions/models/ChatModel/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<ChatModel> chats;

  ChatsLoaded(this.chats);
}

class MessagesLoaded extends ChatState {
  final List<MessageModel> messages;

  MessagesLoaded(this.messages);
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);
}
