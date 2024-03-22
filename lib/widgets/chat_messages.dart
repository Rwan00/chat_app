import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme/fonts.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chats").orderBy("createdAt",descending: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
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
              itemCount: loadedMessages.length,
              itemBuilder: (context, index) {
             return Text(loadedMessages[index].data()["text"],);
            });
          }
        });
  }
}
