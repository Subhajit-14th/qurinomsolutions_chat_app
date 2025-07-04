import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinomsolutions/services/socket_service.dart';
import 'package:qurinomsolutions/utils/app_color.dart';

import '../models/LoginModel/user_model.dart';
import '../models/ChatModel/message_model.dart';
import '../viewmodel/chat/chat_bloc.dart';
import '../viewmodel/chat/chat_event.dart';
import '../viewmodel/chat/chat_state.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final UserModel user;
  final String senderName;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.user,
    required this.senderName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final SocketService _socketService =
      SocketService(); // use singleton properly

  @override
  void initState() {
    super.initState();

    // Initial load of messages
    context.read<ChatBloc>().add(LoadMessages(widget.chatId));

    // Connect socket once
    if (_socketService.socket == null || !_socketService.socket!.connected) {
      _socketService.connect(widget.user.id);
    }

    // Listen for real-time messages
    SocketService().listenMessages((data) {
      if (data['chatId'] == widget.chatId) {
        context.read<ChatBloc>().add(LoadMessages(widget.chatId));
      }
    });
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      final message = {
        'chatId': widget.chatId,
        'senderId': widget.user.id,
        'content': content,
        'messageType': 'text',
        'fileUrl': '',
      };

      // Send message via socket
      _socketService.sendMessage(message);

      final localMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // temporary ID
        senderId: widget.user.id,
        content: content,
        messageType: "text",
        fileUrl: "",
        createdAt: DateTime.now(),
      );

      context.read<ChatBloc>().add(RecentMessageLocally(localMessage));

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.screenBodyColor,
        appBar: AppBar(
          backgroundColor: AppColor.componantColor1DPElevation,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppColor.appTextColor,
            ),
          ),
          title: Text(
            widget.senderName,
            style: TextStyle(
              color: AppColor.appTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColor.appTextColor,
                      backgroundColor: AppColor.screenBodyColor,
                    ));
                  } else if (state is MessagesLoaded) {
                    final List<MessageModel> messages = state.messages;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (_, index) {
                        final message = messages[messages.length - 1 - index];
                        final isMe = message.senderId == widget.user.id;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 10,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? AppColor.componantColor1DPElevation
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message.content,
                              style: TextStyle(
                                  color: isMe
                                      ? Colors.grey[300]
                                      : AppColor.componantColor1DPElevation,
                                  fontSize: 16),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text("Error: ${state.error}"));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            // const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.componantColor1DPElevation,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(
                          color: AppColor.appTextColor,
                        ),
                        decoration: const InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: TextStyle(
                              color: AppColor.appTextColor,
                            ),
                            border: InputBorder.none,
                            fillColor: AppColor.componantColor1DPElevation,
                            contentPadding: EdgeInsets.only(left: 6)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColor.appTextColor,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
