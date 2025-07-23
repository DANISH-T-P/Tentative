import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat - ${controller.username}')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              reverse: true,
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages.reversed.toList()[index];
                final isMine = message.sender == controller.username;
                return Align(
                  alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMine ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.content,
                          style: TextStyle(color: isMine ? Colors.white : Colors.black),
                        ),
                        Text(
                          message.timestamp.toLocal().toIso8601String().substring(11, 16),
                          style: TextStyle(
                            fontSize: 10,
                            color: isMine ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
          Obx(() {
            final othersTyping = controller.typingUsers.where((u) => u != controller.username).toList();
            if (othersTyping.isEmpty) return SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                "${othersTyping.join(', ')} is typing...",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          }),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        controller.startTyping();
                      } else {
                        controller.stopTyping();
                      }
                    },
                    onEditingComplete: controller.stopTyping,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: controller.sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
