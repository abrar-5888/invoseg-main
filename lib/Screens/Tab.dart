import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Screens/Emergency.dart';
import 'package:testapp/Screens/Dashboard.dart';
import 'package:testapp/Screens/Design.dart';
import 'package:testapp/Screens/Explore.dart';
import 'package:testapp/Screens/Grocery.dart';
import 'package:testapp/Screens/History.dart';
import 'package:testapp/Screens/News&Feeds.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/plots.dart';
import 'package:testapp/global.dart';

class TabsScreen extends StatefulWidget {
  static final route = 'tabsScreen';

  TabsScreen({required this.index});
  int index = 0;
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;
  @override
  int _selectedPageIndex = 0;

  void initState() {
    _pages = [
      {
        // 'Pages': Plots(),

        'Pages': HomeDesign1(),
        'title': 'Home',
      },
      {
        'Pages': Grocery(),
        'title': 'Grocery',
      },
      {
        'Pages': Emergency(),
        'title': 'Emergency',
      },
      {
        'Pages': Newsandfeeds(),
        'title': 'News & Feeds',
      },
      // {
      //   'Pages': ButtonsHistory(),
      //   'title': 'History',
      // },
      {
        'Pages': Plots(),
        // 'Pages': Explore(),.
        'title': 'Explore',
      }
    ];
    super.initState();
    // getAllIsReadStatus();
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
        gro_count = 0;
      }
      if (_selectedPageIndex == 1) {
        // updateAllIsReadStatus(true);
        med_count = 0;
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: gro_count > 0
                ? Stack(
                    children: <Widget>[
                      Icon(Icons.shopping_basket_rounded),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            "${gro_count}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.shopping_basket_rounded),
            label: 'Grocery',
          ),
          BottomNavigationBarItem(
            icon: med_count > 0
                ? Stack(
                    children: <Widget>[
                      Icon(Icons.medical_services_rounded),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${med_count.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.medical_services_rounded),
            label: 'Medical',
          ),
          BottomNavigationBarItem(
            icon: feed_count > 0
                ? Stack(
                    children: <Widget>[
                      Icon(Icons.feed_rounded),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${feed_count.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.feed_rounded),
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
                      Icon(Icons.explore),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${plot_count.toString()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Icon(Icons.explore),
            label: 'Plots',
          ),
        ],
      ),
    );
  }
}
