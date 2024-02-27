import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AnnouncementProvider with ChangeNotifier {
  bool showAnnouncementDialog = false;
  String title = "";
  String description = "";
  String myId = "";

  void announcementDialog(bool newshowAnnouncementDialog) {
    showAnnouncementDialog = newshowAnnouncementDialog;
    notifyListeners(); // Notify listeners about the change
  }

  void fetchAnnouncement(String docId) async {
    var query = await FirebaseFirestore.instance
        .collection('announcements')
        .doc(docId)
        .get();
    var data = query.data() as Map<String, dynamic>;
    title = data['title'];
    description = data['description'];
  }

  void updateAnnouncemnet(String docId) async {
    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(docId)
        .update({
      'seenUids':
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    }).then((value) {
      announcementDialog(false);
    });
  }
}
