import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.invoseg.innovation/Screens/main/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/main/Prescription.dart';
import 'package:com.invoseg.innovation/Screens/main/drawer.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://meet.google.com/gdj-uuof-qvm');

class Emergency extends StatefulWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  final GlobalKey<ScaffoldState> _key1 = GlobalKey();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String manuallySpecifiedUID = "cIBVfkQgw5oFdKXZq4bM";
  String status = "";
  String meetingId = "";

  Future<void> _fetchConsultationData() async {
    try {
      DocumentSnapshot consultationSnapshot = await _firestore
          .collection('consultation')
          .doc("zh6pwQifLb1BROODw4bn")
          .get();

      if (consultationSnapshot.exists) {
        var consultationData =
            consultationSnapshot.data() as Map<String, dynamic>;

        // Access the "doctor" field and its nested fields
        var doctorData = consultationData['doctor'] as Map<String, dynamic>;

        setState(() {
          meetingId = doctorData['meetingId'];
          status = consultationData['meetingStatus'];
        });

        // Now you have the status and meetingId within the doctor's field
        print('Status: $status');
        print('Meeting ID: $meetingId');
      } else {
        print('Consultation document does not exist');
      }
    } catch (e) {
      print('Error fetching consultation data: $e');
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  String uid = "";

  @override
  void initState() {
    super.initState();
    _fetchConsultationData();
    getAllIsReadStatus();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> launchUrls(String url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }

    List EmergencyOrders = [
      // {'DateTime': 'Dec 22, 2024 - 10:00 AM', 'Status': 'Link Generated'},
      {
        'DateTime': 'Dec 08, 2024 - 15:00 PM',
        'Status': status,
      }
    ];
    return Scaffold(
      key: _key1,
      drawer: const DrawerWidg(),
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
          'Medical',
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
                _key1.currentState!.openDrawer();
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
              uid = user!.uid;
            }
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 1.2,
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("consultation")
                    // .orderBy('time', descending: true)
                    .where('uid', isEqualTo: userinfo['uid'])
                    .limit(30)
                    .get(),
                builder: (context, consultationSnapshot) {
                  if (consultationSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    );
                  } else if (consultationSnapshot.hasError) {
                    return Text("Error: ${consultationSnapshot.error}");
                  } else if (consultationSnapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No data available"));
                  } else {
                    final consultationDocs = consultationSnapshot.data!.docs;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: consultationDocs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final consultationData = consultationDocs[index].data()
                            as Map<String, dynamic>;
                        final consultationId = consultationDocs[index].id;

                        var doctorData =
                            consultationData['doctor'] as Map<String, dynamic>;

                        // Now the documents are sorted by "meetingStatus"
                        // Documents with "link generated" status will appear at the top
                        // You can access the "meetingStatus" field as needed
                        String meetingStatus =
                            consultationData['meetingStatus'];
                        String meetingID = doctorData["meetingId"];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white,
                            shadowColor: const Color(0xffBDBDBD),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            // consultationData['DateTime'],
                                            "Meetings",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            // consultationData['DateTime'],
                                            consultationData['date'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                15, 39, 127, 1),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            // consultationData['DateTime'],
                                            consultationData['meetingStatus'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // You can display status here
                                      // using consultationData['Status']
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
                                        fontWeight: FontWeight.w700,
                                      ),
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
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (consultationData['meetingStatus'] ==
                                          'Link Generated')
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (meetingID
                                                    .contains("meet")) {
                                                  launch(meetingID);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: const Text(
                                                        "Meeting link expired.Please request a new one"),
                                                    action: SnackBarAction(
                                                        label: 'ok',
                                                        onPressed: () {}),
                                                  ));
                                                }
                                              },
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                      width: 0.0,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  const Color.fromRGBO(
                                                      15, 39, 127, 1),
                                                ),
                                                padding:
                                                    MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                ),
                                              ),
                                              child: const Text(
                                                'Start Meeting',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (consultationData['meetingStatus'] ==
                                          'Meeting Held')
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Navigate to view prescription screen
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Prescription(
                                                                id: consultationDocs[
                                                                        index]
                                                                    .id)));
                                              },
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    side: const BorderSide(
                                                      color: Colors.black,
                                                      width: 0.0,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  const Color.fromRGBO(
                                                      15, 39, 127, 1),
                                                ),
                                                padding:
                                                    MaterialStateProperty.all(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                ),
                                              ),
                                              child: const Text(
                                                'View Prescription',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          }
        },
      ),
    );
  }
}
