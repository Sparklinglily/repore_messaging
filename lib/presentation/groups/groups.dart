import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:promptio/presentation/chats/chat_screen.dart';
import 'package:promptio/presentation/providers/auth_provider.dart';
import 'package:promptio/service/firebase_service.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatelessWidget {
  GroupsPage({super.key});

  final firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Groups'),
            Text(
              'Welcome, ${user?.name ?? "Loading..."}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getGroups(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final group = snapshot.data!.docs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(group['name'][0].toUpperCase()),
                ),
                title: Text(
                  group['name'],
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(groupId: group.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
