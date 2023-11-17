import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Providers/NotificationCounterProvider.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/drawer.dart';
import 'package:testapp/Screens/plots_detail.dart';
import 'package:testapp/global.dart';

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
    plot_count = 0;
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidg(),
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Image(
            image: AssetImage('assets/Images/rehman.png'),
            height: 60,
            width: 60,
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
                Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                if (Provider.of<NotificationCounterProvider>(context)
                        .notificationCount >
                    0) // Show the badge only if there are unread notifications
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red, // You can customize the badge color
                      ),
                      constraints: BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        "${Provider.of<NotificationCounterProvider>(context).notificationCount}",
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
                  duration: Duration(milliseconds: 700),
                  type: PageTransitionType.rightToLeftWithFade,
                  child: Notifications(),
                ),
              );
              setState(() {
                // updateAllIsReadStatus(true);
                // Using Provider to get and update the notification count
                Provider.of<NotificationCounterProvider>(context, listen: false)
                    .resetNotificationCount();
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
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: listPics.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, right: 8, left: 8, bottom: 8),
                    child: Expanded(
                      child: Container(
                        // width:
                        // height: MediaQuery.of(context).size.height / 3.5,

                        decoration: BoxDecoration(
                          color: Color.fromRGBO(236, 238, 240, 1),
                          // border: Border.all(width: 1),
                          // borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.width / 3.1,
                                  width:
                                      MediaQuery.of(context).size.height / 5.5,
                                  child: Stack(children: [
                                    Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(listPics[index]),
                                      height:
                                          MediaQuery.of(context).size.width / 3,
                                      width:
                                          MediaQuery.of(context).size.height /
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
                                        Row(
                                          children: [
                                            Icon(
                                                Icons
                                                    .local_fire_department_rounded,
                                                size: 14,
                                                color: Colors.red),
                                            Icon(Icons.verified_user,
                                                size: 14, color: Colors.green),
                                            // Text(
                                            //   ' Main Alam Road - Gulberg',
                                            //   style: TextStyle(
                                            //       fontSize: 10,
                                            //       color: Colors.blue),
                                            // ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ), // Text(
                                        //   listName[index],
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        Row(
                                          children: [
                                            Text(
                                              'PKR 2.1 Crore',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xffd9d9d9),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  'INSTALLMENTS',
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          listName[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.bed,
                                              size: 13,
                                            ),

                                            // SizedBox(
                                            //   width: 1,
                                            // ),

                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '3',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.bathtub,
                                              size: 13,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '4',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),

                                            Icon(
                                              Icons.tire_repair,
                                              size: 13,
                                            ),
                                            Text(
                                              ' 5 Marla',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
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
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: const Color.fromRGBO(
                                                        15, 39, 127, 1)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 7,
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.chat,
                                                        size: 14,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'SMS',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: const Color.fromRGBO(
                                                        15, 39, 127, 1)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 7,
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.call,
                                                        size: 14,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'CALL',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            // Container(
                                            //   decoration: BoxDecoration(
                                            //       borderRadius:
                                            //           BorderRadius.circular(5),
                                            //       color: const Color.fromRGBO(
                                            //           15, 39, 127, 1)),
                                            //   child: Padding(
                                            //     padding:
                                            //         const EdgeInsets.symmetric(
                                            //             vertical: 7,
                                            //             horizontal: 20),
                                            //     child: Row(
                                            //       children: [
                                            //         Icon(
                                            //           FontAwesomeIcons.whatsapp,
                                            //           size: 14,
                                            //           color: Colors.white,
                                            //         ),
                                            //         SizedBox(
                                            //           width: 5,
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // ListTile(
                            //   title: Text(items[index]),
                            // ),

                            // Padding(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 0, vertical: 14),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       Row(
                            //         children: [
                            //           Container(
                            //             decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(30),
                            //                 color: const Color(0xffd9d9d9),

                            //                 //    color: Color.fromARGB(255, 189, 183, 183),
                            //                 border: Border.all(
                            //                     width: 1,
                            //                     color:
                            //                         const Color(0xffd9d9d9))),
                            //             child: const Padding(
                            //               padding: EdgeInsets.all(8.0),
                            //               child: Icon(
                            //                 Icons.home_work_outlined,
                            //                 size: 19,
                            //                 color: Color(0xff2824e5),
                            //               ),
                            //             ),
                            //           ),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 'Flats',
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 12),
                            //               ),
                            //               Text(
                            //                 '2.25 Crore - 2.65 Crore',
                            //                 style: TextStyle(
                            //                     fontSize: 11,
                            //                     color: const Color.fromRGBO(
                            //                         15, 39, 127, 1)),
                            //               ),
                            //               Text(
                            //                 '1.7 Marla - 2 Marla',
                            //                 style: TextStyle(fontSize: 11),
                            //               ),
                            //             ],
                            //           )
                            //         ],
                            //       ),
                            //       Row(
                            //         children: [
                            //           Container(
                            //             decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(30),
                            //                 color: const Color(0xffd9d9d9),

                            //                 //    color: Color.fromARGB(255, 189, 183, 183),
                            //                 border: Border.all(
                            //                     width: 1,
                            //                     color:
                            //                         const Color(0xffd9d9d9))),
                            //             child: const Padding(
                            //               padding: EdgeInsets.all(8.0),
                            //               child: Icon(
                            //                 Icons.store,
                            //                 size: 19,
                            //                 color: Color(0xff2824e5),
                            //               ),
                            //             ),
                            //           ),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           const Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text(
                            //                 'Shops',
                            //                 style: TextStyle(
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 12),
                            //               ),
                            //               Text(
                            //                 'Up to 5.9 Crore',
                            //                 style: TextStyle(
                            //                     fontSize: 11,
                            //                     color: const Color.fromRGBO(
                            //                         15, 39, 127, 1)),
                            //               ),
                            //               Text(
                            //                 'Up to 1.9 Marla',
                            //                 style: TextStyle(fontSize: 11),
                            //               ),
                            //             ],
                            //           )
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //   children: [
                            //     Container(
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(5),
                            //           color:
                            //               const Color.fromRGBO(15, 39, 127, 1)),
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 5, horizontal: 15),
                            //         child: Row(
                            //           children: [
                            //             Icon(
                            //               Icons.playlist_add_check_circle_sharp,
                            //               color: Colors.white,
                            //             ),
                            //             SizedBox(
                            //               width: 5,
                            //             ),
                            //             Text(
                            //               'Reserve',
                            //               style: TextStyle(color: Colors.white),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(5),
                            //           color:
                            //               const Color.fromRGBO(15, 39, 127, 1)),
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 6.5, horizontal: 20),
                            //         child: Text(
                            //           'Call',
                            //           style: TextStyle(color: Colors.white),
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(5),
                            //           color:
                            //               const Color.fromRGBO(15, 39, 127, 1)),
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 6.5, horizontal: 20),
                            //         child: Text(
                            //           'Email',
                            //           style: TextStyle(color: Colors.white),
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(5),
                            //           color:
                            //               const Color.fromRGBO(15, 39, 127, 1)),
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(
                            //             vertical: 5, horizontal: 20),
                            //         child: Icon(
                            //           Icons.wechat_sharp,
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlotsDetail()),
                    );
                  },
                );

                //  ListTile(
                //   title: Text(items[index]),
                // );
              },
            ),
          ),

          /////////////////////////////////////////////////////////////////////////////////
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///
          ///////////////////////////////////////////////////////////////////////////////////

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: listPics.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return InkWell(
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //               top: 8, right: 8, left: 8, bottom: 8),
          //           child: Expanded(
          //             child: Container(
          //               width: double.infinity,
          //               // height: MediaQuery.of(context).size.height / 3.5,
          //               decoration: BoxDecoration(
          //                   border: Border.all(width: 1),
          //                   borderRadius: BorderRadius.circular(10)),
          //               child: Column(
          //                 children: [
          //                   Row(
          //                     children: [
          //                       Image(
          //                         fit: BoxFit.cover,
          //                         image: AssetImage(listPics[index]),
          //                         height:
          //                             MediaQuery.of(context).size.width / 3.7,
          //                         width:
          //                             MediaQuery.of(context).size.height / 4.5,
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.only(
          //                             top: 8, right: 8, left: 8),
          //                         child: Container(
          //                           child: Column(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.start,
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Row(
          //                                 children: [
          //                                   Icon(Icons.pin_drop_outlined,
          //                                       size: 13, color: Colors.blue),
          //                                   Text(
          //                                     ' Main Alam Road - Gulberg',
          //                                     style: TextStyle(
          //                                         fontSize: 10,
          //                                         color: Colors.blue),
          //                                   ),
          //                                 ],
          //                               ),
          //                               Text(
          //                                 listName[index],
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               SizedBox(
          //                                 height: 20,
          //                               ),
          //                               Row(
          //                                 children: [
          //                                   Icon(
          //                                     Icons.home_work_outlined,
          //                                     size: 13,
          //                                   ),
          //                                   Text(
          //                                     ' Starting From',
          //                                     style: TextStyle(fontSize: 11),
          //                                   ),
          //                                 ],
          //                               ),
          //                               Text(
          //                                 'PKR  2.25 Crore',
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold,
          //                                     fontSize: 12),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                   // ListTile(
          //                   //   title: Text(items[index]),
          //                   // ),
          //                   Divider(
          //                     thickness: 1,
          //                   ),
          //                   Padding(
          //                     padding: EdgeInsets.symmetric(
          //                         horizontal: 0, vertical: 14),
          //                     child: Row(
          //                       mainAxisAlignment:
          //                           MainAxisAlignment.spaceEvenly,
          //                       children: [
          //                         Row(
          //                           children: [
          //                             Container(
          //                               decoration: BoxDecoration(
          //                                   borderRadius:
          //                                       BorderRadius.circular(30),
          //                                   color: const Color(0xffd9d9d9),

          //                                   //    color: Color.fromARGB(255, 189, 183, 183),
          //                                   border: Border.all(
          //                                       width: 1,
          //                                       color:
          //                                           const Color(0xffd9d9d9))),
          //                               child: const Padding(
          //                                 padding: EdgeInsets.all(8.0),
          //                                 child: Icon(
          //                                   Icons.home_work_outlined,
          //                                   size: 19,
          //                                   color: Color(0xff2824e5),
          //                                 ),
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             const Column(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.start,
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   'Flats',
          //                                   style: TextStyle(
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 12),
          //                                 ),
          //                                 Text(
          //                                   '2.25 Crore - 2.65 Crore',
          //                                   style: TextStyle(
          //                                       fontSize: 11,
          //                                       color: const Color.fromRGBO(
          //                                           15, 39, 127, 1)),
          //                                 ),
          //                                 Text(
          //                                   '1.7 Marla - 2 Marla',
          //                                   style: TextStyle(fontSize: 11),
          //                                 ),
          //                               ],
          //                             )
          //                           ],
          //                         ),
          //                         Row(
          //                           children: [
          //                             Container(
          //                               decoration: BoxDecoration(
          //                                   borderRadius:
          //                                       BorderRadius.circular(30),
          //                                   color: const Color(0xffd9d9d9),

          //                                   //    color: Color.fromARGB(255, 189, 183, 183),
          //                                   border: Border.all(
          //                                       width: 1,
          //                                       color:
          //                                           const Color(0xffd9d9d9))),
          //                               child: const Padding(
          //                                 padding: EdgeInsets.all(8.0),
          //                                 child: Icon(
          //                                   Icons.store,
          //                                   size: 19,
          //                                   color: Color(0xff2824e5),
          //                                 ),
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             const Column(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.start,
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   'Shops',
          //                                   style: TextStyle(
          //                                       fontWeight: FontWeight.bold,
          //                                       fontSize: 12),
          //                                 ),
          //                                 Text(
          //                                   'Up to 5.9 Crore',
          //                                   style: TextStyle(
          //                                       fontSize: 11,
          //                                       color: const Color.fromRGBO(
          //                                           15, 39, 127, 1)),
          //                                 ),
          //                                 Text(
          //                                   'Up to 1.9 Marla',
          //                                   style: TextStyle(fontSize: 11),
          //                                 ),
          //                               ],
          //                             )
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: 10,
          //                   ),
          //                   Row(
          //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                     children: [
          //                       Container(
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(5),
          //                             color:
          //                                 const Color.fromRGBO(15, 39, 127, 1)),
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(
          //                               vertical: 5, horizontal: 15),
          //                           child: Row(
          //                             children: [
          //                               Icon(
          //                                 Icons.playlist_add_check_circle_sharp,
          //                                 color: Colors.white,
          //                               ),
          //                               SizedBox(
          //                                 width: 5,
          //                               ),
          //                               Text(
          //                                 'Reserve',
          //                                 style: TextStyle(color: Colors.white),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                       Container(
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(5),
          //                             color:
          //                                 const Color.fromRGBO(15, 39, 127, 1)),
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(
          //                               vertical: 6.5, horizontal: 20),
          //                           child: Text(
          //                             'Call',
          //                             style: TextStyle(color: Colors.white),
          //                           ),
          //                         ),
          //                       ),
          //                       Container(
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(5),
          //                             color:
          //                                 const Color.fromRGBO(15, 39, 127, 1)),
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(
          //                               vertical: 6.5, horizontal: 20),
          //                           child: Text(
          //                             'Email',
          //                             style: TextStyle(color: Colors.white),
          //                           ),
          //                         ),
          //                       ),
          //                       Container(
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.circular(5),
          //                             color:
          //                                 const Color.fromRGBO(15, 39, 127, 1)),
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(
          //                               vertical: 5, horizontal: 20),
          //                           child: Icon(
          //                             Icons.wechat_sharp,
          //                             color: Colors.white,
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(
          //                     height: 10,
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ),
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => PlotsDetail()),
          //           );
          //         },
          //       );

          //       //  ListTile(
          //       //   title: Text(items[index]),
          //       // );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

//  ListView.builder(
//         itemCount: listPics.length,
//         itemBuilder: (BuildContext context, int index) {
//           return InkWell(
//             child: Padding(
//               padding:
//                   const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 8),
//               child: Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   // height: MediaQuery.of(context).size.height / 3.5,
//                   decoration: BoxDecoration(
//                       border: Border.all(width: 1),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Image(
//                             fit: BoxFit.cover,
//                             image: AssetImage(listPics[index]),
//                             height: MediaQuery.of(context).size.width / 3.7,
//                             width: MediaQuery.of(context).size.height / 4.5,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 top: 8, right: 8, left: 8),
//                             child: Container(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(Icons.pin_drop_outlined,
//                                           size: 13, color: Colors.blue),
//                                       Text(
//                                         ' Main Alam Road - Gulberg',
//                                         style: TextStyle(
//                                             fontSize: 10, color: Colors.blue),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                     listName[index],
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   SizedBox(
//                                     height: 20,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.home_work_outlined,
//                                         size: 13,
//                                       ),
//                                       Text(
//                                         ' Starting From',
//                                         style: TextStyle(fontSize: 11),
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                     'PKR  2.25 Crore',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       // ListTile(
//                       //   title: Text(items[index]),
//                       // ),
//                       Divider(
//                         thickness: 1,
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 0, vertical: 14),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30),
//                                       color: const Color(0xffd9d9d9),

//                                       //    color: Color.fromARGB(255, 189, 183, 183),
//                                       border: Border.all(
//                                           width: 1,
//                                           color: const Color(0xffd9d9d9))),
//                                   child: const Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Icon(
//                                       Icons.home_work_outlined,
//                                       size: 19,
//                                       color: Color(0xff2824e5),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 const Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Flats',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 12),
//                                     ),
//                                     Text(
//                                       '2.25 Crore - 2.65 Crore',
//                                       style: TextStyle(
//                                           fontSize: 11,
//                                           color: const Color.fromRGBO(
//                                               15, 39, 127, 1)),
//                                     ),
//                                     Text(
//                                       '1.7 Marla - 2 Marla',
//                                       style: TextStyle(fontSize: 11),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30),
//                                       color: const Color(0xffd9d9d9),

//                                       //    color: Color.fromARGB(255, 189, 183, 183),
//                                       border: Border.all(
//                                           width: 1,
//                                           color: const Color(0xffd9d9d9))),
//                                   child: const Padding(
//                                     padding: EdgeInsets.all(8.0),
//                                     child: Icon(
//                                       Icons.store,
//                                       size: 19,
//                                       color: Color(0xff2824e5),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 const Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Shops',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 12),
//                                     ),
//                                     Text(
//                                       'Up to 5.9 Crore',
//                                       style: TextStyle(
//                                           fontSize: 11,
//                                           color: const Color.fromRGBO(
//                                               15, 39, 127, 1)),
//                                     ),
//                                     Text(
//                                       'Up to 1.9 Marla',
//                                       style: TextStyle(fontSize: 11),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: const Color.fromRGBO(15, 39, 127, 1)),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 15),
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.playlist_add_check_circle_sharp,
//                                     color: Colors.white,
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     'Reserve',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: const Color.fromRGBO(15, 39, 127, 1)),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 6.5, horizontal: 20),
//                               child: Text(
//                                 'Call',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: const Color.fromRGBO(15, 39, 127, 1)),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 6.5, horizontal: 20),
//                               child: Text(
//                                 'Email',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: const Color.fromRGBO(15, 39, 127, 1)),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 5, horizontal: 20),
//                               child: Icon(
//                                 Icons.wechat_sharp,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => PlotsDetail()),
//               );
//             },
//           );

//           //  ListTile(
//           //   title: Text(items[index]),
//           // );
//         },
//       ),
