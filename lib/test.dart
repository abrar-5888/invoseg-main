import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/Providers/NotificationCounterProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class test extends StatelessWidget {
  const test({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationCounter =
        Provider.of<NotificationCounter>(context, listen: false);
    FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      notificationCounter.updateCount(snapshot.docs.length);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Notification Count:',
            ),
            Consumer<NotificationCounter>(
              builder: (context, counter, child) {
                return Text(
                  '${counter.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Simulating an update to the notification count
                // In a real app, you would fetch the count from Firestore and update it here
                Provider.of<NotificationCounter>(context, listen: false)
                    .updateCount(10);
              },
              child: const Text('Update Count'),
            ),
          ],
        ),
      ),
    );
  }
}
