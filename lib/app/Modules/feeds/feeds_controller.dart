import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:com.invoseg.innovation/data/api/feedsApi.dart';
import 'package:com.invoseg.innovation/data/Models/feedsModel.dart';
// ignore_for_file: avoid_print

// ignore_for_file: unused_local_variable

class FeedsController extends GetxController {
  RxList<FeedsModel> feeds = <FeedsModel>[].obs;
  RxInt currentIndex = 0.obs;
  String userUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    super.onInit();
    fetchFeeds();
  }

  Future<void> fetchFeeds() async {
    try {
      FeedsApi.feedsQuery.snapshots().listen((event) {
        feeds.value = event.docs.map((e) => FeedsModel.fromJson(e.data())).toList();
      });
    } catch (error) {
      print("Error: $error");
    }
  }
}
