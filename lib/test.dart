// // ignore_for_file: use_super_parameters

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:promptio/core/constants/message_bubble.dart';
// import 'package:promptio/presentation/providers/auth_provider.dart';
// import 'package:promptio/presentation/providers/chats_provider.dart';
// import 'package:provider/provider.dart';

// class ChatScreen extends StatefulWidget {
//   final String groupId;

//   const ChatScreen({Key? key, required this.groupId}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _messageController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     context.read<ChatProvider>().setCurrentGroup(widget.groupId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = context.watch<AuthProvider>().currentUser!;
//     final messages = context.watch<ChatProvider>().messages;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//             onTap: () => Navigator.pop(context),
//             child: SizedBox(
//               height: 2,
//               width: 2,
//               child: SvgPicture.asset(
//                 "assets/arrow.svg",
//               ),
//             )),
//         title: Text('Leaked Drainage'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               padding: EdgeInsets.all(8),
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final message = messages[index];
//                 final isCurrentUser = message.senderId == user.id;

//                 // return MessageBubble(
//                 //   message: message,
//                 //   isCurrentUser: isCurrentUser,
//                 // );
//                 return MessageBubble(
//               message: message,
//               onRetry: message.status == MessageStatus.resend
//                   ? () => chatProvider.retryMessage(message)
//                   : null,
//             );
//               },
//             ),
//           ),
    //       Container(
    //         padding: EdgeInsets.all(8),
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           boxShadow: [
    //             BoxShadow(
    //               offset: Offset(0, -2),
    //               blurRadius: 2,
    //               color: Colors.black.withOpacity(0.1),
    //             ),
    //           ],
    //         ),
    //         child: SafeArea(
    //           child: Align(
    //             alignment: Alignment.centerRight,
    //             child: SizedBox(
    //               width: screenWidth * 0.85,
    //               child: TextField(
    //                 controller: _messageController,
    //                 decoration: InputDecoration(
    //                   filled: true,
    //                   fillColor: Color(0xFFF9FAFB),
    //                   hintStyle: TextStyle(
    //                       color: Color(
    //                         0xFF98A2B3,
    //                       ),
    //                       fontSize: 14),
    //                   hintText: 'Send a message...',
    //                   focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       width: 1,
    //                       color: Color(0xFFEAECF0),
    //                     ),
    //                     borderRadius: BorderRadius.circular(20),
    //                   ),
    //                   enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       width: 1,
    //                       color: Color(0xFFEAECF0),
    //                     ),
    //                     borderRadius: BorderRadius.circular(20),
    //                   ),
    //                   contentPadding: EdgeInsets.symmetric(
    //                     horizontal: 12,
    //                     vertical: 8,
    //                   ),
    //                   prefixIcon: IconButton(
    //                       onPressed: () {},
    //                       icon: Icon(Icons.attachment_outlined,
    //                           size: 16, color: Color(0xFF98A2B3))),
    //                   suffixIcon: IconButton(
    //                     icon: Container(
    //                       padding: EdgeInsets.all(8),
    //                       decoration: BoxDecoration(
    //                         color: Color(0xFF0071BC),
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                       child: Icon(
    //                         Icons.send,
    //                         color: Colors.white,
    //                         size: 10,
    //                       ),
    //                     ),
    //                     onPressed: () {
    //                       if (_messageController.text.trim().isNotEmpty) {
    //                         context.read<ChatProvider>().sendMessage(
    //                               _messageController.text.trim(),
    //                               user,
    //                             );
    //                         _messageController.clear();
    //                       }
    //                     },
    //                   ),
    //                 ),
    //                 maxLines: null,
    //               ),
    //             ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:promptio/data/message_model.dart';
// import 'package:promptio/data/user_model.dart';

// class MessageBubble extends StatelessWidget {
//   final MessageModel message;
//   final bool isCurrentUser;

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.isCurrentUser,
//   }) : super(key: key);

//   Color get _bubbleColor {
//     switch (message.senderRole) {
//       case UserRole.dispatcher:
//         return Colors.deepPurple;
//       case UserRole.agent:
//         return Colors.blue;
//       case UserRole.customer:
//         return Colors.grey.shade200;
//     }
//   }

//   Color get _textColor {
//     return message.senderRole == UserRole.customer
//         ? Colors.black
//         : Colors.white;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment:
//           isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(
//             horizontal: 8,
//             vertical: 4,
//           ),
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: _bubbleColor,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 message.senderName,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: _textColor,
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 message.text,
//                 style: TextStyle(color: _textColor),
//               ),
//             ],
//           ),
//         ),
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               message.status.toString(),
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _textColor.withOpacity(0.7),
//               ),
//             ),
//             SizedBox(width: 4),
//             _buildStatusIcon(message.status),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusIcon(MessageStatus status) {
//     IconData iconData;
//     switch (status) {
//       case MessageStatus.sent:
//         iconData = Icons.check;
//         break;
//       case MessageStatus.delivered:
//         iconData = Icons.done_all;
//         break;
//       case MessageStatus.read:
//         iconData = Icons.done_all;
//         break;
//       case MessageStatus.waiting:
//         iconData = Icons.warning;

//       case MessageStatus.resend:
//         iconData = Icons.error_outline;
//         break;
//     }

//     return Icon(
//       iconData,
//       size: 12,
//       color: _textColor.withOpacity(0.7),
//     );
//   }
// }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:promptio/core/constants/message_bubble.dart';
// import 'package:promptio/data/message_model.dart';
// import 'package:promptio/presentation/providers/auth_provider.dart' as local;
// import 'package:promptio/presentation/providers/chats_provider.dart';
// import 'package:provider/provider.dart';

// class ChatScreen extends StatelessWidget {
//   final String groupId;
//   ChatScreen({Key? key, required this.groupId}) : super(key: key);
//   final _messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final currentUserId = FirebaseAuth.instance.currentUser!;
//     final user = context.watch<local.AuthProvider>().currentUser!;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//             onTap: () => Navigator.pop(context),
//             child: SizedBox(
//               height: 2,
//               width: 2,
//               child: SvgPicture.asset(
//                 "assets/arrow.svg",
//               ),
//             )),
//         title: Text('Leaked Drainage'),
//       ),
//       body: Column(
//         children: [
//           Consumer<ChatProvider>(
//             builder: (context, chatProvider, child) {
//               return Expanded(
//                 child: ListView.builder(
//                   padding: EdgeInsets.all(8),
//                   reverse: true,
//                   itemCount: chatProvider.messages.length,
//                   itemBuilder: (context, index) {
//                     final message = chatProvider.messages[index];

//                     // Mark message as read when it becomes visible
//                     WidgetsBinding.instance.addPostFrameCallback((_) {
//                       chatProvider.markMessageAsRead(message);
//                     });

//                     return MessageBubble(
//                       message: message,
//                       isCurrentUser: message.senderId == currentUserId,
//                       onRetry: message.status == MessageStatus.resend
//                           ? () =>
//                               chatProvider.retryMessage(groupId, "", message)
//                           : null,
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   offset: Offset(0, -2),
//                   blurRadius: 2,
//                   color: Colors.black.withOpacity(0.1),
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: SizedBox(
//                   width: screenWidth * 0.85,
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Color(0xFFF9FAFB),
//                       hintStyle: TextStyle(
//                           color: Color(
//                             0xFF98A2B3,
//                           ),
//                           fontSize: 14),
//                       hintText: 'Send a message...',
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 1,
//                           color: Color(0xFFEAECF0),
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           width: 1,
//                           color: Color(0xFFEAECF0),
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       prefixIcon: IconButton(
//                           onPressed: () {},
//                           icon: Icon(Icons.attachment_outlined,
//                               size: 16, color: Color(0xFF98A2B3))),
//                       suffixIcon: IconButton(
//                         icon: Container(
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Color(0xFF0071BC),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Icon(
//                             Icons.send,
//                             color: Colors.white,
//                             size: 10,
//                           ),
//                         ),
//                         onPressed: () {
//                           if (_messageController.text.trim().isNotEmpty) {
//                             context.read<ChatProvider>().sendMessage(
//                                   _messageController.text.trim(),
//                                   user,
//                                 );
//                             _messageController.clear();
//                           }
//                         },
//                       ),
//                     ),
//                     maxLines: null,
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
