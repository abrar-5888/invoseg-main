import 'package:com.invoseg.innovation/app/Modules/Main/main_view.dart';
import 'package:com.invoseg.innovation/app/Modules/complain/complain_view.dart';
import 'package:com.invoseg.innovation/app/Modules/notifications/notifications_controller.dart';
import 'package:com.invoseg.innovation/app/data/Models/notificationModel.dart';
import 'package:com.invoseg.innovation/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotiScreen extends StatefulWidget {
  const NotiScreen({super.key});

  @override
  State<NotiScreen> createState() => _NotiScreenState();
}

class _NotiScreenState extends State<NotiScreen> {
  NotificationsController controller = Get.put<NotificationsController>(NotificationsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onPressed: () {
                Get.back();
              }),
          foregroundColor: const Color(0xff212121),
          title: const Text(
            'Notifications',
            style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 23),
          ),
        ),
        body: Obx(
          () => ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              NotificationModel notification = controller.notifications[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () async {
                      if (notification.description.isNotEmpty && notification.description.toString().toLowerCase().contains("prescription")) {
                        controller.moveToPrescription(notification.id);
                      } else if (notification.description.isNotEmpty && notification.description.toString().toLowerCase().contains("order")) {
                        controller.moveToRecipt(notification.id);
                      } else if (notification.description.isNotEmpty && notification.description.toString().toLowerCase().contains("complain")) {
                        Get.to(() => const ComplainPage());
                      } else if (notification.description.isNotEmpty && notification.description.toString().toLowerCase().contains("meet id")) {
                        Get.to(() => const MainPage(
                              index: 3,
                            ));
                      } else if (notification.description.isNotEmpty && notification.description.toString().toLowerCase().contains("home")) {
                        Get.to(() => const MainPage(
                              index: 0,
                            ));
                      }
                    },
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: Container(
                        height: 100,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(Assets.logoBGR)),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(notification.title),
                        Text(
                          "${notification.date} at ${notification.time}",
                          style: const TextStyle(fontSize: 8),
                        )
                      ],
                    ),
                    subtitle: Text(notification.description, maxLines: 2),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
