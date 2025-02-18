import 'package:flutter/material.dart';
import 'package:promptio/core/constants/app_colors.dart';
import 'package:promptio/data/message_model.dart';
import 'package:promptio/data/user_model.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:promptio/presentation/providers/chats_provider.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isCurrentUser;
  final VoidCallback? onResend;

  const MessageBubble({
    Key? key,
    this.onResend,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);

  Color get _bubbleColor {
    switch (message.senderRole) {
      case UserRole.admin:
        return AppColors.purple;
      case UserRole.agent:
        return AppColors.blue;
      case UserRole.customer:
        return AppColors.gray;
    }
  }

  Color get _textColor {
    return message.senderRole == UserRole.customer
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    final size = MediaQuery.sizeOf(context);
    return VisibilityDetector(
      key: Key(message.id),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.5 &&
            message.status != MessageStatus.read) {
          chatProvider.markMessageAsRead(message.id);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser) buildAvatar(),
          Container(
            // 70% width
            width: size.width * 0.7,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _bubbleColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              message.senderName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatTime(message.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: _textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        message.text,
                        style: TextStyle(color: _textColor),
                      ),
                      SizedBox(height: 4),
                      if (message.senderRole == UserRole.admin)
                        Align(
                            alignment: Alignment.centerRight,
                            child: buildRoleBadge("Admin")),
                      if (message.senderRole == UserRole.agent)
                        Align(
                            alignment: Alignment.centerRight,
                            child: buildRoleBadge("Agent")),
                      if (message.senderRole == UserRole.customer)
                        Align(
                            alignment: Alignment.centerRight,
                            child: buildRoleBadge("Customer")),
                      //  _buildRoleBadge(message.senderRole.toString())
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.status.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF475467),
                      ),
                    ),
                    SizedBox(width: 4),
                    buildStatusIcon(message.status, chatProvider),
                    if (message.status == MessageStatus.resend)
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: onResend,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isCurrentUser) buildAvatar(),
        ],
      ),
    );
  }

  Widget buildRoleBadge(String role) {
    Color badgeColor;
    Color textColor;

    // I defined colors based on the  user role
    switch (role) {
      case 'Admin':
        badgeColor = Colors.amber;
        textColor = Colors.brown;
        break;
      case 'Agent':
        badgeColor = Colors.yellowAccent;
        textColor = Colors.black;
        break;
      case 'Customer':
        badgeColor = Colors.green;
        textColor = Colors.white;
        break;
      default:
        badgeColor = Colors.grey;
        textColor = Colors.white;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildAvatar() {
    String initials = message.senderName.isNotEmpty
        ? message.senderName[0].toUpperCase()
        : "?";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 194, 236, 245),
          borderRadius: BorderRadius.circular(8.0)),
      child: Text(
        initials,
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00B4D8)),
      ),
    );
  }

  Widget buildStatusIcon(MessageStatus status, ChatProvider chatProvider) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case MessageStatus.sent:
        iconData = Icons.check;
        iconColor = Color(0xFF475467);
        break;
      case MessageStatus.delivered:
        iconData = Icons.done_all;
        iconColor = Color(0xFF475467);

        break;
      case MessageStatus.read:
        iconData = Icons.done_all;
        iconColor = Colors.blue;
        break;
      case MessageStatus.resend:
        iconData = Icons.error_outline;
        iconColor = Colors.red;
        break;

      case MessageStatus.waiting:
        iconData = Icons.timer_outlined;
        iconColor = Color(0xFF475467);
    }

    return Icon(
      iconData,
      size: 12,
      color: iconColor,
    );
  }

  String formatTime(DateTime timestamp) {
    int hour = timestamp.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12 == 0 ? 12 : hour % 12;
    return "$hour:${timestamp.minute.toString().padLeft(2, '0')} $period";
  }
}
