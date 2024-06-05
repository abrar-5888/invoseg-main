import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Modules/home/home_controller.dart';
import 'package:com.invoseg.innovation/app/data/Models/plotsModel.dart';

class PlotsController extends GetxController {
  RxList<PlotsModel> plots = <PlotsModel>[].obs;
  late HomeController controller;
  @override
  void onInit() {
    super.onInit();
    controller = Get.find<HomeController>();
    plots.value = controller.plots;
  }
}
