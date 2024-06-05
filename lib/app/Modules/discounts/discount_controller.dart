import 'package:com.invoseg.innovation/app/data/api/discountsApi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/data/Models/discountsModel.dart';

class DiscountsController extends GetxController {
  RxList<DiscountsModel> discount = <DiscountsModel>[].obs;
  RxList<DiscountsModel> healthDiscount = <DiscountsModel>[].obs;
  RxList<DiscountsModel> educationDiscount = <DiscountsModel>[].obs;
  RxList<DiscountsModel> fitnessDiscount = <DiscountsModel>[].obs;
  RxList<DiscountsModel> foodDiscount = <DiscountsModel>[].obs;
  RxList<DiscountsModel> lifeStyleDiscount = <DiscountsModel>[].obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  // late HomeController controller;
  @override
  void onInit() {
    super.onInit();
    fetchDiscount();
  }

  Future<void> fetchDiscount() async {
    isLoading.value = true;
    DiscountsAPI.discountsQuery.snapshots().listen((event) {
      discount.value = event.docs.map((e) => DiscountsModel.fromJson(e.data())).toList();
      for (var dis in discount) {
        if (dis.category == 'Health') {
          healthDiscount.add(dis);
        }
        if (dis.category == 'Education') {
          educationDiscount.add(dis);
        }
        if (dis.category == 'Life Style') {
          lifeStyleDiscount.add(dis);
        }
        if (dis.category == 'Food') {
          foodDiscount.add(dis);
        }
        if (dis.category == 'Fitness') {
          fitnessDiscount.add(dis);
        }
      }
    });

    isLoading.value = false;
  }
}
