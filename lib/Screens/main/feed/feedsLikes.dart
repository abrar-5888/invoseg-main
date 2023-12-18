import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testapp/global.dart';

class LikesPage extends StatefulWidget {
  String documentId, userId;
  LikesPage({super.key, required this.documentId, required this.userId});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  Future<void> getLikesUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instanceFor(app: secondApp)
              .collection('likesUser')
              .where('postId', isEqualTo: widget.documentId)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<dynamic> likesUserIdList =
            querySnapshot.docs.first.data()['likesUserId'];

        for (var likeUser in likesUserIdList) {
          String uid = likeUser['uid'];
          print('User ID: $uid');

          
        }
      } else {}
    } catch (e) {
      print('Error: $e');
    }
  }

  final List<String> likedUsers = [
    'User1',
    'User2',
    'User3',
    'User4',
    'User5',
    'User6',
    'User7',
    'User8',
    'User9',
    'User10',
    'User11',
    'User12',
    'User13',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: const Text(
          'Likes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: likedUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(likedUsers[index]),
            ),
          );
        },
      ),
    );
  }
}
