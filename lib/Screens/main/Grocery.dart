import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:badges/badges.dart' as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/Providers/NotificationCounterProvider.dart';
import 'package:com.invoseg.innovation/Screens/main/E-Reciept.dart';
import 'package:com.invoseg.innovation/Screens/main/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/main/drawer.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Grocery extends StatefulWidget {
  const Grocery({super.key});

  @override
  State<Grocery> createState() => _GroceryState();
}

class _GroceryState extends State<Grocery> {
  bool isButtonEnabled = true;
  String GroceryId = "";
  final bool fals = false;
  Future<void> fetchAndModifyGroceryDocuments() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('grocery').get();
      var docs = querySnapshot.docs;
      for (var doc in docs) {
        var canEdit = doc['canEdit'];
        setState(() {
          isButtonEnabled = canEdit;
        }); // Assuming 'canEdit' is the field name
        if (canEdit == true) {
          await doc.reference.update({'canEdit': false});
        }
      }
      print('Documents updated successfully.');
    } catch (e) {
      print('Error updating documents: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllIsReadStatus();
    // This line was already there, updating notification count on page load
    // updateAllIsReadStatus(true);
    // Timer.periodic(const Duration(seconds: 3), (Timer timer) {
    //   getAllIsReadStatus();
    // });
    updateTabs();

    Timer(const Duration(minutes: 5), () {
      fetchAndModifyGroceryDocuments();
    });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  void query(var notificationCounter) {}

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    String uid = "";

    final notificationCounter =
        Provider.of<NotificationCounter>(context, listen: false);
    FirebaseFirestore.instance
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      notificationCounter.updateCount(snapshot.docs.length);
    });
    return Scaffold(
      key: _key,
      drawer: const DrawerWidg(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
          'Grocery',
          style: TextStyle(
            color: Color(0xff212121),
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        actions: <Widget>[
          Consumer<NotificationCounter>(
            builder: (context, counter, child) {
              return IconButton(
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
                                color: Colors
                                    .red, // You can customize the badge color
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 15,
                                minHeight: 15,
                              ),
                              child: Text(
                                "${notificationCounter.count}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      12, // You can customize the font size
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
              );
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
                          // .orderBy("date", descending: true)
                          .where('uid', isEqualTo: userinfo['uid'])
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
                        } else if (grocerySnapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No data available"));
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
                                              if ((groceryData['Status'] ==
                                                          'Processing' ||
                                                      groceryData['Status'] ==
                                                          'processing') &&
                                                  fals == true)
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
                                                      onPressed: () async {
                                                        setState(() {
                                                          isButtonEnabled ==
                                                              groceryDocs[index]
                                                                  ['canEdit'];
                                                        });
                                                        if (
                                                            // groceryDocs[index][
                                                            //           'canEdit'] ==
                                                            //       true &&
                                                            fals == true) {
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
                                                                                    updateEditButton();
                                                                                    alertme("button-three", groceryDocs[index].id);
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
                                                              // value: groceryDocs[
                                                              //         index]
                                                              //     ['canEdit'],
                                                              value: false,
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

  String generateRandomFourDigitCode() {
    Random random = Random();
    int code = random.nextInt(10000);

    // Ensure the code is four digits long (pad with leading zeros if necessary)
    return code.toString().padLeft(4, '0');
  }

  void alertme(String collect, String id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to send Edit request?',
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () async {
              var connectivityResult =
                  await (Connectivity().checkConnectivity());
              print("Connectivity == ${connectivityResult.toString()}");
              if (connectivityResult == ConnectivityResult.none) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content:
                        Text("This Feature is not available in Offline mode")));
              } else {
                try {
                  // EasyLoading.show(status: 'Loading Please Wait');
                  // Attempt to make a GET request to a reliable server
                  final response =
                      await http.get(Uri.parse('https://www.google.com'));
                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    EasyLoading.dismiss();
                    logic(collect, id);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Your Internet connection is not stable.Please try again later")));
                    EasyLoading.dismiss();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Your Internet connection is not stable.Please try again later")));
                  EasyLoading.dismiss();
                }
              }
            },
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void logic(String collect, String id) async {
    // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String FCMtoken = "";
    DateTime now = DateTime.now();
    String documentId;
    String formattedDate = "${now.year}-${now.month}-${now.day}";
    String formattedTime = DateFormat('hh:mm:ss a').format(now);
    String fmName = "", fmphoneNo = "";
    String fmName1 = "", fmphoneNo1 = "";
    String fourDigitCode = generateRandomFourDigitCode();
    bool btnOnOff = false;

    setState(() {
      btnOnOff = false;
    });
    final prefs = await SharedPreferences.getInstance();
    final userinfo = json.decode(prefs.getString('userinfo') as String);
    if (btnOnOff == false) {
      setState(() {
        FCMtoken = prefs.getString('tokens')!;
        btnOnOff = true;
      });
      final mainCollectionQuery = await FirebaseFirestore.instance
          .collection("UserRequest") // Replace with your main collection
          .where("email", isEqualTo: userinfo['email'])
          .get();

      if (mainCollectionQuery.docs.isNotEmpty) {
        mainCollectionQuery.docs.forEach((mainDoc) async {
          final subcollectionRef = mainDoc.reference.collection("FMData");

          final subcollectionQuery = await subcollectionRef
              .where("owner", isEqualTo: userinfo['owner'])
              .get();

          if (subcollectionQuery.docs.isNotEmpty) {
            // Process the first document
            var data = subcollectionQuery.docs[0].data();
            setState(() {
              fmName = data['Name'];
              fmphoneNo = data['phonenumber'];
              print("Document 1 - Name: $fmName, Phone No: $fmphoneNo");
            });

            // Process the second document if it exists
            if (subcollectionQuery.docs.length > 1) {
              var data1 = subcollectionQuery.docs[1].data();
              setState(() {
                fmName1 = data1['Name'];
                fmphoneNo1 = data1['phonenumber'];
                print("Document 2 - Name: $fmName1, Phone No: $fmphoneNo1");
              });
            }

            await FirebaseFirestore.instance.collection(collect).add({
              "edit": true,
              "name": userinfo["name"],
              "phoneNo": userinfo["phoneNo"],
              "address": userinfo["address"],
              "fmphoneNo": fmphoneNo,
              "fmphoneNo1": fmphoneNo1,
              "fname": userinfo['fname'],
              "fPhoneNo": userinfo['fphoneNo'],
              "fmName": fmName,
              "fmName1": fmName1,
              "designation": userinfo["designation"],
              "age": userinfo["age"],
              "pressedTime": FieldValue.serverTimestamp(),
              "type": collect,
              "isProcessed": false,
              "time": formattedTime,
              "date": formattedDate,
              // "FM${num}": userinfo["FM${num}"],
              "uid": userinfo["uid"],
              "owner": userinfo["owner"],
              "email": userinfo["email"],
              "noti": true,
              "residentID": "Invoseg$fourDigitCode",
              "FCMtoken": FCMtoken
            }).then((DocumentReference document) => {
                  documentId = document.id,
                  print("DOCUMENT ID +++++++ $documentId"),
                });
            FirebaseFirestore.instance.collection("UserButtonRequest").add({
              "type": collect,
              "uid": userinfo["uid"],
              "pressedTime": FieldValue.serverTimestamp(),
            });
            canEdit(id);
            popAndSnackBar();
          } else {
            print("No matching documents found in the Sub collection.");
            await FirebaseFirestore.instance.collection(collect).add({
              "name": userinfo["name"],
              "phoneNo": userinfo["phoneNo"],
              "address": userinfo["address"],
              "fmphoneNo": "",
              "fname": userinfo['fname'],
              "fPhoneNo": userinfo['fphoneNo'],
              "fmName": "",
              "designation": userinfo["designation"],
              "age": userinfo["age"],
              "pressedTime": FieldValue.serverTimestamp(),
              "type": collect,
              "isProcessed": false,
              "time": formattedTime,
              "date": formattedDate,
              // "FM${num}": userinfo["FM${num}"],
              "uid": userinfo["uid"],
              "owner": userinfo["owner"],
              "email": userinfo["email"],
              "noti": true,
              "residentID": "Invoseg$fourDigitCode",
              "FCMtoken": FCMtoken
            }).then((DocumentReference document) => {
                  documentId = document.id,
                  print("DOCUMENT ID +++++++ $documentId")
                });
            FirebaseFirestore.instance.collection("UserButtonRequest").add({
              "type": collect,
              "uid": userinfo["uid"],
              "pressedTime": FieldValue.serverTimestamp(),
            });
            canEdit(id);
            popAndSnackBar();
          }
        });
      } else {
        print("No matching documents found in the main collection.");
      }
    } else {}
  }

  void popAndSnackBar() {
    Navigator.pop(context);
    Navigator.pop(context);

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

  Future<void> canEdit(String id) async {
    await FirebaseFirestore.instance
        .collection('grocery')
        .doc(id)
        .update({'canEdit': false, 'Status': 'Delivered'});
  }
}
