import 'package:flutter/material.dart';

class CommentSheet extends StatefulWidget {
  const CommentSheet({super.key});

  @override
  _CommentSheetState createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  List<String> comments = [
    'Great post!',
    'Awesome!',
    'I love this!',
    'Nice shot!',
    'Amazing!',
    'Well done!',
    'Fantastic!',
    'Superb!',
    'Incredible!',
    'Beautiful!',
  ];
  List<String> names = [
    'User 1',
    'User 2',
    'User 3',
    'User 4',
    'User 5',
    'User 6',
    'User 7',
    'User 8',
    'User 10',
    'User 11'
  ];
  TextEditingController comment = TextEditingController();
  int num = 11;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.2,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 8.0,
                  thickness: 5.0,
                  color: Colors.grey[300],
                  indent: MediaQuery.of(context).size.width * 0.35,
                  endIndent: MediaQuery.of(context).size.width * 0.35,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.red,
                      ),
                      title: Text(names[index]),
                      subtitle: Text(comments[index]),
                    );
                  },
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: comment,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onSubmitted: (comment) {
                          // Add your logic to handle submitted comments
                          print('Submitted Comment: $comment');
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // Add your logic to handle sending comments
                        print('Sending Comment');
                        setState(() {
                          names.add("User ${num + 1}");
                          comments.add(comment.text);
                        });

                        comment.clear();
                        // Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
