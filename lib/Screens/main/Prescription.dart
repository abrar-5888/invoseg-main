import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prescription extends StatefulWidget {
  static const routename = 'Prescription';

  var id;
  Prescription({super.key, required this.id});

  @override
  State<Prescription> createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  String date = "", time = "", doctorName = "";
  Future<void> fetchDateAndTime() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('consultation')
        .doc(widget.id)
        .get();

    var data = documentSnapshot.data() as Map<String, dynamic>;
    print("Datatatatatattatatatatatatata===========$data");
    setState(() {
      date = data['date'];
      time = data['time'];
      doctorName = data['doctorName'];
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String manuallySpecifiedUID = "";
  @override
  void initState() {
    super.initState();
    manuallySpecifiedUID = widget.id;
    fetchDateAndTime();
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
            icon: const Icon(Icons.arrow_back_ios_new)),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        foregroundColor: const Color(0xff212121),
        title: const Text(
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
              physics: const BouncingScrollPhysics(),
              child: Container(
                  height: MediaQuery.of(context).size.height / 1.1,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.white,
                          shadowColor: const Color(0xffBDBDBD),
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
                                      const Text(
                                        'Patient Name',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["name"],
                                        style: const TextStyle(
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
                                      const Text(
                                        'Address',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["address"] ?? "OKA",
                                        style: const TextStyle(
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
                                      const Text(
                                        'Phone',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["phoneNo"],
                                        style: const TextStyle(
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
                                      const Text(
                                        'Doctor Name',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        doctorName,
                                        style: const TextStyle(
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
                                      const Text(
                                        'Consultation Date',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        date,
                                        style: const TextStyle(
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
                                      const Text(
                                        'Consultation Hours',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        time,
                                        style: const TextStyle(
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
                          shadowColor: const Color(0xffBDBDBD),
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
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return const Text("No data available.");
                              } else {
                                Map<String, dynamic>? patientsData =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>?;

                                if (patientsData == null ||
                                    !patientsData.containsKey('patient')) {
                                  print("Item = $patientsData");
                                  return const Text(
                                      "Patients data not available.");
                                }

                                Map<String, dynamic> patientMap =
                                    patientsData['patient']
                                        as Map<String, dynamic>;
                                // List<dynamic> patients =
                                //     patientsData['patient'] ?? [];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
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
                                            style: const TextStyle(
                                                color: Color(0xff212121),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
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
                                            style: const TextStyle(
                                                color: Color(0xff212121),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
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
                                            style: const TextStyle(
                                                color: Color(0xff212121),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
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
                                            style: const TextStyle(
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
