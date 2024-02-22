import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/Providers/NotificationCounterProvider.dart';
import 'package:com.invoseg.innovation/Providers/visitorProvider.dart';
import 'package:com.invoseg.innovation/Screens/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/drawer.dart';
import 'package:com.invoseg.innovation/Screens/plots_detail.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:com.invoseg.innovation/widgets/visitorAlertBox.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Plots extends StatefulWidget {
  const Plots({super.key});

  @override
  State<Plots> createState() => _PlotsState();
}

class _PlotsState extends State<Plots> {
  final List<String> listPics = [
    'assets/Images/plot4.jpeg',
    'assets/Images/plot2.jpg',
    'assets/Images/dd.jpg',
    'assets/Images/ss.jpg',
    'assets/Images/plot2.jpg',
    'assets/Images/plot4.jpeg',
  ];
  final List<String> listName = [
    'Swiss Mall Gulberg',
    'PIA Housing Scheme',
    'Johar Town Shop',
    'Liberty Plot',
    'Swiss Mall Gulberg',
    'PIA Housing Scheme',
    // 'Chungi Amar Sidhu',
  ];

  @override
  void initState() {
    // TODO: implement initState
    // plot_count = 0;
    updateTabs();
    getAllIsReadStatus();
    // Timer.periodic(const Duration(seconds: 3), (Timer timer) {
    //   getAllIsReadStatus();
    // });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final notificationCounter =
        Provider.of<NotificationCounter>(context, listen: false);
    FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      notificationCounter.updateCount(snapshot.docs.length);
    });
    final visitorProvider =
        Provider.of<VisitorProvider>(context, listen: false);
    FirebaseFirestore.instance
        .collection('notifications')
        .where('description',
            isEqualTo: 'please confirm identity of your friend')
        .orderBy('pressedTime', descending: true)
        .snapshots()
        .listen((snapshot) {
      var doc = snapshot.docs.first;
      var data = doc.data();
      String id = data['id'];
      visitorProvider.notiDocId = doc.id;
      print(id);
      visitorProvider.fetchNotiInfo(id);
      visitorProvider.showVisitorDialogs(true);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DrawerWidg(),
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Image(
              image: AssetImage("assets/Images/TransparentLogo.png"),
              height: 40,
              width: 40,
            ),
          ),
        ),
        title: const Text(
          'Plot & House',
          style: TextStyle(
              color: Color(0xff212121),
              fontWeight: FontWeight.w700,
              fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            icon: Stack(
              children: <Widget>[
                const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                Consumer<NotificationCounter>(
                  builder: (context, counter, child) {
                    if (notificationCounter.count >
                        0) // Show the badge only if there are unread notifications
                    {
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Colors.red, // You can customize the badge color
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 15,
                          ),
                          child: Text(
                            "${notificationCounter.count}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12, // You can customize the font size
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
            onPressed: () async {
              // resetNotificationCount();

              updateAllIsReadStatus(true);
              // Handle tapping on the notifications icon
              await Navigator.push(
                context,
                PageTransition(
                  duration: const Duration(milliseconds: 700),
                  type: PageTransitionType.rightToLeftWithFade,
                  child: const Notifications(),
                ),
              );
              // No need to manually reset the count here
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
                _key.currentState?.openDrawer();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<VisitorProvider>(builder: (context, counter, child) {
            if (visitorProvider.showVisitorDialog == true) {
              // visitorProvider.playAlarmSound();
              return visitorAlertBox(visitorProvider: visitorProvider);
            } else {
              return Container();
            }
          }),
          FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("plots")
                  .orderBy('timestamp', descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Data Availale"));
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  // var data=discounts;
                  final plots = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: plots.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = plots[index].data() as Map<String, dynamic>;
                      final mediaUrls = data['mediaUrls'] as List<dynamic>;
                      print(data);
                      var price = data['price'];
                      var phoneNumber = data['phone'];

                      String id = data['id'];
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8, right: 8, left: 8, bottom: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlotsDetail(ids: id)));
                          },
                          child: Flex(direction: Axis.vertical, children: [
                            Container(
                              // width:
                              // height: MediaQuery.of(context).size.height / 3.5,

                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(236, 238, 240, 1),
                                // border: Border.all(width: 1),
                                // borderRadius: BorderRadius.circular(10)
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                3.1,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                5.5,
                                        child: Stack(children: [
                                          Image(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(mediaUrls[0]),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                5.5,
                                          ),
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0, right: 8, left: 8),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .local_fire_department_rounded,
                                                      size: 14,
                                                      color: Colors.red),
                                                  Icon(Icons.verified_user,
                                                      size: 14,
                                                      color: Colors.green),
                                                  // Text(
                                                  //   ' Main Alam Road - Gulberg',
                                                  //   style: TextStyle(
                                                  //       fontSize: 10,
                                                  //       color: Colors.blue),
                                                  // ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ), // Text(
                                              //   listName[index],
                                              //   style: TextStyle(
                                              //       fontWeight: FontWeight.bold),
                                              // ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'PKR $price',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffd9d9d9),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Text(
                                                        '${data['category']}',
                                                        style: const TextStyle(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "${data['address']}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              FittedBox(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.bed,
                                                      size: 13,
                                                    ),

                                                    // SizedBox(
                                                    //   width: 1,
                                                    // ),

                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${data['room']}',
                                                      style: const TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Icon(
                                                      Icons.bathtub,
                                                      size: 13,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${data['bath']}',
                                                      style: const TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),

                                                    const Icon(
                                                      Icons.tire_repair,
                                                      size: 13,
                                                    ),
                                                    Text(
                                                      ' ${data['area']}',
                                                      style: const TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              const Row(
                                                children: [
                                                  // Icon(
                                                  //   Icons.home_work_outlined,
                                                  //   size: 13,
                                                  // ),
                                                  Text(
                                                    'Added: 11 hours ago',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      final Uri smsUri = Uri.parse(
                                                          'smsto:$phoneNumber');

                                                      try {
                                                        await launch(
                                                            smsUri.toString());
                                                      } catch (e) {
                                                        print(
                                                            'Error launching SMS: $e');
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: const Color
                                                              .fromRGBO(
                                                              15, 39, 127, 1)),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 7,
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.chat,
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              'SMS',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      final Uri smsUri =
                                                          Uri.parse(
                                                              'tel:$phoneNumber');

                                                      try {
                                                        await launch(
                                                            smsUri.toString());
                                                      } catch (e) {
                                                        print(
                                                            'Error launching SMS: $e');
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: const Color
                                                            .fromRGBO(
                                                            15, 39, 127, 1),
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 7,
                                                                horizontal: 10),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.call,
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              'CALL',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height : 10,
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                  );
                }
              }),
        ],
      ),
    );
  }
}
