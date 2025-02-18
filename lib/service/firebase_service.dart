import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:promptio/data/message_model.dart';
import 'package:promptio/data/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // User Management
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromMap({
      'id': doc.id,
      ...doc.data()!,
    });
  }

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Stream<List<MessageModel>> getMessages(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50) //pagination
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<String> sendMessage(String groupId, MessageModel message) async {
    final messageRef = _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc();
    final newMessage = message.copyWith(id: messageRef.id);

    await messageRef.set(newMessage.toMap());
    print("Sent message with ID: ${newMessage.id}");
    return newMessage.id;
  }

  Future<void> updateMessageStatus(
    String groupId,
    String messageId,
    MessageStatus status,
  ) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .update({'status': status.toString()});
  }

  Future<void> markMessageAsDelivered(String groupId, String messageId) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .update({'status': MessageStatus.delivered.toString()});
  }

  Future<void> markMessageAsRead(String groupId, String messageId) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(messageId)
        .update({'status': MessageStatus.read.toString()});
  }

  // Group Management
  Stream<QuerySnapshot> getGroups() {
    return _firestore.collection('groups').snapshots();
  }

  Future<void> cleanupOldMessages(String groupId) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: 30));
    final batch = _firestore.batch();

    final oldMessages = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .where('timestamp', isLessThan: cutoffDate)
        .get();

    oldMessages.docs.forEach((doc) => batch.delete(doc.reference));
    await batch.commit();
  }
}
