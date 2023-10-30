import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prescription extends StatefulWidget {
  static final routename = 'Prescription';

  var id;
  Prescription({required this.id});

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String manuallySpecifiedUID = "";
  @override
  void initState() {
    super.initState();
    manuallySpecifiedUID = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        foregroundColor: Color(0xff212121),
        title: Text(
          'Doctor\'s Prescription',
          style: TextStyle(
              color: Color(0xff212121),
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
      ),
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot snapshot) {
            var userinfo =
                json.decode(snapshot.data.getString('userinfo') as String);
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                  height: MediaQuery.of(context).size.height / 1.1,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.white,
                          shadowColor: Color(0xffBDBDBD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Patient Name',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["name"],
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Address',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["address"] ?? "OKA",
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Phone',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["phoneNo"],
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Doctor Name',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Dr. Zahid Mehmood',
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Consultation Date',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'December 23, 2024',
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Consultation Hours',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '10:00 AM',
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.white,
                          shadowColor: Color(0xffBDBDBD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: FutureBuilder<DocumentSnapshot>(
                            future: _firestore
                                .collection("consultation")
                                .doc(manuallySpecifiedUID)
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return Text("No data available.");
                              } else {
                                Map<String, dynamic>? patientsData =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>?;

                                if (patientsData == null ||
                                    !patientsData.containsKey('patient')) {
                                  print("Item = ${patientsData}");
                                  return Text("Patients data not available.");
                                }

                                Map<String, dynamic> patientMap =
                                    patientsData['patient']
                                        as Map<String, dynamic>;
                                // List<dynamic> patients =
                                //     patientsData['patient'] ?? [];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            'Disease',
                                            style: TextStyle(
                                                color: Color(0xff616161),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            patientMap['disease'] ??
                                                'No disease found',
                                            style: TextStyle(
                                                color: Color(0xff212121),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            'Medicines',
                                            style: TextStyle(
                                                color: Color(0xff616161),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            patientMap['medicine'] ??
                                                'No medicines specified',
                                            style: TextStyle(
                                                color: Color(0xff212121),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            'Test Needed',
                                            style: TextStyle(
                                                color: Color(0xff616161),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            patientMap['testNeeded'] ??
                                                'No test needed',
                                            style: TextStyle(
                                                color: Color(0xff212121),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            'Things to follow',
                                            style: TextStyle(
                                                color: Color(0xff616161),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Text(
                                            patientMap['thingsToDo'] ??
                                                'No instructions specified',
                                            style: TextStyle(
                                                color: Color(0xff212121),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
