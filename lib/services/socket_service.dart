import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect(String userId) {
    socket = IO.io(
      'http://45.129.87.38:6065',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'userId': userId})
          .build(),
    );

    socket?.onConnect((_) {
      debugPrint('Socket connected');
    });

    socket?.onDisconnect((_) => debugPrint('Socket disconnected'));
    socket?.onConnectError((data) => debugPrint('Connect Error: $data'));
    socket?.onError((data) => debugPrint('Error: $data'));
  }

  void disconnect() {
    socket?.disconnect();
  }

  void sendMessage(Map<String, dynamic> message) {
    debugPrint("sending message: $message");
    if (socket?.connected == true) {
      socket?.emit("sendMessage", message);
      debugPrint("Sending Message via socket.");
    } else {
      debugPrint("Socket is not connected. Message not sent.");
    }
  }

  void listenMessages(Function(Map<String, dynamic>) onMessage) {
    socket?.on("newMessage", (data) {
      debugPrint('New message received: $data');
      onMessage(Map<String, dynamic>.from(data));
    });
  }
}
