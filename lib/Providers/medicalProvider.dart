import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MedicalProvider with ChangeNotifier {
  bool showMedBox = false;
  String ids = '';
  String meetId = '';

  void changeShowMedBox(bool value) {
    showMedBox = value;
    if (showMedBox == true) {
      playAlarmSound();
    }
    notifyListeners();
  }

  void playAlarmSound() async {
    try {
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/sounds/alert.mp3"),
      );
    } catch (e) {
      print("Failed to load audio asset: $e");
    }
  }

  void saveId(String id) {
    ids = id;
    notifyListeners();
  }

  void fetchData() async {
    var query = await FirebaseFirestore.instance
        .collection('consultation')
        .doc(ids)
        .get();
    var data = query.data() as Map<String, dynamic>;
    // print("Data::::::$data");
    var doctor = data['doctor'];
    // print("doctor::::::${doctor['meetingId']}");
    meetId = doctor['meetingId'];
    notifyListeners();
  }
}
