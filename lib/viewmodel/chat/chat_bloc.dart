import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinomsolutions/models/ChatModel/message_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../../services/api_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ApiService api;

  ChatBloc(this.api) : super(ChatInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final chats = await api.fetchChats(event.userId);
        emit(ChatsLoaded(chats));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        final messages = await api.getMessages(event.chatId);
        emit(MessagesLoaded(messages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await api.sendMessage(
          chatId: event.chatId,
          senderId: event.senderId,
          content: event.content,
        );
        add(LoadMessages(event.chatId)); // reload messages
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<RecentMessageLocally>((event, emit) {
      if (state is MessagesLoaded) {
        final currentMessages =
            List<MessageModel>.from((state as MessagesLoaded).messages);
        currentMessages.add(event.message);
        emit(MessagesLoaded(currentMessages));
      }
    });
  }
}
