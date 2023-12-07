import 'package:flutter/material.dart';

class LikesPage extends StatelessWidget {
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

  LikesPage({super.key});

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
              // You can customize the ListTile as needed
            ),
          );
        },
      ),
    );
  }
}
