import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart' as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/main/E-Reciept.dart';
import 'package:testapp/Screens/main/Notifications.dart';
import 'package:testapp/Screens/main/drawer.dart';
import 'package:testapp/global.dart';

class Grocery extends StatefulWidget {
  const Grocery({super.key});

  @override
  State<Grocery> createState() => _GroceryState();
}

class _GroceryState extends State<Grocery> {
  bool isButtonEnabled = true;
  String GroceryId = "";

  @override
  void initState() {
    super.initState();
    // This line was already there, updating notification count on page load
    // updateAllIsReadStatus(true);
    getAllIsReadStatus();

    GroceryId = "";
    Timer(const Duration(minutes: 5), () {
      setState(() {
        isButtonEnabled = false;
      });
    });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = "";

    return Scaffold(
      key: _key,
      drawer: const DrawerWidg(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Image(
            image: AssetImage('assets/Images/rehman.png'),
            height: 50,
            width: 50,
          ),
        ),
        title: const Text(
          'Grocery',
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
        ],
      ),
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // Decode user info from SharedPreferences
              var userinfo =
                  json.decode(snapshot.data.getString('userinfo') as String);
              if (user != null) {
                uid = user.uid;
              }
              return Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("grocery")
                          .orderBy("date", descending: true)
                          .limit(30)
                          .get(),
                      // .where('uid',isEqualTo:uid )
                      builder: (context, grocerySnapshot) {
                        if (grocerySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          );
                        } else if (grocerySnapshot.hasError) {
                          return Text("Error: ${grocerySnapshot.error}");
                        } else {
                          final groceryDocs = grocerySnapshot.data!.docs;
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: groceryDocs.length,
                              itemBuilder: (BuildContext context, int index) {
                                final groceryData = groceryDocs[index].data()
                                    as Map<String, dynamic>;

                                // Get the current document ID

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Material(
                                    color: Colors.white,
                                    shadowColor: const Color(0xffBDBDBD),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${groceryData['date']} ",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              badge.Badge(
                                                  toAnimate: false,
                                                  shape:
                                                      badge.BadgeShape.square,
                                                  badgeColor: groceryData[
                                                              'Status'] ==
                                                          'Deliverd'
                                                      ? const Color.fromRGBO(
                                                          15, 39, 127, 1)
                                                      : const Color.fromRGBO(
                                                          15, 39, 127, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  badgeContent: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0),
                                                    child: Text(
                                                      groceryData['Status'],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Text(
                                              userinfo['name'],
                                              style: const TextStyle(
                                                  color: Color(0xff212121),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userinfo['address'] ?? "OKA",
                                                style: const TextStyle(
                                                    color: Color(0xff757575),
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (groceryData['Status'] ==
                                                      'Processing' ||
                                                  groceryData['Status'] ==
                                                      'processing')
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.7,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (isButtonEnabled ==
                                                            true) {
                                                          showModalBottomSheet(
                                                              context: context,
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            25.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            25.0)),
                                                              ),
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Container(
                                                                  decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              25.0),
                                                                          topRight:
                                                                              Radius.circular(25.0))),
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height /
                                                                      2.4,
                                                                  child: Column(
                                                                    children: [
                                                                      const Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                            vertical:
                                                                                20),
                                                                        child:
                                                                            Text(
                                                                          'Edit Order',
                                                                          style: TextStyle(
                                                                              color: Color(0xffF75555),
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 24),
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16),
                                                                        child:
                                                                            Divider(
                                                                          thickness:
                                                                              1,
                                                                          color:
                                                                              Color(0xffEEEEEE),
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          'Are you sure you want to send request for edit your order?',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              color: Color(0xff212121),
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 24),
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                            vertical:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          'You can request for edit your order within 5 minutes after the E-Reciept generated.',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              color: Color(0xff424242),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 16),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: SizedBox(
                                                                                width: MediaQuery.of(context).size.width / 2.4,
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  style: ButtonStyle(
                                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(100),
                                                                                      )),
                                                                                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 216, 225, 235)),
                                                                                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20))),
                                                                                  child: const Text('Cancel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                              child: SizedBox(
                                                                                width: MediaQuery.of(context).size.width / 2.4,
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {
                                                                                    alertme("edit");
                                                                                  },
                                                                                  style: ButtonStyle(
                                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(100),
                                                                                        side: const BorderSide(color: Colors.black, width: 2.0),
                                                                                      )),
                                                                                      backgroundColor: MaterialStateProperty.all(Colors.black),
                                                                                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20))),
                                                                                  child: const Text('Yes, Send Request', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              });
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: const Text(
                                                                  "Sorry! You can't edit your order now!"),
                                                              action:
                                                                  SnackBarAction(
                                                                label: "OK",
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      style: ButtonStyle(
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            side:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 2.0),
                                                          )),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white),
                                                          padding: MaterialStateProperty
                                                              .all(const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20))),
                                                      child: const Text(
                                                          'Edit Order',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: SizedBox(
                                                  width: groceryData[
                                                              'Status'] ==
                                                          'Deliverd'
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2.7,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        GroceryId =
                                                            groceryDocs[index]
                                                                .id;
                                                      });
                                                      // fetchStatus(groceryData['status']);
                                                      print(
                                                          "ID =  ${groceryDocs[index].id}");
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewEReciept(
                                                              value:
                                                                  isButtonEnabled,
                                                              id: groceryDocs[
                                                                      index]
                                                                  .id,
                                                              status:
                                                                  groceryData[
                                                                      'Status'],
                                                            ),
                                                          ));
                                                    },
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          side:
                                                              const BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          15,
                                                                          39,
                                                                          127,
                                                                          1),
                                                                  width: 0.0),
                                                        )),
                                                        backgroundColor:
                                                            MaterialStateProperty.all(
                                                                const Color.fromRGBO(
                                                                    15,
                                                                    39,
                                                                    127,
                                                                    1)),
                                                        padding:
                                                            MaterialStateProperty.all(
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20))),
                                                    child: const Text(
                                                        'View E-Reciept',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      }));
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

  void alertme(String collect) async {
    final prefs = await SharedPreferences.getInstance();
    final userinfo = json.decode(prefs.getString('userinfo') as String);
    await FirebaseFirestore.instance.collection(collect).add({
      "name": userinfo["name"],
      "phoneNo": userinfo["phoneNo"],
      "address": userinfo["address"],
      "pressedTime": FieldValue.serverTimestamp(),
      "type": collect,
      "uid": userinfo["uid"],
      "email": userinfo["email"]
    });

    FirebaseFirestore.instance.collection("EditButtonRequest").add({
      "type": collect,
      "uid": userinfo["uid"],
      "pressedTime": FieldValue.serverTimestamp(),
    });
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Your Request is sent",
          style: TextStyle(color: Colors.black),
        ),
        action: SnackBarAction(
            label: 'OK', textColor: Colors.black, onPressed: () {}),
        backgroundColor: Colors.grey[400],
      ),
    );
  }
}
