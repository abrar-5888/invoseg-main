import 'package:com.invoseg.innovation/app/Modules/Drawer/drawer_view.dart';
import 'package:com.invoseg.innovation/app/Modules/notifications/notifications_view.dart';
import 'package:com.invoseg.innovation/app/data/api/notificationsApi.dart';
import 'package:com.invoseg.innovation/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      backgroundColor: Colors.white,
      drawer: const DrawerW(),
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(margin: const EdgeInsets.only(left: 7), child: Image.network(appLogo)),
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
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.house_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feed_rounded),
              label: 'Feeds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket_rounded),
              label: 'Grocery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'Plots',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Recents',
            ),
          ],
        );
      }),
    );
  }
}
