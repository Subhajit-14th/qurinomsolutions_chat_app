import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinomsolutions/utils/app_color.dart';

import '../models/LoginModel/user_model.dart';
import '../viewmodel/chat/chat_bloc.dart';
import '../viewmodel/chat/chat_event.dart';
import '../viewmodel/chat/chat_state.dart';
import '../services/api_service.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatelessWidget {
  final UserModel user;

  const ChatListScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    debugPrint("Checking in chat list screen for user id: ${user.id}");
    return BlocProvider(
      create: (_) => ChatBloc(ApiService())..add(LoadChats(user.id)),
      child: Scaffold(
        backgroundColor: AppColor.screenBodyColor,
        appBar: AppBar(
          backgroundColor: AppColor.componantColor1DPElevation,
          toolbarHeight: 80,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello 👋",
                style: TextStyle(
                  color: AppColor.appTextColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                user.name ?? "",
                style: TextStyle(
                  color: AppColor.appTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColor.appTextColor,
                backgroundColor: AppColor.screenBodyColor,
              ));
            } else if (state is ChatsLoaded) {
              if (state.chats.isEmpty) {
                return const Center(child: Text("No chats yet"));
              }

              return ListView.builder(
                itemCount: state.chats.length,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];

                  final otherUser = chat.participants.firstWhere(
                    (u) => u.id != user.id,
                    orElse: () => user,
                  );

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      tileColor: AppColor.componantColor4DPElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: otherUser.profile != null &&
                                otherUser.profile!.isNotEmpty
                            ? NetworkImage(
                                "http://45.129.87.38:6065/${otherUser.profile!}")
                            : const NetworkImage(
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                      ),
                      title: Text(
                        otherUser.name ?? "Unknown",
                        style: TextStyle(
                          color: AppColor.appTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${chat.lastMessage?.content}",
                        style: TextStyle(
                          color: AppColor.appTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetailScreen(
                              chatId: chat.id,
                              user: user,
                              senderName: otherUser.name ?? '',
                            ),
                          ),
                        );

                        /// For show the recent chats
                        if (result == true && context.mounted) {
                          context.read<ChatBloc>().add(LoadChats(user.id));
                        }
                      },
                    ),
                  );
                },
              );
            } else if (state is ChatError) {
              return Center(child: Text("Error: ${state.error}"));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
