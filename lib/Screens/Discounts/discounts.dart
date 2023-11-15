import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testapp/Screens/Discounts/All.dart';
import 'package:testapp/Screens/Discounts/education.dart';
import 'package:testapp/Screens/Discounts/food.dart';
import 'package:testapp/Screens/Discounts/health.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/drawer.dart';
import 'package:testapp/global.dart';

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
        drawer: DrawerWidg(),
        key: _key,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
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
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  if (notification_count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: Text(
                          notification_count.toString(),
                          style: TextStyle(
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
                    child: Notifications(),
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
                icon: Icon(
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
              child: Container(
                height: 50,
                child: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(186, 226, 228, 233),
                    border: Border.all(
                      color: Color.fromARGB(197, 255, 0, 0),
                      width: 1,
                    ),
                  ),
                  unselectedLabelColor: Color.fromARGB(255, 158, 158, 158),
                  labelColor: const Color.fromARGB(255, 255, 255, 255),
                  tabs: [
                    for (int i = 0; i < 6; i++)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Tab(
                          child: Text(
                            i == 0
                                ? "ALL"
                                : i == 1
                                    ? "HEALTH"
                                    : i == 2
                                        ? "FITNESS"
                                        : i == 3
                                            ? "FOOD"
                                            : i == 4
                                                ? "EDUCATION"
                                                : "LIFESTYLE",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  All(),
                  Health(),
                  Food(),
                  Education(),
                  Container(child: Text("LIFESTYLE")),
                  Container(child: Text("Another Tab")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
