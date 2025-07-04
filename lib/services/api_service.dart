import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qurinomsolutions/models/LoginModel/login_response.dart';
import '../models/ChatModel/chat_model.dart';
import '../models/ChatModel/message_model.dart';

class ApiService {
  static const String baseUrl = 'http://45.129.87.38:6065';

  // for login the user
  Future<LoginResponse> login(
      String email, String password, String role) async {
    debugPrint("Login Step One");
    final res = await http.post(
      Uri.parse('$baseUrl/user/login'),
      body: {'email': email, 'password': password, 'role': role},
    );

    debugPrint("Login Step two");

    if (res.statusCode == 200) {
      debugPrint("Login Step three");
      debugPrint("Login response data is: ${json.decode(res.body)}");
      return LoginResponse.fromJson(jsonDecode(res.body));
    } else {
      debugPrint("Login Step four");
      throw Exception('Failed to login');
    }
  }

  // for fetch the chats
  Future<List<ChatModel>> fetchChats(String userId) async {
    debugPrint("Checking User id for fetch chat: $userId");
    debugPrint("Fetch the chts step One");
    final res = await http.get(Uri.parse('$baseUrl/chats/user-chats/$userId'));
    debugPrint("Fetch the chts step Two");
    if (res.statusCode == 200) {
      debugPrint("Fetch the chts step Three");
      debugPrint("Fetch the chts data: ${json.decode(res.body)}");
      final list = json.decode(res.body) as List;
      return list.map((e) => ChatModel.fromJson(e)).toList();
    } else {
      debugPrint("Fetch the chts Error triggred");
      throw Exception('Failed to fetch chats');
    }
  }

  /// for the chat messages
  Future<List<MessageModel>> getMessages(String chatId) async {
    final res = await http
        .get(Uri.parse('$baseUrl/messages/get-messagesformobile/$chatId'));

    if (res.statusCode == 200) {
      final list = json.decode(res.body) as List;
      return list.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch messages');
    }
  }

  // for sending the messages
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/messages/sendMessage'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'chatId': chatId,
        'senderId': senderId,
        'content': content,
        'messageType': 'text',
        'fileUrl': ''
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }
}
