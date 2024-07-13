import 'package:com.invoseg.innovation/main_app/app/data/Models/feedsModel.dart';
import 'package:com.invoseg.innovation/main_app/app/data/api/feedsApi.dart';
import 'package:get/get.dart';
// ignore_for_file: avoid_print

// ignore_for_file: unused_local_variable

class FeedsController extends GetxController {
  RxList<FeedsModel> feeds = <FeedsModel>[].obs;
  RxInt currentIndex = 0.obs;

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
