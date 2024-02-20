import 'package:flutter/foundation.dart';

// Create a class to hold the notification count
class NotificationCounter with ChangeNotifier {
  int _count = 0;
  int _groceryCount = 0;
  int _medicalCount = 0;
  // Getter for the notification count
  int get count => _count;
  int get groceryCount => _groceryCount;
  int get medicalCount => _medicalCount;

  // Method to update the notification count
  void updateCount(int newCount) {
    _count = newCount;
    notifyListeners(); // Notify listeners about the change
  }

  void updategroceryCount(int newCount) {
    _groceryCount = newCount;
    notifyListeners(); // Notify listeners about the change
  }

  void updatemedicalCount(int newCount) {
    _medicalCount = newCount;
    notifyListeners(); // Notify listeners about the change
  }
}
