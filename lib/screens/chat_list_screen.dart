import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
       stream: FirebaseFirestore.instance
    .collection('chats')
    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No chats yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final chatId = chat.id;

              final data = chat.data() as Map<String, dynamic>;

              final lastMessage = data['lastMessage'] ?? "No messages";
              final timestamp = data['timestamp'];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.chat, color: Colors.white),
                  ),

                  title: Text(
                    "Chat",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  trailing: timestamp != null
                      ? Text(
                          _formatTime(timestamp),
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(chatId: chatId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 🕒 Format timestamp
  String _formatTime(Timestamp timestamp) {
    final dt = timestamp.toDate();
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}