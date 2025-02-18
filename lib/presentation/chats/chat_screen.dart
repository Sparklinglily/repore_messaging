// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:promptio/core/constants/message_bubble.dart';
import 'package:promptio/data/message_model.dart';
import 'package:promptio/presentation/providers/auth_provider.dart';
import 'package:promptio/presentation/providers/chats_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;

  const ChatScreen({Key? key, required this.groupId}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setCurrentGroup(widget.groupId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatProvider.markMessagesAsDelivered(chatProvider.messages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final messages = context.watch<ChatProvider>().messages;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Leaked Drainage'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isCurrentUser = message.senderId == user.id;

                return MessageBubble(
                    message: message,
                    isCurrentUser: isCurrentUser,
                    onResend: () {
                      if (message.status == MessageStatus.resend) {
                        context.read<ChatProvider>().resendMessage(message);
                      }
                    });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -2),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: SafeArea(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: screenWidth * 0.83,
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF9FAFB),
                      hintStyle: TextStyle(
                          color: Color(
                            0xFF98A2B3,
                          ),
                          fontSize: 14),
                      hintText: 'Send a message...',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFFEAECF0),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFFEAECF0),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.image_outlined,
                              size: 16, color: Color(0xFF98A2B3))),
                      suffixIcon: IconButton(
                        icon: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF0071BC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                        onPressed: () {
                          if (_messageController.text.trim().isNotEmpty) {
                            context.read<ChatProvider>().sendMessage(
                                  _messageController.text.trim(),
                                  user,
                                );
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
