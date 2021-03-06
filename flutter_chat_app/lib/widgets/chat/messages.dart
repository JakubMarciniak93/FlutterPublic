import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatsDocs = chatSnapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: chatSnapshot.data.documents.length,
              itemBuilder: (ctx, index) => MessageBubble(
                chatsDocs[index]['text'],
                chatsDocs[index]['username'],
                chatsDocs[index]['userId'] == futureSnapshot.data.uid,
                key: ValueKey(chatsDocs[index].documentID),
              ),
            );
          },
        );
      },
    );
  }
}
