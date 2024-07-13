import 'package:com.invoseg.innovation/main_app/app/Modules/home/home_controller.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/plotsModel.dart';
import 'package:get/get.dart';

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
