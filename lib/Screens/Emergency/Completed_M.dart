// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:badges/badges.dart' as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/Prescription.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://meet.google.com/gdj-uuof-qvm');

class Completed_M extends StatefulWidget {
  @override
  State<Completed_M> createState() => Completed_M_State();
}

class Completed_M_State extends State<Completed_M> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String manuallySpecifiedUID = "cIBVfkQgw5oFdKXZq4bM";
  String status = "";
  String meetingId = "";

  Future<void> _fetchConsultationData() async {
    try {
      DocumentSnapshot consultationSnapshot = await _firestore
          .collection('consultation')
          .doc(manuallySpecifiedUID)
          .get();

      if (consultationSnapshot.exists) {
        var consultationData =
            consultationSnapshot.data() as Map<String, dynamic>;

        if (consultationData != null) {
          // Access the "doctor" field and its nested fields
          var doctorData = consultationData['doctor'] as Map<String, dynamic>;

          if (doctorData != null) {
            setState(() {
              meetingId = doctorData['meetingId'];
              status = consultationData['meetingStatus'];
            });

            // Now you have the status and meetingId within the doctor's field
            print('Status: $status');
            print('Meeting ID: $meetingId');
          } else {
            print('Doctor data is null');
          }
        } else {
          print('Consultation data is null');
        }
      } else {
        print('Consultation document does not exist');
      }
    } catch (e) {
      print('Error fetching consultation data: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _fetchConsultationData();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl() async {
      String url = "https://meet.google.com/gdj-uuof-qvm";
      if (url.contains("zoom.us")) {
        // Open the Zoom link
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          print("Could not launch Zoom link");
        }
      } else if (url.contains("meet.google.com")) {
        // Open the Google Meet link
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          print("Could not launch Google Meet link");
        }
      } else {
        print("Unsupported link");
      }
    }

    List EmergencyOrders = [
      // {'DateTime': 'Dec 22, 2024 - 10:00 AM', 'Status': 'Link Generated'},
      {'DateTime': 'Dec 08, 2024 - 15:00 PM', 'Status': status}
    ];
    if (status == 'Completed' || status == 'completed') {
      return Container(
        child: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var userinfo =
                    json.decode(snapshot.data.getString('userinfo') as String);

                return Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: EmergencyOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.white,
                            shadowColor: Color(0xffBDBDBD),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        EmergencyOrders[index]['DateTime'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      badge.Badge(
                                          toAnimate: false,
                                          shape: badge.BadgeShape.square,
                                          badgeColor: EmergencyOrders[index]
                                                      ['Status'] ==
                                                  status
                                              ? Colors.green
                                              : Colors.blueGrey,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          badgeContent: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: Text(
                                              EmergencyOrders[index]['Status'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
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
                                      style: TextStyle(
                                          color: Color(0xff212121),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userinfo['address'],
                                        style: TextStyle(
                                            color: Color(0xff757575),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (EmergencyOrders[index]['Status'] ==
                                          'Link Generated')
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                            width: EmergencyOrders[index]
                                                        ['Status'] ==
                                                    'Link Generated'
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.7,
                                            child: ElevatedButton(
                                              child: Text('Start Meeting',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black)),
                                              onPressed: () {
                                                _launchUrl();
                                                // ScaffoldMessenger.of(context)
                                                //     .showSnackBar(
                                                //   SnackBar(
                                                //     content: Text(
                                                //       "Meeting Link Copied Successfully! ",
                                                //       style: TextStyle(
                                                //           color: Colors.black),
                                                //     ),
                                                //     action: SnackBarAction(
                                                //         label: 'OK',
                                                //         textColor: Colors.black,
                                                //         onPressed: () {}),
                                                //     backgroundColor:
                                                //         Colors.grey[400],
                                                //   ),
                                                // );
                                              },
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0),
                                                  )),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20))),
                                            ),
                                          ),
                                        ),
                                      if (EmergencyOrders[index]['Status'] ==
                                              'completed' ||
                                          EmergencyOrders[index]['Status'] ==
                                              'Completed')
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                            width: EmergencyOrders[index]
                                                        ['Status'] ==
                                                    status
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.3
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.7,
                                            child: ElevatedButton(
                                              child: Text('View Prescription',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white)),
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    Prescription.routename);
                                              },
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    side: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0),
                                                  )),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20))),
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
                      }),
                );
              } else
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
            }),
      );
    } else {
      return Scaffold(
        body: Center(
            child: Text(
          "No Completed Meetings Are Available",
          style: TextStyle(color: Colors.black),
        )),
      );
    }
  }
}
