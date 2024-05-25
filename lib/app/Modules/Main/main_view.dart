import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Modules/Drawer/drawer_view.dart';
import 'package:com.invoseg.innovation/app/Modules/notifications/notifications_view.dart';
import 'package:com.invoseg.innovation/data/api/notificationsApi.dart';
import 'package:com.invoseg.innovation/generated/assets.dart';

import 'mainview_controller.dart';

class MainPage extends StatelessWidget {
  final int index;
  const MainPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    MainPageController pageController = Get.put<MainPageController>(MainPageController());
    pageController.selectScreen.value = index;
    return Scaffold(
      drawer: const DrawerW(),
      key: key,
      appBar: AppBar(
        leading: Obx(() => pageController.logo.value.isNotEmpty
            ? Container(margin: const EdgeInsets.only(left: 7), child: Image.network(pageController.logo.value))
            : Container(margin: const EdgeInsets.only(left: 7), child: Image.asset(Assets.logoBGR))),
        centerTitle: true,
        title: Obx(() {
          return Text(
            pageController.barTitles[pageController.selectScreen.value],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              NotificationsApi.updateIsRead().then((value) => Get.to(() => const NotiScreen()));
            },
            icon: Stack(
              children: <Widget>[
                const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                Obx(
                  () => pageController.notiLength.value > 0
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                            ),
                            child: Text(
                              "${pageController.notiLength.value}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                key.currentState!.openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                size: 25,
                color: Colors.black,
              ))
        ],
      ),
      body: Stack(
        children: [
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 0),
              child: pageController.screens.elementAt(pageController.selectScreen.value),
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: pageController.selectScreen.value,
          onTap: pageController.itemTap,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.house_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.feed_rounded),
              label: 'Feeds',
            ),
            BottomNavigationBarItem(
              icon: Obx(() => pageController.groceryCount.value > 0
                  ? Stack(
                      children: <Widget>[
                        const Icon(Icons.shopping_basket_rounded),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                            ),
                            child: Text(
                              "${pageController.groceryCount.value}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  : const Icon(Icons.shopping_basket_rounded)),
              label: 'Grocery',
            ),
            BottomNavigationBarItem(
              icon: Obx(() => pageController.medicalCount.value > 0
                  ? Stack(
                      children: <Widget>[
                        const Icon(Icons.medical_services),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                            ),
                            child: Text(
                              "${pageController.medicalCount.value}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  : const Icon(Icons.medical_services)),
              label: 'Medical',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'Plots',
            ),
          ],
        );
      }),
    );
  }
}
