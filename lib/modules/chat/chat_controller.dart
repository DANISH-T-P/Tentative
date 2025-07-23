import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/message_model.dart';
import '../../services/socket_service.dart';
import '../login/user_controller.dart';

class ChatController extends GetxController {
  final messages = <Message>[].obs;
  final typingUsers = <String>{}.obs;
  final messageController = TextEditingController();
  late String username;
  late SocketService socketService;

  @override
  void onInit() {
    super.onInit();

    username = Get.arguments?['username'] ??
        Get.find<UserController>().username.value;

    socketService = Get.find<SocketService>();
    listenForMessages();
    listenTyping();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final msg = Message(
      sender: username,
      content: text,
      timestamp: DateTime.now(),
    );

    messages.add(msg);
    socketService.sendChatMessage(msg);
    messageController.clear();
  }

  void listenForMessages() {
    socketService.onChatReceived((data) {
      final msg = Message.fromJson(data);
      if (msg.sender != username) {
        messages.add(msg);
      }
    });
  }

  void startTyping() {
    socketService.sendTyping(username);
  }

  void stopTyping() {
    socketService.sendStopTyping(username);
  }

  void listenTyping() {
    socketService.onTyping((name) {
      typingUsers.add(name);
    });

    socketService.onStopTyping((name) {
      typingUsers.remove(name);
    });
  }

  void listenToUserPresence() {
    socketService.onUserJoined((id) {
      Get.snackbar('User Joined', '$id joined the app');
    });
    socketService.onUserLeft((id) {
      Get.snackbar('User Left', '$id left the app');
    });
  }

  void listenForBroadcast() {
    socketService.onBroadcast((msg) {
      Get.snackbar('Admin Message', msg);
    });
  }


  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
