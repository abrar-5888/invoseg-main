import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LikesPage extends StatefulWidget {
  var documentId;
  LikesPage({super.key, required this.documentId});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<dynamic> likedUsers = [];

  Future<void> getLikesUsers() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('feed')
          .doc(widget.documentId)
          .get();
      if (documentSnapshot.exists) {
        // Get the likesuids array field from the document
        var data = documentSnapshot.data() as Map<String, dynamic>;

        List<String>? likesUids = List<String>.from(data['Likesuids'] ?? []);

        if (likesUids.isNotEmpty) {
          for (int i = 0; i < likesUids.length; i++) {
            String userId = likesUids[i];
            print(userId);

            // Check in 'UserRequest' collection
            QuerySnapshot<Map<String, dynamic>> userRequestSnapshot =
                await FirebaseFirestore.instance
                    .collection('UserRequest')
                    .where('uid', isEqualTo: userId)
                    .get();

            if (userRequestSnapshot.docs.isNotEmpty) {
              print("not empty");
              setState(() {
                likedUsers.add({
                  'name': userRequestSnapshot.docs.first.data()['Name'],
                });
              });
              //   // User found in 'UserRequest' collection
            } else {
              print("Empty");

              //   // User not found in 'UserRequest', check in 'FMData' subcollection
              QuerySnapshot<Map<String, dynamic>> fmDataSnapshot =
                  await FirebaseFirestore.instance
                      .collection('UserRequest')
                      .doc(userId)
                      .collection('FMData')
                      .get();

              if (fmDataSnapshot.docs.isNotEmpty) {
                setState(() {
                  likedUsers.add({
                    'name': fmDataSnapshot.docs.first.data()['Name'],
                  });
                });
                // User found in 'FMData' subcollection
              } else {
                // User not found in both 'UserRequest' and 'FMData'
                // Handle accordingly or ignore
              }
            }
          }

          // Do something with the likedUsers list
        } else {
          // likesuids array is empty or not present
          print('No likesuids found.');
        }
      } else {
        // Document does not exist
        print('Document not found.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getLikesUsers();
  }

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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: likedUsers.length,
        itemBuilder: (context, index) {
          String firstAlphabet = likedUsers[index]['name'][0].toUpperCase();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color.fromRGBO(15, 39, 127, 1),
                child: Text(
                  firstAlphabet,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(likedUsers[index]['name']),
            ),
          );
        },
      ),
    );
  }
}
