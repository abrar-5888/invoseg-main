// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class NotificationCounterProvider extends ChangeNotifier {
//   int notificationCount = 0;
//   int groceryCount = 0;
//   int medicalCount = 0;
//   int feedCount = 0;
//   int plotCount = 0;

//   final _isReadStreamController = StreamController<List<bool>>.broadcast();

//   Stream<List<bool>> get isReadStream => _isReadStreamController.stream;

//   Future<List<bool>> getAllIsReadStatus() async {
//     List<bool> isReadList = [];
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('notifications')
//           .where('isRead', isEqualTo: false)
//           .get();

//       for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
//         final data = documentSnapshot.data() as Map<String, dynamic>;
//         final isRead = data['isRead'] ?? false;
//         isReadList.add(isRead);
//       }

//       notificationCount = isReadList.length;
//       _isReadStreamController
//           .add(isReadList); // Notify listeners about the change
//     } catch (e) {
//       print('Error fetching isRead status: $e');
//     }
//     return isReadList;
//   }

//   void resetNotificationCount() {
//     notificationCount = 0;
//     notifyListeners();
//   }

//   Future<void> updateAllIsReadStatus(bool isRead) async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('notifications').get();
//       WriteBatch batch = FirebaseFirestore.instance.batch();

//       for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
//         batch.update(documentSnapshot.reference, {'isRead': isRead});
//       }

//       await batch.commit();
//     } catch (e) {
//       print('Error updating isRead status for all documents: $e');
//     }
//   }

//   void dispose() {
//     _isReadStreamController
//         .close(); // Close the stream controller when not needed
//   }
// }
