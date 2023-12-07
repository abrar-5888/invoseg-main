import 'package:flutter/material.dart';
import 'package:testapp/Screens/main/Design.dart';
import 'package:testapp/Screens/main/Emergency.dart';
import 'package:testapp/Screens/main/Grocery.dart';
import 'package:testapp/Screens/main/feed/News&Feeds.dart';
import 'package:testapp/Screens/main/plots.dart';
import 'package:testapp/global.dart';

class TabsScreen extends StatefulWidget {
  static const route = 'tabsScreen';

  TabsScreen({super.key, required this.index});
  int index = 0;
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  @override
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        // 'Pages': Plots(),

        'Pages': const HomeDesign1(),
        'title': 'Home',
      },
      {
        'Pages': const Grocery(),
        'title': 'Grocery',
      },
      {
        'Pages': const Emergency(),
        'title': 'Emergency',
      },
      {
        'Pages': const Newsandfeeds(),
        'title': 'News & Feeds',
      },
      // {
      //   'Pages': ButtonsHistory(),
      //   'title': 'History',
      // },
      {
        'Pages': const Plots(),
        // 'Pages': Explore(),.
        'title': 'Explore',
      }
    ];
    super.initState();
    // getAllIsReadStatus();
    getAllIsReadStatus();
    print("++++++++++++++++++++++++++++++++++++++$med_count");
    setState(() {
      _selectedPageIndex = widget.index;

      // widget.index;
    });
  }

  //changing this from 0 to 1

  void _selectPage(int index) {
    setState(() {
      // _selectedPageIndex = 3;
      _selectedPageIndex = index;
      if (_selectedPageIndex == 1) {
        // updateAllIsReadStatus(true);
        updateGroisReadbool(true);
        setState(() {
          // updateAllIsReadStatus(true);
          gro_count = 0;
        });
      }
      if (_selectedPageIndex == 2) {
        updateMedisRead(true);
        // updateAllIsReadStatus(true);
        // updateAllIsReadStatus(true);
        setState(() {
          med_count = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['Pages'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: gro_count > 0
                ? Stack(
                    children: <Widget>[
                      const Icon(Icons.shopping_basket_rounded),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            "$gro_count",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.shopping_basket_rounded),
            label: 'Grocery',
          ),
          BottomNavigationBarItem(
            icon: med_count > 0
                ? Stack(
                    children: <Widget>[
                      const Icon(Icons.medical_services_rounded),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            med_count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.medical_services_rounded),
            label: 'Medical',
          ),
          BottomNavigationBarItem(
            icon: feed_count > 0
                ? Stack(
                    children: <Widget>[
                      const Icon(Icons.feed_rounded),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            feed_count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.feed_rounded),
            label: 'Feeds',
          ),
          // BottomNavigationBarItem(
          //   icon: history_count > 0
          //       ? Stack(
          //           children: <Widget>[
          //             Icon(Icons.history),
          //             Positioned(
          //               right: 0,
          //               child: Container(
          //                 padding: EdgeInsets.all(2),
          //                 decoration: BoxDecoration(
          //                   color: Colors.red,
          //                   borderRadius: BorderRadius.circular(6),
          //                 ),
          //                 constraints: BoxConstraints(
          //                   minWidth: 12,
          //                   minHeight: 12,
          //                 ),
          //                 child: Text(
          //                   '${history_count.toString()}',
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 8,
          //                   ),
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         )
          //       : Icon(Icons.history),
          //   label: 'History',
          // ),
          BottomNavigationBarItem(
            icon: plot_count > 0
                ? Stack(
                    children: <Widget>[
                      const Icon(Icons.explore),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            plot_count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.explore),
            label: 'Plots',
          ),
        ],
      ),
    );
  }
}
