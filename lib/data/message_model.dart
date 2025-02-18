import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promptio/data/user_model.dart';

class MessageModel {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final UserRole senderRole;
  final DateTime timestamp;
  final MessageStatus status;
  final String? attachmentUrl;

  MessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.timestamp,
    required this.status,
    this.attachmentUrl,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderRole: UserRole.fromString(map['senderRole'] ?? ''),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: MessageStatus.fromString(map['status'] ?? ''),
      attachmentUrl: map['attachmentUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole.toString(),
      'timestamp': timestamp,
      'status': status.toString(),
      'attachmentUrl': attachmentUrl,
    };
  }

  MessageModel copyWith({
    String? id,
    String? text,
    String? senderId,
    String? senderName,
    UserRole? senderRole,
    DateTime? timestamp,
    MessageStatus? status,
    String? attachmentUrl,
  }) {
    return MessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }
}

enum MessageStatus {
  sent,
  delivered,
  read,
  waiting,
  resend;

  static MessageStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sent':
        return MessageStatus.sent;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'resend':
        return MessageStatus.resend;
      case "waiting":
        return MessageStatus.waiting;
      default:
        return MessageStatus.sent;
    }
  }

  @override
  String toString() {
    return name.toLowerCase();
  }
}
