import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Modules/announcements/announcement_controller.dart';
import 'package:com.invoseg.innovation/data/api/AnnouncementApi.dart';

class AnnouncementDialog extends StatelessWidget {
  const AnnouncementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    AnnouncementDialogController controller = Get.put(AnnouncementDialogController());
    return Center(
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        content: SizedBox(
          width: Get.width / 1,
          height: Get.height / 1.8,
          child: Column(
            children: [
              Center(
                  child: SizedBox(
                width: Get.width / 1.6,
                child: Image.network(controller.announcement!.imgUrl),
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Annoucement',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    controller.announcement!.title,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(controller.announcement!.description),
                  const SizedBox(
                    height: 15,
                  ),
                  Text('${controller.announcement!.date} ${controller.announcement!.time}'),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: Get.width / 4.5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.black),
                          ),
                          onPressed: () {
                            AnnouncementsApi.updateAnnouncement(controller.announcement!.id, controller.auth.currentUser!.uid);
                            controller.showAnnouncementDialog.value = false;
                            Get.back();
                          },
                          child: const Text('OK', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
