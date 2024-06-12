import 'package:com.invoseg.innovation/app/Components/custom_drawertile.dart';
import 'package:com.invoseg.innovation/app/Modules/Main/main_view.dart';
import 'package:com.invoseg.innovation/app/Modules/Profile/profile.dart';
import 'package:com.invoseg.innovation/app/Modules/addFamilyMember/addFamilyMember_view.dart';
import 'package:com.invoseg.innovation/app/Modules/complain/complain_view.dart';
import 'package:com.invoseg.innovation/app/Modules/discounts/discount_view.dart';
import 'package:com.invoseg.innovation/app/Modules/residentId/resident_id_view.dart';
import 'package:com.invoseg.innovation/config/themes/themes%20color/colors.dart';
import 'package:com.invoseg.innovation/generated/assets.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerW extends StatefulWidget {
  const DrawerW({super.key});

  @override
  State<DrawerW> createState() => _DrawerWState();
}

class _DrawerWState extends State<DrawerW> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20.0))),
        elevation: 1,
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            SizedBox(
              height: Get.height / 3.5,
              child: DrawerHeader(
                  child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey, spreadRadius: 1)],
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/Images/profile-Icon-SVG.jpg'),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Text(address, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  SizedBox(
                    width: 125,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: ThemeColor.blue),
                        onPressed: () {
                          Get.to(() => const Profile());
                        },
                        child: const Text(
                          'View Profile',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        )),
                  )
                ],
              )),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 30),
                  child: Column(
                    children: [
                      DrawerTile(
                          title: 'Add Family Member',
                          onPress: () {
                            Get.to(const AddMember());
                          },
                          iconData: Icons.person_add),
                      const SizedBox(
                        height: 7,
                      ),
                      // DrawerTile(
                      //     title: 'Medical',
                      //     onPress: () {
                      //       Get.to(() => const MainPage(index: 3));
                      //     },
                      //     iconData: Icons.medical_services),
                      // const SizedBox(
                      //   height: 7,
                      // ),
                      DrawerTile(
                          title: 'Grocery',
                          onPress: () {
                            Get.to(const MainPage(index: 2));
                          },
                          iconData: Icons.shopping_basket_rounded),
                      const SizedBox(
                        height: 7,
                      ),
                      DrawerTile(
                          title: 'History',
                          onPress: () {
                            Get.to(() => const MainPage(index: 4));
                          },
                          iconData: Icons.feed),
                      const SizedBox(
                        height: 7,
                      ),
                      DrawerTile(
                          title: 'Plots',
                          onPress: () {
                            Get.to(() => const MainPage(index: 3));
                          },
                          iconData: Icons.line_style_outlined),
                      const SizedBox(
                        height: 7,
                      ),
                      DrawerTile(
                          title: 'Discounts',
                          onPress: () {
                            Get.to(() => const DiscountScreen());
                          },
                          iconData: Icons.sunny),
                      const SizedBox(
                        height: 7,
                      ),
                      DrawerTile(
                          title: 'Complain',
                          onPress: () {
                            Get.to(() => const ComplainPage());
                          },
                          iconData: Icons.note_add_outlined),
                      const SizedBox(
                        height: 7,
                      ),
                      DrawerTile(
                          title: 'Resident Id',
                          onPress: () {
                            Get.to(() => const ResidentId());
                          },
                          iconData: Icons.calendar_view_day_outlined),

                      const SizedBox(
                        height: 50,
                      ),
                      const Column(
                        children: [
                          Text(
                            'POWERED BY',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Image(
                            image: AssetImage(
                              Assets.imagesTransparentLogo,
                            ),
                            height: 50,
                            width: 50,
                          ),
                          Text(
                            'Smart Ghar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
