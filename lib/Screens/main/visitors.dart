// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:testapp/Screens/main/Notifications.dart';
// import 'package:testapp/Screens/main/drawer.dart';
// import 'package:testapp/global.dart';

// class Visitors extends StatefulWidget {
//   const Visitors({super.key});

//   @override
//   State<Visitors> createState() => _VisitorsState();
// }

// class _VisitorsState extends State<Visitors> {
//   final GlobalKey<ScaffoldState> _key = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       drawer: const DrawerWidg(),
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         // leading: Padding(
//         //   padding: const EdgeInsets.only(left: 8.0),
//         //   child: Image(
//         //     image: AssetImage('assets/Images/rehman.png'),
//         //     height: 60,
//         //     width: 60,
//         //   ),
//         // ),
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios_new,
//               color: Colors.black,
//             )),
//         title: const Text(
//           'Visitors',
//           style: TextStyle(
//               color: Color(0xff212121),
//               fontWeight: FontWeight.w700,
//               fontSize: 24),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Stack(
//               children: <Widget>[
//                 const Icon(
//                   Icons.notifications,
//                   color: Colors.black,
//                 ),
//                 if (notification_count > 0)
//                   Positioned(
//                     right: 0,
//                     top: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(2),
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.red,
//                       ),
//                       constraints: const BoxConstraints(
//                         minWidth: 15,
//                         minHeight: 15,
//                       ),
//                       child: Text(
//                         "$notification_count",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             onPressed: () async {
//               // resetNotificationCount();

//               setState(() {
//                 notification_count = 0;
//               });
//               updateAllIsReadStatus(true);
//               // Handle tapping on the notifications icon
//               await Navigator.push(
//                 context,
//                 PageTransition(
//                   duration: const Duration(milliseconds: 700),
//                   type: PageTransitionType.rightToLeftWithFade,
//                   child: Notifications(),
//                 ),
//               );
//               // No need to manually reset the count here
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: IconButton(
//               icon: const Icon(
//                 Icons.menu,
//                 color: Colors.black,
//               ),
//               onPressed: () {
//                 _key.currentState!.openDrawer();
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: 4,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                 child: Card(
//                   elevation: 5,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(10),
//                     onTap: () {
//                       //  if (des.isNotEmpty && des.toString().contains("identity")) {
//                       // Show Alert Box
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: SizedBox(
//                               height: MediaQuery.of(context).size.height / 3.1,
//                               // child: DrawerHeader(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     height: 100,
//                                     width: 100,
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         BoxShadow(
//                                             blurRadius: 3,
//                                             color: Colors.grey,
//                                             spreadRadius: 1)
//                                       ],
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: const CircleAvatar(
//                                       backgroundImage: AssetImage(
//                                           'assets/Images/profile-Icon-SVG.jpg'),
//                                       radius: 52,
//                                       backgroundColor: Colors.white,
//                                     ),
//                                   ),
//                                   const Padding(
//                                       padding: EdgeInsets.only(
//                                     top: 10,
//                                   )),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       'name',
//                                       style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                   ),
//                                   const Padding(
//                                       padding: EdgeInsets.only(
//                                     top: 5,
//                                   )),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       'phone number ',
//                                       // ${userinfo["email"]}'

//                                       style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                   const Padding(
//                                       padding: EdgeInsets.only(
//                                     top: 5,
//                                   )),
//                                   Container(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       'vehicle number',
//                                       style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400),
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   // Padding(
//                                   //   padding: const EdgeInsets.only(
//                                   //       top: 1, right: 1),
//                                   //   child: Column(
//                                   //     children: [
//                                   //       Center(
//                                   //         child: InkWell(
//                                   //           child: Container(
//                                   //             width: 122,
//                                   //             height: 40,
//                                   //             decoration: BoxDecoration(
//                                   //                 color:
//                                   //                     const Color(0xff3A1D8C),
//                                   //                 borderRadius:
//                                   //                     BorderRadius.circular(
//                                   //                         80)),
//                                   //             child: const Column(
//                                   //               mainAxisAlignment:
//                                   //                   MainAxisAlignment.center,
//                                   //               children: [
//                                   //                 Center(
//                                   //                   child: Text(
//                                   //                     'View Profile',
//                                   //                     style: TextStyle(
//                                   //                       fontSize: 14,
//                                   //                       fontWeight:
//                                   //                           FontWeight.w500,
//                                   //                       color: Colors.white,
//                                   //                     ),
//                                   //                   ),
//                                   //                 ),
//                                   //               ],
//                                   //             ),
//                                   //           ),
//                                   //           onTap: () async {},
//                                   //         ),
//                                   //       ),
//                                   //     ],
//                                   //   ),
//                                   // )
//                                 ],
//                               ),
//                               // ),
//                             ),
//                             content: const Text(
//                               'Please confirm identity of your friend',
//                             ),
//                             actions: <Widget>[
//                               ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all(Colors.black),
//                                 ),
//                                 onPressed: () async {
//                                   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                   //     action: SnackBarAction(
//                                   //       label: "Ok",
//                                   //       onPressed: () {},
//                                   //     ),
//                                   //     content: const Text("Your Not Home request has been Cancelled ")));
//                                 },
//                                 child: const Text('confirm',
//                                     style: TextStyle(color: Colors.white)),
//                               ),
//                               ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all(Colors.black),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.of(context)
//                                       .pop(); // Close the confirmation dialog
//                                 },
//                                 child: const Text('reject',
//                                     style: TextStyle(color: Colors.white)),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                       //  }
//                     },
//                     tileColor: Colors.grey[100],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     leading: Container(
//                       height: 100,
//                       width: 60,
//                       decoration: BoxDecoration(
//                         color: const Color(0xffd9d9d9),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: const Icon(
//                         Icons.image,
//                         color: Color(0xff2824e5),
//                       ),
//                     ),
//                     title: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("title"),
//                         Text(
//                           'ffff',
//                           // "${document['date'].toString()} at ${document['time'].toString()}",
//                           style: const TextStyle(fontSize: 8),
//                         )
//                       ],
//                     ),
//                     subtitle: Text('ddd'),
//                   ),
//                 ),
//               );
//             },
//           ),

//           // ListView.builder(
//           //     shrinkWrap: true,
//           //     physics: const NeverScrollableScrollPhysics(),
//           //     itemCount: 4,
//           //     itemBuilder: (context, index) {
//           //       return ListTile(
//           //         title: Text("Person ${index}"),
//           //         onTap: () {
//           //           // if (des.isNotEmpty && des.toString().contains("identity")) {
//           //           // Show Alert Box
//           //           showDialog(
//           //             context: context,
//           //             builder: (context) {
//           //               return AlertDialog(
//           //                 title: SizedBox(
//           //                   height: MediaQuery.of(context).size.height / 3.1,
//           //                   // child: DrawerHeader(
//           //                   child: Column(
//           //                     mainAxisAlignment: MainAxisAlignment.center,
//           //                     crossAxisAlignment: CrossAxisAlignment.center,
//           //                     children: [
//           //                       Container(
//           //                         height: 100,
//           //                         width: 100,
//           //                         decoration: const BoxDecoration(
//           //                           shape: BoxShape.circle,
//           //                           boxShadow: [
//           //                             BoxShadow(
//           //                                 blurRadius: 3,
//           //                                 color: Colors.grey,
//           //                                 spreadRadius: 1)
//           //                           ],
//           //                         ),
//           //                         alignment: Alignment.center,
//           //                         child: const CircleAvatar(
//           //                           backgroundImage: AssetImage(
//           //                               'assets/Images/profile-Icon-SVG.jpg'),
//           //                           radius: 52,
//           //                           backgroundColor: Colors.white,
//           //                         ),
//           //                       ),
//           //                       const Padding(
//           //                           padding: EdgeInsets.only(
//           //                         top: 10,
//           //                       )),
//           //                       Container(
//           //                         alignment: Alignment.center,
//           //                         child: Text(
//           //                           'name',
//           //                           style: const TextStyle(
//           //                               fontSize: 14,
//           //                               fontWeight: FontWeight.w600),
//           //                         ),
//           //                       ),
//           //                       const Padding(
//           //                           padding: EdgeInsets.only(
//           //                         top: 5,
//           //                       )),
//           //                       Container(
//           //                         alignment: Alignment.center,
//           //                         child: Text(
//           //                           'phone number ',
//           //                           // ${userinfo["email"]}'

//           //                           style: const TextStyle(
//           //                               fontSize: 14,
//           //                               fontWeight: FontWeight.w400),
//           //                         ),
//           //                       ),
//           //                       const Padding(
//           //                           padding: EdgeInsets.only(
//           //                         top: 5,
//           //                       )),
//           //                       Container(
//           //                         alignment: Alignment.center,
//           //                         child: Text(
//           //                           'vehicle number',
//           //                           style: const TextStyle(
//           //                               fontSize: 14,
//           //                               fontWeight: FontWeight.w400),
//           //                         ),
//           //                       ),
//           //                       const SizedBox(
//           //                         height: 5,
//           //                       ),
//           //                       // Padding(
//           //                       //   padding: const EdgeInsets.only(
//           //                       //       top: 1, right: 1),
//           //                       //   child: Column(
//           //                       //     children: [
//           //                       //       Center(
//           //                       //         child: InkWell(
//           //                       //           child: Container(
//           //                       //             width: 122,
//           //                       //             height: 40,
//           //                       //             decoration: BoxDecoration(
//           //                       //                 color:
//           //                       //                     const Color(0xff3A1D8C),
//           //                       //                 borderRadius:
//           //                       //                     BorderRadius.circular(
//           //                       //                         80)),
//           //                       //             child: const Column(
//           //                       //               mainAxisAlignment:
//           //                       //                   MainAxisAlignment.center,
//           //                       //               children: [
//           //                       //                 Center(
//           //                       //                   child: Text(
//           //                       //                     'View Profile',
//           //                       //                     style: TextStyle(
//           //                       //                       fontSize: 14,
//           //                       //                       fontWeight:
//           //                       //                           FontWeight.w500,
//           //                       //                       color: Colors.white,
//           //                       //                     ),
//           //                       //                   ),
//           //                       //                 ),
//           //                       //               ],
//           //                       //             ),
//           //                       //           ),
//           //                       //           onTap: () async {},
//           //                       //         ),
//           //                       //       ),
//           //                       //     ],
//           //                       //   ),
//           //                       // )
//           //                     ],
//           //                   ),
//           //                   // ),
//           //                 ),
//           //                 content: const Text(
//           //                   'Please confirm identity of your friend',
//           //                 ),
//           //                 actions: <Widget>[
//           //                   ElevatedButton(
//           //                     style: ButtonStyle(
//           //                       backgroundColor:
//           //                           MaterialStateProperty.all(Colors.black),
//           //                     ),
//           //                     onPressed: () async {
//           //                       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           //                       //     action: SnackBarAction(
//           //                       //       label: "Ok",
//           //                       //       onPressed: () {},
//           //                       //     ),
//           //                       //     content: const Text("Your Not Home request has been Cancelled ")));
//           //                     },
//           //                     child: const Text('confirm',
//           //                         style: TextStyle(color: Colors.white)),
//           //                   ),
//           //                   ElevatedButton(
//           //                     style: ButtonStyle(
//           //                       backgroundColor:
//           //                           MaterialStateProperty.all(Colors.black),
//           //                     ),
//           //                     onPressed: () {
//           //                       Navigator.of(context)
//           //                           .pop(); // Close the confirmation dialog
//           //                     },
//           //                     child: const Text('reject',
//           //                         style: TextStyle(color: Colors.white)),
//           //                   ),
//           //                 ],
//           //               );
//           //             },
//           //           );
//           //           // }
//           //         },
//           //       );
//           //     })
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/Screens/main/Complaint.dart';
import 'package:testapp/Screens/main/E-Reciept.dart';
import 'package:testapp/Screens/main/Prescription.dart';
import 'package:testapp/global.dart'; // Import your NotificationCounterProvider

class Visitors extends StatefulWidget {
  const Visitors({super.key});

  @override
  _VisitorsState createState() => _VisitorsState();
}

class _VisitorsState extends State<Visitors> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      notification_count = 0;
    }); // Call the function to fetch notifications and update the count
    resetNotificationCount();
    updateAllIsReadStatus(true);
  }

  @override
  Widget build(BuildContext context) {
    final id = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
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
          'Visitors',
          style: TextStyle(
            color: Color(0xff212121),
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('notifications')
            .where('description',
                isEqualTo: "You Have approved your freinds / relative identity")
            // .limit(30)
            // .where("uid", isEqualTo: id)
            // .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          print(id);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Text('Error fetching data');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No notifications available'),
            );
          }

          // Extract the data from the snapshot
          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          List<QueryDocumentSnapshot> newNotifications =
              getNewNotifications(documents);
          List<QueryDocumentSnapshot> earlierNotifications =
              getEarlierNotifications(documents);

          return ListView(
            children: [
              if (newNotifications.isNotEmpty)
                _buildSection('NEW', newNotifications),
              if (earlierNotifications.isNotEmpty)
                _buildSection('EARLIER', earlierNotifications),
            ],
          );
        },
      ),
    );
  }

  List<QueryDocumentSnapshot> getNewNotifications(
    List<QueryDocumentSnapshot> documents,
  ) {
    DateTime currentDate = DateTime.now();
    return documents.where((document) {
      String dateString = document['date'];
      String timeString = document['time'];
      DateTime documentDate = _parseTime(dateString, timeString);
      return documentDate
          .isAfter(currentDate.subtract(const Duration(days: 1)));
    }).toList();
  }

  List<QueryDocumentSnapshot> getEarlierNotifications(
    List<QueryDocumentSnapshot> documents,
  ) {
    DateTime currentDate = DateTime.now();
    return documents.where((document) {
      String dateString = document['date'];
      String timeString = document['time'];
      DateTime documentDate = _parseTime(dateString, timeString);
      return documentDate
          .isBefore(currentDate.subtract(const Duration(days: 1)));
    }).toList();
  }

  // DateTime _parseTime(String timeString) {
  //   DateFormat format = DateFormat.jm();
  //   try {
  //     return format.parse(timeString);
  //   } catch (e) {
  //     // Handle the exception, e.g., return the current time
  //     print('Error parsing time: $e');
  //     return DateTime.now();
  //   }
  // }

  DateTime _parseTime(String dateString, String timeString) {
    try {
      String dateTimeString = '$dateString $timeString';
      DateFormat format = DateFormat('MM/dd/yyyy h:mm:ss a');
      return format.parse(dateTimeString);
    } catch (e) {
      // Handle the exception, e.g., return the current time
      print('Error parsing time: $e');
      return DateTime.now();
    }
  }

  Widget _buildSection(
    String date,
    List<QueryDocumentSnapshot> notifications,
  ) {
    print("notification_count=$notification_count");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var document = notifications[index];
            var title = document['title'];
            var des = document['description'];
            var image = document['image'];
            var ids = document['id'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  onTap: () {
                    if (des.isNotEmpty && des.toString().contains("identity")) {
                      // Show Alert Box
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: SizedBox(
                              height: MediaQuery.of(context).size.height / 3.1,
                              // child: DrawerHeader(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 3,
                                            color: Colors.grey,
                                            spreadRadius: 1)
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/Images/profile-Icon-SVG.jpg'),
                                      radius: 52,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(
                                    top: 10,
                                  )),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'name',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(
                                    top: 5,
                                  )),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'phone number ',
                                      // ${userinfo["email"]}'

                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(
                                    top: 5,
                                  )),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'vehicle number',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 1, right: 1),
                                  //   child: Column(
                                  //     children: [
                                  //       Center(
                                  //         child: InkWell(
                                  //           child: Container(
                                  //             width: 122,
                                  //             height: 40,
                                  //             decoration: BoxDecoration(
                                  //                 color:
                                  //                     const Color(0xff3A1D8C),
                                  //                 borderRadius:
                                  //                     BorderRadius.circular(
                                  //                         80)),
                                  //             child: const Column(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 Center(
                                  //                   child: Text(
                                  //                     'View Profile',
                                  //                     style: TextStyle(
                                  //                       fontSize: 14,
                                  //                       fontWeight:
                                  //                           FontWeight.w500,
                                  //                       color: Colors.white,
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //           onTap: () async {},
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                              // ),
                            ),
                            // content: const Text(
                            //   'Please confirm identity of your friend',
                            // ),
                            // actions: <Widget>[
                            //   ElevatedButton(
                            //     style: ButtonStyle(
                            //       backgroundColor:
                            //           MaterialStateProperty.all(Colors.black),
                            //     ),
                            //     onPressed: () async {
                            //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //       //     action: SnackBarAction(
                            //       //       label: "Ok",
                            //       //       onPressed: () {},
                            //       //     ),
                            //       //     content: const Text("Your Not Home request has been Cancelled ")));
                            //     },
                            //     child: const Text('confirm',
                            //         style: TextStyle(color: Colors.white)),
                            //   ),
                            //   ElevatedButton(
                            //     style: ButtonStyle(
                            //       backgroundColor:
                            //           MaterialStateProperty.all(Colors.black),
                            //     ),
                            //     onPressed: () {
                            //       Navigator.of(context)
                            //           .pop(); // Close the confirmation dialog
                            //     },
                            //     child: const Text('reject',
                            //         style: TextStyle(color: Colors.white)),
                            //   ),
                            // ],
                          );
                        },
                      );
                    }
                    if (des.isNotEmpty &&
                        des.toString().contains("Prescription")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Prescription(
                                    id: ids,
                                  )));
                    }

                    if (des.isNotEmpty && des.toString().contains("Order")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewEReciept(
                                    value: false,
                                    status: "",
                                    id: ids,
                                  )));
                    }
                    if (des.isNotEmpty &&
                        des.toString().contains("Complaint")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Complainform(),
                          ));
                    }
                  },
                  tileColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  leading: Container(
                    height: 100,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Color(0xff2824e5),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      Text(
                        "${document['date'].toString()} at ${document['time'].toString()}",
                        style: const TextStyle(fontSize: 8),
                      )
                    ],
                  ),
                  subtitle: Text(des, maxLines: 2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
