import 'package:get/get.dart';
import 'package:com.invoseg.innovation/data/Models/historyModel.dart';
import 'package:com.invoseg.innovation/data/api/historyApi.dart';
// ignore_for_file: avoid_print

class HistoryController extends GetxController {
  RxList<HistoryModel> histories = <HistoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistories();
  }

  Future<void> fetchHistories() async {
    HistoryApi.historyQuery.snapshots().listen((event) {
      histories.value = event.docs.map((e) => HistoryModel.fromJson(e.data())).toList();
    });
  }
}
