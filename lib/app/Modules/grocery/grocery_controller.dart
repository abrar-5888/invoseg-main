import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/data/Models/groceryModel.dart';
import 'package:com.invoseg.innovation/data/api/groceryApi.dart';

class GroceryController extends GetxController {
  RxList<GroceryModel> groceries = <GroceryModel>[].obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchGrocery();
  }

  Future<void> fetchGrocery() async {
    GroceryApi.groceryRef.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots().listen((event) {
      groceries.value = event.docs.map((e) => GroceryModel.fromJson(e.data())).toList();
    });
  }
}
