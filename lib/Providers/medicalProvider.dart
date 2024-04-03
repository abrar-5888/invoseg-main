import 'package:flutter/foundation.dart';

class MedicalProvider with ChangeNotifier {
  bool showMedBox = false;
  String id = '';

  void changeShowMedBox(bool value) {
    showMedBox = value;
    notifyListeners();
  }

  void saveId(String id) {
    id = id;
    notifyListeners();
  }

  void fetchData() {}
}
