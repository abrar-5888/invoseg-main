import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/data/Models/medicalModel.dart';
import 'package:com.invoseg.innovation/app/data/api/medicalApi.dart';

class MedicalController extends GetxController {
  RxList<MedicalModel> medicals = <MedicalModel>[].obs;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchMedicals();
  }

  Future<void> fetchMedicals() async {
    MedicalApi.medicalRef.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots().listen((event) {
      medicals.value = event.docs.map((e) => MedicalModel.fromJson(e.data())).toList();
    });
  }
}
