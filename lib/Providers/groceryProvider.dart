import 'package:flutter/foundation.dart';

class GroceryProvider with ChangeNotifier {
  String id = '';
  bool showGroBox = false;

  void changeShowGroBox(bool value) {
    showGroBox = value;
    notifyListeners();
  }

  void saveId(String id) {
    id = id;
    notifyListeners();
  }

  void fetchData() {}
}
