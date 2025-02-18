import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:promptio/data/message_model.dart';
import 'package:promptio/data/user_model.dart';
import 'package:promptio/service/firebase_service.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<MessageModel> _messages = [];
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  String _currentGroupId = '';

  List<MessageModel> get messages => _messages;

  void setCurrentGroup(String groupId) {
    _currentGroupId = groupId;

    listenToMessages();
  }

  void listenToMessages() {
    _firebaseService.getMessages(_currentGroupId).listen((updatedMessages) {
      _messages = updatedMessages;

      notifyListeners();
    });
  }

  Future<void> sendMessage(String text, UserModel sender,
      {String? attachmentUrl}) async {
    if (text.trim().isEmpty && attachmentUrl == null) return;
    final message = MessageModel(
        id: "",
        text: text,
        senderId: sender.id,
        senderName: sender.name,
        senderRole: sender.role,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
        attachmentUrl: attachmentUrl);

    try {
      final messageId =
          await _firebaseService.sendMessage(_currentGroupId, message);
      print(
          "Updating status for group: $_currentGroupId, message id: $messageId");

      if (messageId.isNotEmpty) {
        final updatedMessage = message.copyWith(id: messageId);

        _messages.add(updatedMessage);
        notifyListeners();

        await updateMessageStatus(messageId, MessageStatus.delivered);

        print("Generated message ID: $messageId");
        print("Message after update: ${updatedMessage.toMap()}");
      } else {
        print('Error: Received empty message ID from Firebase.');
      }
    } catch (e) {
      print('Error sending message: $e');
      print('Error sending message: $e');
      updateMessageStatus(message.id, MessageStatus.resend);
    }
  }

  /// Update message status in Firestore
  ///
  Future<void> updateMessageStatus(
      String messageId, MessageStatus status) async {
    if (messageId.isEmpty) {
      print('Error: messageId is empty. Cannot update message status.');
      return;
    }

    print(
        "Updating status for group: $_currentGroupId, message id: $messageId");

    await _firebaseService.updateMessageStatus(
        _currentGroupId, messageId, status);
  }

  /// Manually resend a failed message
  Future<void> resendMessage(MessageModel message) async {
    updateMessageStatus(message.id, MessageStatus.waiting); // Mark as "waiting"
    await sendMessage(
        message.text,
        UserModel(
            id: message.senderId,
            email: "",
            name: message.senderName,
            role: message.senderRole),
        attachmentUrl: message.attachmentUrl);
  }

  // Mark all unread messages as delivered when the user opens the chat
  void markMessagesAsDelivered(List<MessageModel> messages) {
    for (var message in messages) {
      if (message.status == MessageStatus.sent) {
        _firebaseService.markMessageAsDelivered(_currentGroupId, message.id);
      }
    }
  }

  /// Mark a specific message as read when opened
  void markMessageAsRead(String messageId) {
    _firebaseService.markMessageAsRead(_currentGroupId, messageId);
  }
}
