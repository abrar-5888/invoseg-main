import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/data/Models/announcementModel.dart';
import 'package:com.invoseg.innovation/data/api/AnnouncementApi.dart';

class AnnouncementDialogController extends GetxController {
  RxBool showAnnouncementDialog = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  AnnouncementModel? announcement;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    AnnouncementsApi.announcementsQuery.snapshots().listen((event) {
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          var data = doc.data();
          List seenUids = data['seenUids'];
          if (!seenUids.contains(auth.currentUser!.uid)) {
            showAnnouncementDialog.value = true;
            announcement = AnnouncementModel.fromJson(doc.id, data);
          }
        }
      }
    });
  }
}
