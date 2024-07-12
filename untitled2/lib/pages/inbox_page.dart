import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'message_category.dart';
import 'message_card.dart';
// import 'package:untitled2/components/bottom_navbar.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<List<MessageCategory>> fetchMessages() async {
    List<MessageCategory> messageCategories = [];

    if (user != null) {
      String userId = user!.uid;
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('volunteerId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Message> waterCanMessages = [];
        List<Message> boatsMessages = [];
        List<Message> medicalAssistanceMessages = [];
        List<Message> foodAndGroceriesMessages = [];

        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data();
          String item = data['item'] ?? '';

          Message message = Message(
            sender: data['victimName'],
            content: data['message'],
            unreadCount: 0, // You might want to fetch unread count from a different field in Firestore
          );

          if (item.toLowerCase() == 'water can') {
            waterCanMessages.add(message);
          } else if (item.toLowerCase() == 'boat') {
            boatsMessages.add(message);
          } else if (item.toLowerCase() == 'medical assistance') {
            medicalAssistanceMessages.add(message);
          } else if (item.toLowerCase() == 'food & groceries') {
            foodAndGroceriesMessages.add(message);
          }
        });

        if (waterCanMessages.isNotEmpty) {
          messageCategories.add(MessageCategory(category: 'Request: Water Can', messages: waterCanMessages));
        }
        if (boatsMessages.isNotEmpty) {
          messageCategories.add(MessageCategory(category: 'Request: Boats', messages: boatsMessages));
        }
        if (medicalAssistanceMessages.isNotEmpty) {
          messageCategories.add(MessageCategory(category: 'Request: Medical Assistance', messages: medicalAssistanceMessages));
        }
        if (foodAndGroceriesMessages.isNotEmpty) {
          messageCategories.add(MessageCategory(category: 'Request: Food & Groceries', messages: foodAndGroceriesMessages));
        }
      }
    }

    return messageCategories;
  }

  void updateMessageReadCount(Message message) {
    setState(() {
      // message.unreadCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<List<MessageCategory>>(
        future: fetchMessages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No messages found.'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.map((category) {
                  return CategoryWidget(
                    category: category,
                    onMessageTap: updateMessageReadCount,
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}