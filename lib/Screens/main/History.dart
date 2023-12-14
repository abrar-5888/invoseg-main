import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/main/Notifications.dart';
import 'package:testapp/Screens/main/drawer.dart';
import 'package:testapp/global.dart';

class ButtonsHistory extends StatefulWidget {
  static const routename = 'history';
  const ButtonsHistory({Key? key}) : super(key: key);

  @override
  State<ButtonsHistory> createState() => _ButtonsHistoryState();
}

class _ButtonsHistoryState extends State<ButtonsHistory> {
  @override
  void initState() {
    // TODO: implement initState
    // history_count = 0;
    // getAllIsReadStatus();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const DrawerWidg(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 8.0),
        //   child: Image(
        //     image: AssetImage('assets/Images/rehman.png'),
        //     height: 60,
        //     width: 60,
        //   ),
        // ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: const Text(
          'History',
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
                        "$notification_count",
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
              // resetNotificationCount();

              setState(() {
                notification_count = 0;
              });
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
                _key.currentState!.openDrawer();
              },
            ),
          ),
          // ElevatedButton(
          //   onPressed: () => {},
          //   style: ButtonStyle(
          //     backgroundColor:
          //         MaterialStateProperty.all(Colors.greenAccent),
          //   ),
          //   child: FittedBox(
          //       fit: BoxFit.cover,
          //       child: Text(
          //         'Logout',
          //         style: TextStyle(
          //             color: Colors.teal[900],
          //             fontWeight: FontWeight.bold),
          //       )),
          // ),
        ],
      ),
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var userinfo =
                  json.decode(snapshot.data.getString('userinfo') as String);
              final myListData = [
                userinfo["uid"],
              ];
              return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("UserButtonRequest")
                      .where("uid", isEqualTo: myListData[0])
                      // .snapshots(includeMetadataChanges: true),
                      .limit(30)
                      .get(),
                  builder: (context, snp) {
                    if (snp.hasError) {
                      print(snp);
                      return const Center(
                        child: Text("No Data is here"),
                      );
                    } else if (snp.hasData || snp.data != null) {
                      return snp.data!.docs.isEmpty
                          ? Center(
                              child: Container(child: const Text("No Record")))
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: snp.data!.docs.length,
                              itemBuilder: (ctx, i) {
                                final sortedDocs = snp.data!.docs.toList()
                                  ..sort((a, b) {
                                    final timestampA =
                                        a['pressedTime'].toDate() as DateTime;
                                    final timestampB =
                                        b['pressedTime'].toDate() as DateTime;
                                    return timestampB.compareTo(
                                        timestampA); // Sort in descending order
                                  });

                                final doc = sortedDocs[i];

                                return Container(
                                  // color: Colors.blue,
                                  child: ButtonsHistoryBody(doc),
                                );
                              },
                            );
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            }
          }),
    );
  }
}

class ButtonsHistoryBody extends StatefulWidget {
  final comp;
  const ButtonsHistoryBody(this.comp, {super.key});
  @override
  State<ButtonsHistoryBody> createState() => _ButtonsHistoryBodyState();
}

class _ButtonsHistoryBodyState extends State<ButtonsHistoryBody> {
  String formatDateFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd')
        .format(date); // You can change the format as needed
    return formattedDate;
  }

  String formatTimeFromTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    String formattedTime = DateFormat('HH:mm:ss')
        .format(date); // You can change the format as needed
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    Timestamp timestamp1 = widget.comp.data()['pressedTime'];
    String time = formatTimeFromTimestamp(timestamp1);
    print(time); // Prints the formatted time

    // String time = widget.comp.data()['pressedTime'].toDate().toString();
    Timestamp timestamp = widget.comp.data()['pressedTime'];
    String date = formatDateFromTimestamp(timestamp);
    print(date); // Prints the formatted date

    return Container(
      //  color: Color.fromARGB(255, 112, 9, 9),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child:

              //  Material(
              //   color: Color.fromARGB(55, 255, 255, 255),
              //   // shadowColor: Color(0xffBDBDBD),
              //   //   elevation: 5,
              //   shape:
              //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //   child: Padding(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              //       child:

              Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(236, 238, 240, 1),
              //  color: Color(0xffd9d9d9),
              //    border: Border.all(width: 1, color: Color(0xffd9d9d9))
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                //   tileColor: const Color.fromARGB(255, 59, 47, 47),
                leading: widget.comp.data()['type'] == 'button-one'
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffd9d9d9),

                            //    color: Color.fromARGB(255, 189, 183, 183),
                            border: Border.all(
                                width: 1, color: const Color(0xffd9d9d9))),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            //   Icons.local_grocery_store_sharp,
                            Icons.security,
                            color: Color(0xff2824e5),
                          ),
                        ),
                      )
                    : widget.comp.data()['type'] == 'button-two'
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffd9d9d9),

                                //    color: Color.fromARGB(255, 189, 183, 183),
                                border: Border.all(
                                    width: 1, color: const Color(0xffd9d9d9))),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.medical_services,
                                color: Color(0xff2824e5),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xffd9d9d9),

                                //    color: Color.fromARGB(255, 189, 183, 183),
                                border: Border.all(
                                    width: 1, color: const Color(0xffd9d9d9))),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.local_grocery_store_sharp,
                                color: Color(0xff2824e5),
                              ),
                            ),
                          ),

                //           widget.comp.data()['type'] == 'button-two'
                //               ?  Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Color(0xffd9d9d9),

                //       //    color: Color.fromARGB(255, 189, 183, 183),
                //       border: Border.all(width: 1, color: Color(0xffd9d9d9))),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Icon(
                //       Icons.local_grocery_store_sharp,
                //       color: Color(0xff2824e5),
                //     ),
                //   ),
                // ):

                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10),
                //       color: Color(0xffd9d9d9),

                //       //    color: Color.fromARGB(255, 189, 183, 183),
                //       border: Border.all(width: 1, color: Color(0xffd9d9d9))),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Icon(
                //       Icons.local_grocery_store_sharp,
                //       color: Color(0xff2824e5),
                //     ),
                //   ),
                // ),
                //  ClipRRect(
                //     borderRadius: BorderRadius.circular(12),
                //     child: Image(
                //         width: 50,
                //         height: 50,
                //         fit: BoxFit.cover,
                //         image: widget.comp.data()['type'] == 'button-one'
                //             ? AssetImage('assets/Images/Security.jpg')
                //             : widget.comp.data()['type'] == 'button-two'
                //                 ? AssetImage('assets/Images/Doctor.jpg')
                //                 : AssetImage('assets/Images/Grocery.avif'))),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comp.data()['type'] == 'button-one'
                          ? 'SECURITY'
                          : widget.comp.data()['type'] == 'button-two'
                              ? 'EMERGENCY'
                              : 'GROCERY',
                      style: const TextStyle(
                          color: Color(0xff212121),
                          fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      'You have purchased grocery item on monday at 16:02:12 ',
                      style: TextStyle(fontSize: 13, color: Color(0xff757272)),
                    )
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 11),
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                              color: Color.fromARGB(172, 0, 0, 0),
                              fontWeight: FontWeight.w400,
                              fontSize: 11),
                        ),
                      ],
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Color.fromARGB(255, 240, 134, 134),
                    //       border:
                    //           Border.all(width: 1, color: Color(0xffd9d9d9))),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Icon(
                    //       Icons.delete,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    // Text(
                    //   'data',
                    //   style: TextStyle(
                    //       color: Color(0xff757575),
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 12),
                    // ),
                  ],
                ),
              ),
            ),
          )

          //Material
          //       ),
          // ),

          ),
    );
  }
}

// ListTile(
//   //   tileColor: const Color.fromARGB(255, 59, 47, 47),
//   leading: ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Image(
//           width: 50,
//           height: 50,
//           fit: BoxFit.cover,
//           image: widget.comp.data()['type'] == 'button-one'
//               ? AssetImage('assets/Images/Security.jpg')
//               : widget.comp.data()['type'] == 'button-two'
//                   ? AssetImage('assets/Images/Doctor.jpg')
//                   : AssetImage('assets/Images/Grocery.avif'))),
//   title: Column(
//     children: [
//       Text(
//         widget.comp.data()['type'] == 'button-one'
//             ? 'SECURITY'
//             : widget.comp.data()['type'] == 'button-two'
//                 ? 'EMERGENCY'
//                 : 'GROCERY',
//         style: TextStyle(
//             color: Color(0xff212121),
//             fontWeight: FontWeight.w700),
//       ),
//     ],
//   ),
//   subtitle: Text(
//     widget.comp.data()['pressedTime'].toDate().toString(),
//     style: TextStyle(
//         color: Color(0xff757575),
//         fontWeight: FontWeight.w500,
//         fontSize: 12),
//   ),
// )
