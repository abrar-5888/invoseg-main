import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class VisitorProvider with ChangeNotifier {
  bool showVisitorDialog = false;

  String notiImage = "";
  String notiName = "";
  String notiPurpose = "";
  String notiVehicle = "";
  String id = "";
  String notiDocId = "";
  void playAlarmSound() async {
    try {
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/sounds/applepay.mp3"),

        // autoPlay: true,
        // showNotification: true,
      );
      // AssetsAudioPlayer.newPlayer().open(
      //   Audio("assets/sounds/applepay.mp3"),

      //   // autoPlay: true,
      //   // showNotification: true,
      // );
    } catch (e) {
      print("Failed to load audio asset: $e");
    }
  }

  void showVisitorDialogs(bool newshowVisitorDialog) {
    showVisitorDialog = newshowVisitorDialog;
    notifyListeners(); // Notify listeners about the change
  }

  Future<void> fetchNotiInfo(String ids) async {
    // showVisitorDialog = true;
    id = ids;
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('entryUser')
          .doc(ids)
          // .where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.data() != null) {
        // DocumentSnapshot documentSnapshot = querySnapshot.data
        var data = querySnapshot.data() as Map<String, dynamic>;

        notiImage = data['photo'];
        notiName = data['firstName'];
        notiPurpose = data['purpose'];
        notiVehicle = data['vehicleNo'];
      } else {
        print('No documents found for the specified ID.');
      }
    } catch (e) {
      print('Error fetching notification info: $e');
    }
  }
}
