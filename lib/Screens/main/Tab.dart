import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/Screens/main/Design.dart';
import 'package:com.invoseg.innovation/Screens/main/Emergency.dart';
import 'package:com.invoseg.innovation/Screens/main/Grocery.dart';
import 'package:com.invoseg.innovation/Screens/main/feed/News&Feeds.dart';
import 'package:com.invoseg.innovation/Screens/main/plots.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsScreen extends StatefulWidget {
  static const route = 'tabsScreen';

  TabsScreen({super.key, required this.index});
  int index = 0;
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String FCMtoken = "";
  Future<void> addFcmToken() async {
    SharedPreferences tokrn = await SharedPreferences.getInstance();

    await _firebaseMessaging.getToken().then((String? token) async {
      if (token != null) {
        setState(() {
          tokrn.setString('token', token);
          FCMtoken = token;
        });

        QuerySnapshot querySnapshots = await FirebaseFirestore.instance
            .collection('UserRequest')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
        if (querySnapshots.docs.isNotEmpty) {
          String id = querySnapshots.docs.first.id;
          await FirebaseFirestore.instance
              .collection('UserRequest')
              .doc(id)
              .update({'FCMtoken': FCMtoken});
          print("MainDoc++OKA");
        } else {
          print("elseWork");
          QuerySnapshot querySnapshot =
              await FirebaseFirestore.instance.collection('UserRequest').get();

          if (querySnapshot.docs.isNotEmpty) {
            // Iterate through each document in the main collection
            for (var mainDocument in querySnapshot.docs) {
              String mainDocumentId = mainDocument.id; // Main document ID

              // Access the subcollection of each main document
              QuerySnapshot subCollectionSnapshot = await FirebaseFirestore
                  .instance
                  .collection('UserRequest')
                  .doc(mainDocumentId)
                  .collection('FMData')
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get();

              // Check if the subcollection is not empty
              if (subCollectionSnapshot.docs.isNotEmpty) {
                // Process documents in the subcollection
                for (var subDocument in subCollectionSnapshot.docs) {
                  String subDocumentId = subDocument.id; // Subdocument ID

                  // Do something with the subdocument data
                  var subDocumentData = subDocument.data();
                  await FirebaseFirestore.instance
                      .collection('UserRequest')
                      .doc(mainDocumentId)
                      .collection('FMData')
                      .doc(subDocumentId)
                      .update({'FCMtoken': FCMtoken});
                  print("SubDoc++OKA");
                }
              } else {
                // Handle the case where the subcollection is empty for a specific main document
                print(
                    'Subcollection is empty for main document $mainDocumentId');
              }
            }
          } else {
            // Handle the case where the main collection is empty
            print('Main collection is empty.');
          }
        }
      }
    });
  }

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
    addFcmToken();
    addCount();
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
      if (_selectedPageIndex == 0) {
        updateTabs();
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
