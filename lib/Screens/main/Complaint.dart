import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complainform extends StatefulWidget {
  const Complainform({Key? key}) : super(key: key);
  static const routename = 'Complaint';

  @override
  State<Complainform> createState() => _ComplainformState();
}

class _ComplainformState extends State<Complainform> {
  CollectionReference complain =
      FirebaseFirestore.instance.collection("complian");
  bool show_res = false;
  TextEditingController complian = TextEditingController();
  var name;
  int myVariable = 0;
  DateTime lastUpdateTime = DateTime.now();
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Initialize and set up the timer in the initState method
    timer = Timer.periodic(const Duration(hours: 24), (timer) {
      if (DateTime.now().difference(lastUpdateTime).inHours >= 24) {
        // Reset the variable to 0
        setState(() {
          myVariable = 0;
          lastUpdateTime = DateTime.now();
          print("Variable reset to 0 after 24 hours.");
        });
      }
    });

    // Simulate the passage of time (for testing purposes)
    simulatePassageOfTime(myVariable, lastUpdateTime);
  }

  // Simulate the passage of time for testing purposes
  void simulatePassageOfTime(int myVariable, DateTime lastUpdateTime) {
    // For testing, you can call this function and pass some time
    // For example, simulate 23 hours and 30 minutes passing
    DateTime simulatedNow =
        lastUpdateTime.add(const Duration(hours: 23, minutes: 30));

    // Update the variable and timestamp accordingly
    if (simulatedNow.difference(lastUpdateTime).inHours >= 24) {
      setState(() {
        myVariable = 0;
        lastUpdateTime = simulatedNow;
        print("Variable reset to 0 after 24 hours (simulated).");
      });
    }

    // Print the current state
    print(
        "Current state: Variable=$myVariable, Last Update Time=$lastUpdateTime");
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    super.dispose();
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
            'Submit Complaints',
            style: TextStyle(
                color: Color(0xff212121),
                fontWeight: FontWeight.w700,
                fontSize: 20),
          ),
        ),
        body: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot snapshot) {
              String fmphoneNo = "", fmName = "", fmphoneNo1 = "", fmName1 = "";
              var userinfo =
                  json.decode(snapshot.data.getString('userinfo') as String);
              final myListData = [
                userinfo["name"],
                userinfo["phoneNo"],
                userinfo["address"],
                userinfo["fphoneNo"],
                userinfo["fname"],
                userinfo["designation"],
                userinfo["age"],
                userinfo["uid"],
                userinfo["owner"],
                userinfo["email"]
              ];
              return Container(
                  color: Colors.white,
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Set it to start (top)
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                child: Icon(
                                  Icons.feedback_outlined,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                height: 10.0,
                                width: 1.0,
                                color: Colors.grey.withOpacity(0.5),
                                margin: const EdgeInsets.only(
                                    left: 00.0, right: 10.0),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: complian,
                                  onChanged: (val) {
                                    setState(() {
                                      name = val;
                                    });
                                  },
                                  keyboardType: TextInputType.name,
                                  maxLines: 5,
                                  // textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    labelText: 'Enter Complaint',
                                    border: InputBorder.none,
                                    hintText: 'Enter your Complaint',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 10),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Complain required!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.1,
                        height: 50,
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (myVariable == 5) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Sorry, you have reached the limit for submitting complaints. "
                                      "Please try again later or contact our support team for assistance.",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    backgroundColor: Colors
                                        .red, // Customize the background color if needed
                                  ),
                                );
                              } else {
                                final FirebaseMessaging firebaseMessaging =
                                    FirebaseMessaging.instance;
                                String FCMtoken = "";
                                await firebaseMessaging
                                    .getToken()
                                    .then((String? token) {
                                  if (token != null) {
                                    setState(() {
                                      FCMtoken = token;
                                    });

                                    print("FCM Token: $FCMtoken");
                                  } else {
                                    print("Unable to get FCM token");
                                  }
                                });
                                final mainCollectionQuery = await FirebaseFirestore
                                    .instance
                                    .collection(
                                        "UserRequest") // Replace with your main collection
                                    .where("email",
                                        isEqualTo: userinfo['email'])
                                    .get();
                                if (mainCollectionQuery.docs.isNotEmpty) {
                                  mainCollectionQuery.docs
                                      .forEach((mainDoc) async {
                                    final subcollectionRef =
                                        mainDoc.reference.collection("FMData");

                                    final subcollectionQuery =
                                        await subcollectionRef
                                            .where("owner",
                                                isEqualTo: userinfo['owner'])
                                            .get();

                                    if (subcollectionQuery.docs.isNotEmpty) {
                                      // Process the first document
                                      var data =
                                          subcollectionQuery.docs[0].data();
                                      setState(() {
                                        fmName = data['Name'];
                                        fmphoneNo = data['Phoneno'];
                                        print(
                                            "Document 1 - Name: $fmName, Phone No: $fmphoneNo");
                                      });

                                      // Process the second document if it exists
                                      if (subcollectionQuery.docs.length > 1) {
                                        var data1 =
                                            subcollectionQuery.docs[1].data();
                                        setState(() {
                                          fmName1 = data1['Name'];
                                          fmphoneNo1 = data1['Phoneno'];
                                          print(
                                              "Document 2 - Name: $fmName1, Phone No: $fmphoneNo1");
                                        });
                                      }

                                      String compla = complian.text.trim();
                                      complain.add({
                                        'complain': compla,
                                        'noti': true,
                                        'fmName': fmName,
                                        'fmphoneNo': fmphoneNo,
                                        'fmName1': fmName1,
                                        'fmphoneNo1': fmphoneNo1,
                                        'name': '${userinfo['name']}',
                                        'email': '${userinfo['email']}',
                                        'uid': '${userinfo["uid"]}',
                                        'phoneNo': '${userinfo["phoneNo"]}',
                                        'address': '${userinfo["address"]}',
                                        'fphoneNo': '${userinfo["fphoneNo"]}',
                                        'fname': '${userinfo["fname"]}',
                                        'designation':
                                            '${userinfo["designation"]}',
                                        'age': '${userinfo["age"]}',
                                        'time': DateTime.now(),
                                        'owner': '${userinfo["owner"]}',
                                        'complainStatus': 'pending',
                                        'FCMtoken': FCMtoken,
                                        "isProcessed": false,
                                      }).then((value) {
                                        print("Complain Added");
                                        complian.clear();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Your complain has been generated")));
                                      }).catchError((error) => print(
                                          "Failed to add Complaint : $error"));
                                    }
                                  });
                                }
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                )),
                                backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(15, 39, 127, 1),
                                ),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20))),
                            child: const Text('Submit',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Container(
                                  height: 4,
                                  color: Colors.grey[350],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child:
                                      Text("Response to Previous Complians "),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Card(
                                        color: const Color.fromARGB(
                                            255, 245, 245, 245),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        elevation: 5,
                                        child: FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('complian')
                                              .limit(30)
                                              .where('uid',
                                                  isEqualTo: userinfo['uid'])
                                              .get(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator(); // Display a loading indicator while fetching data
                                            }
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }
                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Text(
                                                  'No data available'); // Display a message if there is no data
                                            }

                                            // Create a list of documents
                                            List<DocumentSnapshot> documents =
                                                snapshot.data!.docs;

                                            // Create a list to store the "response" and "complainStatus" data
                                            List<String> responses = [];
                                            List<String> complainStatuses = [];

                                            for (var document in documents) {
                                              Map<String, dynamic>?
                                                  documentData = document.data()
                                                      as Map<String, dynamic>?;

                                              // Check if the document has "response" and "complainStatus" fields
                                              if (documentData == null) {
                                                print("Documents data is null");
                                              } else {
                                                complainStatuses.add(
                                                    documentData[
                                                        "complainStatus"]);
                                                if (documentData['response'] ==
                                                    null) {
                                                  responses.add(
                                                      "Regretfully unable");
                                                } else {
                                                  responses.add(
                                                      documentData["response"]);
                                                }

                                                return ListTile(
                                                  title: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text("Response"),
                                                        Text("Complain Status"),
                                                      ],
                                                    ),
                                                  ),
                                                  subtitle: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                          "${documentData['response']}"),
                                                      Text(
                                                          "${documentData['complainStatus']}")
                                                    ],
                                                  ),
                                                );
                                              }
                                            }

                                            return const ListTile();
                                          },
                                        )))
                              ],
                            ),
                          ),
                        ))
                  ]));
            }));
  }
}
