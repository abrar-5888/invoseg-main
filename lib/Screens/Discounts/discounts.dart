import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testapp/Screens/Discounts/All.dart';
import 'package:testapp/Screens/Discounts/Test.dart';
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
    return Scaffold(
        drawer: DrawerWidg(),
        key: _key,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          // centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),

          title: const Text(
            'Discounts',
            style: TextStyle(
                color: Color(0xff212121),
                fontWeight: FontWeight.w700,
                fontSize: 24),
          ),
          actions: <Widget>[
            IconButton(
              icon: Stack(
                children: <Widget>[
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  if (notification_count >
                      0) // Show the badge only if there are unread notifications
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              Colors.red, // You can customize the badge color
                        ),
                        constraints: BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: Text(
                          notification_count.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12, // You can customize the font size
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () async {
                // Handle tapping on the notifications icon
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
        body: DefaultTabController(
            length: 6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: TabBar(
                        indicator: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],

                          borderRadius:
                              BorderRadius.circular(15), // Circular indicator
                          color: Color.fromARGB(
                              186, 226, 228, 233), // Selected tab color
                          border: Border.all(
                              color: Color.fromARGB(197, 255, 0, 0),
                              width: 1), // Border for selected tab
                        ),
                        unselectedLabelColor: Color.fromARGB(
                            255, 158, 158, 158), // Unselected tab color
                        labelColor: const Color.fromARGB(255, 255, 255, 255),
                        tabs: [
                          Tab(
                            child: Text(
                              "All",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Health",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Food",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Test",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Container(child: All()),
                      Container(child: Health()),
                      Container(child: Food()),
                      Container(child: Test()),
                    ],
                  ),
                ),
              ],
            )));
  }
}
