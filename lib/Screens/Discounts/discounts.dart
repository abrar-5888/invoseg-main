import 'package:com.invoseg.innovation/Screens/Discounts/All.dart';
import 'package:com.invoseg.innovation/Screens/Discounts/education.dart';
import 'package:com.invoseg.innovation/Screens/Discounts/fitness.dart';
import 'package:com.invoseg.innovation/Screens/Discounts/food.dart';
import 'package:com.invoseg.innovation/Screens/Discounts/health.dart';
import 'package:com.invoseg.innovation/Screens/Discounts/lifestyle.dart';
import 'package:com.invoseg.innovation/Screens/main/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/main/drawer.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Discounts extends StatefulWidget {
  const Discounts({super.key});

  @override
  State<Discounts> createState() => _DiscountsState();
}

class _DiscountsState extends State<Discounts> {
  final List<String> listPics = [
    'assets/Images/plot1.jpg',
    'assets/Images/plot2.jpg',
    'assets/Images/plot3.jpeg',
    'assets/Images/plot4.jpeg',
    'assets/Images/plot5.jpeg',
  ];
  final List<String> listName = [
    ' Swiss Mall Gulberg',
    ' PIA Housing Scheme',
    ' Johar Town Shop',
    ' Liberty Plot',
    ' Chungi Amar Sidhu',
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        drawer: const DrawerWidg(),
        key: _key,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'Discounts',
            style: TextStyle(
              color: Color(0xff212121),
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Stack(
                children: <Widget>[
                  const Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  if (notification_count > 0)
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
                          notification_count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  PageTransition(
                    duration: const Duration(milliseconds: 700),
                    type: PageTransitionType.rightToLeftWithFade,
                    child: const Notifications(),
                  ),
                );
                setState(() {
                  notification_count = 0;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  _key.currentState!.openDrawer();
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(186, 226, 228, 233),
                    border: Border.all(
                      color: const Color.fromRGBO(15, 39, 127, 1),
                      width: 1,
                    ),
                  ),
                  unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                  labelColor: const Color.fromARGB(255, 0, 0, 0),
                  tabs: [
                    for (int i = 0; i < 6; i++)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Tab(
                          child: Text(
                            i == 0
                                ? "All"
                                : i == 1
                                    ? "Health"
                                    : i == 2
                                        ? "Fitness"
                                        : i == 3
                                            ? "Food"
                                            : i == 4
                                                ? "Education"
                                                : "LifeStyle",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 6, 6, 6)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  All(),
                  Health(),
                  Fitness(),
                  Food(),
                  Education(),
                  LifeStyle(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
