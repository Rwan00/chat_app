import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/fonts.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .orderBy("createdAt", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text(
              "No Messages Found!",
              style: titleStyle,
            );
          } else if (snapshot.hasError) {
            return Text(
              "Something Went Wrong...",
              style: titleStyle,
            );
          } else {
            final loadedMessages = snapshot.data!.docs;
            return ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 40,
                  left: 13,
                  right: 13,
                ),
                itemCount: loadedMessages.length,
                itemBuilder: (context, index) {
                  final chatMessage = loadedMessages[index].data();
                  final nextMessage = index + 1 < loadedMessages.length
                      ? loadedMessages[index + 1].data()
                      : null;
                  final currentMessageUserId = chatMessage["userId"];
                  final nextMessageUserId =
                      nextMessage != null ? nextMessage["userId"] : null;

                  final bool nextUserIsSame =
                      nextMessageUserId == currentMessageUserId;
                  if (nextUserIsSame) {
                    return MessageBubble.next(
                        message: chatMessage["text"],
                        isMe: authUser.uid == currentMessageUserId);
                  } else {
                    return MessageBubble.first(
                      userImage: chatMessage["image_url"],
                      username: chatMessage["userName"],
                      message: chatMessage["text"],
                      isMe: authUser.uid == currentMessageUserId,
                    );
                  }
                });
          }
        });
  }
}
