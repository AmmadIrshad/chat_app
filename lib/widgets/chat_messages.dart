import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    //snapshot will yield such a stream
    //stream----> setup a listner which automatically listens to this remote database their to the chat collection
    //when new document added here it will automatically notify and trigger builder function
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //empty list
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            const Center(
              child: Text('No messages found!!!'),
            );
          }
          if (!chatSnapshots.hasError) {
            const Center(
              child: Text('Something went wrong'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;
          return ListView.builder(
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                return Text(loadedMessages[index].data()['text']);
              });
        });
  }
}
