import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/components/post_component.dart';
import 'content_state.dart';

class ContentListPage extends StatefulWidget {
  @override
  _ContentListPageState createState() => _ContentListPageState();
}

class _ContentListPageState extends State<ContentListPage> {
  final Set<String> _clickedContentIds = Set();
  User? user;
  String? userId;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user!.uid;
    } else {
      print('User is not logged in');
    }
  }

  void _removeContent(String id) {
    setState(() {
      _clickedContentIds.add(id);
    });
  }

  Future<List<Content>> _fetchContents() async {
    List<Content> contents = [];
    if (userId != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('victims').get();
      for (var doc in snapshot.docs) {
        var data = doc.data();
        contents.add(Content(
          profilePicUrl: data['profilePicUrl'],
          name: data['name'],
          priorityLevel: data['priorityLevel'],
          mobilenumber: data['mobilenumber'],
          item: data['item'],
          headcount: data['headcount'],
          location: data['location'],
          content: data['content'],
          imageUrl: data['imageUrl'],
          role: data['role'],
          id: doc.id,
        ));
      }
    }
    return contents;
  }

  @override
  Widget build(BuildContext context) {
    return ContentState(
      removeContent: _removeContent,
      child: Scaffold(
        appBar: AppBar(title: Text('Content List')),
        body: FutureBuilder<List<Content>>(
          future: _fetchContents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No content available'));
            } else {
              final visibleContents = snapshot.data!.where((content) => !_clickedContentIds.contains(content.id)).toList();
              return ListView.builder(
                itemCount: visibleContents.length,
                itemBuilder: (context, index) {
                  return visibleContents[index];
                },
              );
            }
          },
        ),
      ),
    );
  }
}
