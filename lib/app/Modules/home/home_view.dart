import 'package:com.invoseg.innovation/app/Components/custom_call_button.dart';
import 'package:com.invoseg.innovation/app/Components/custom_icon_list.dart';
import 'package:com.invoseg.innovation/app/Components/list_view_property.dart';
import 'package:com.invoseg.innovation/app/Modules/announcements/announcement_controller.dart';
import 'package:com.invoseg.innovation/app/Modules/announcements/announcement_view.dart';
import 'package:com.invoseg.innovation/app/Modules/complain/complain_view.dart';
import 'package:com.invoseg.innovation/app/Modules/discounts/discount_view.dart';
import 'package:com.invoseg.innovation/app/Modules/home/home_controller.dart';
import 'package:com.invoseg.innovation/app/Modules/notHome/not_Home_controller.dart';
import 'package:com.invoseg.innovation/app/Modules/notHome/not_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put<HomeController>(HomeController());
  AnnouncementDialogController logic = Get.put<AnnouncementDialogController>(AnnouncementDialogController());
  NotHomeController notHomeController = Get.put(NotHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 8, left: 4, right: 4),
                    width: Get.width,
                    height: Get.height / 3.8,
                    child: YoutubePlayer(
                      bottomActions: [
                        const SizedBox(width: 17.0),
                        CurrentPosition(),
                        const SizedBox(width: 175.0),
                        RemainingDuration(),
                        const SizedBox(width: 37.0),
                        const PlaybackSpeedButton(),
                      ],
                      controller: YoutubePlayerController(
                          initialVideoId: 'O3DPVlynUM0',
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                          )),
                      showVideoProgressIndicator: true,
                    )),
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 10),
                  child: Text(
                    "Emergency Calls",
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                // Row(
                //   children: [
                Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 12),
                    width: Get.width,
                    child: const CustomButton(
                      iconData: Icons.local_grocery_store,
                      title: 'Grocery',
                      buttonType: 'button-three',
                    )),

                Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 12),
                    width: Get.width,
                    child: const CustomButton(
                      buttonType: 'button-one',
                      iconData: Icons.security_rounded,
                      title: 'SECURITY',
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 28, right: 28),
                  width: Get.width,
                  height: Get.height / 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconList(
                        onpressed: () {
                          Get.to(() => const DiscountScreen());
                        },
                        title: 'Discount',
                        iconData: Icons.wb_sunny_outlined,
                      ),
                      IconList(
                        onpressed: () {
                          Get.to(() => const ComplainPage());
                        },
                        title: 'Complaint',
                        iconData: Icons.line_style_outlined,
                      ),
                      IconList(
                        onpressed: () {
                          if (notHomeController.notHomedocId.value.isNotEmpty) {
                            Get.dialog(const NotHomeCancelRequest());
                          } else {
                            Get.dialog(const NotHome());
                          }
                        },
                        title: 'Not Home',
                        iconData: Icons.home,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 12, top: 5),
                  child: Text(
                    'Trending Properties',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10, top: 20),
                    color: Colors.red.shade50,
                    // width: Get.width,
                    height: Get.height / 6,
                    child: ListViewProperty(
                      list: controller.plots,
                    )),
              ],
            ),
            Obx(() => logic.showAnnouncementDialog.value == true ? const Positioned(child: AnnouncementDialog()) : const SizedBox.shrink()),
          ],
        ));
  }
}
