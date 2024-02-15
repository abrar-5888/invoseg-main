import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complainform extends StatefulWidget {
  const Complainform({Key? key}) : super(key: key);
  // static const routename = 'Complaint';

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

    timer = Timer.periodic(const Duration(hours: 24), (timer) {
      if (DateTime.now().difference(lastUpdateTime).inHours >= 24) {
        setState(() {
          myVariable = 0;
          lastUpdateTime = DateTime.now();
          print("Variable reset to 0 after 24 hours.");
        });
      }
    });

    simulatePassageOfTime(myVariable, lastUpdateTime);
  }

  void simulatePassageOfTime(int myVariable, DateTime lastUpdateTime) {
    DateTime simulatedNow =
        lastUpdateTime.add(const Duration(hours: 23, minutes: 30));

    if (simulatedNow.difference(lastUpdateTime).inHours >= 24) {
      setState(() {
        myVariable = 0;
        lastUpdateTime = simulatedNow;
        print("Variable reset to 0 after 24 hours (simulated).");
      });
    }

    print(
        "Current state: Variable=$myVariable, Last Update Time=$lastUpdateTime");
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  bool btnDisable = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          foregroundColor: const Color(0xff212121),
          title: const Text(
            'Submit Complaints',
            style: TextStyle(
              color: Color(0xff212121),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        body: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot snapshot) {
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
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ),
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
                                  left: 00.0,
                                  right: 10.0,
                                ),
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
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
                                    labelText: 'Enter Complaint',
                                    border: InputBorder.none,
                                    hintText: 'Enter your Complaint',
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
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
                              alertMe();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(15, 39, 127, 1),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
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
                                      Text("Response to Previous Complains "),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                    ),
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
                                              .limit(2)
                                              .orderBy('pressedTime',
                                                  descending: true)
                                              .where('uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .get(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }

                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                    'No complaints available'),
                                              );
                                            } else {
                                              List<DocumentSnapshot> documents =
                                                  snapshot.data!.docs;
                                              print(
                                                  "documents: ${documents.length}");

                                              List<Widget> complaintWidgets =
                                                  [];

                                              for (var document in documents) {
                                                Map<String, dynamic>?
                                                    documentData =
                                                    document.data() as Map<
                                                        String, dynamic>?;

                                                print(
                                                    "Document data: $documentData");

                                                if (documentData == null) {
                                                  print(
                                                      "Document data is null");
                                                  continue; // Skip to the next iteration
                                                }

                                                complaintWidgets.add(
                                                  Card(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ListTile(
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            const Text(
                                                              "Response : ",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                documentData[
                                                                        'response'] ??
                                                                    'No response',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      subtitle: Row(
                                                        children: [
                                                          const Text(
                                                            "Complaint Status : ",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(documentData[
                                                                  'complainStatus'] ??
                                                              'No status'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return Column(
                                                children: complaintWidgets,
                                              );
                                            }
                                          },
                                        )))
                              ],
                            ),
                          ),
                        ))
                  ]));
            }));
  }

  void alertMe() async {
    String fmphoneNo = "", fmName = "", fmphoneNo1 = "", fmName1 = "";
    SharedPreferences oka = await SharedPreferences.getInstance();
    var userinfo = json.decode(oka.getString('userinfo') as String);

    if (btnDisable == false) {
      setState(() {
        btnDisable = true;
      });
      print(myVariable);
      if (myVariable == 5) {
        snack();
      } else {
        if (complian.text.isNotEmpty) {
          final FirebaseMessaging firebaseMessaging =
              FirebaseMessaging.instance;
          String FCMtoken = "";
          await firebaseMessaging.getToken().then((String? token) {
            if (token != null) {
              setState(() {
                FCMtoken = token;
              });
              print("FCM Token: $FCMtoken");
            } else {
              print("Unable to get FCM token");
            }
          });
          final mainCollectionQuery = await FirebaseFirestore.instance
              .collection("UserRequest")
              .where("parentID", isEqualTo: userinfo['parentID'])
              .get();
          if (mainCollectionQuery.docs.isNotEmpty) {
            mainCollectionQuery.docs.forEach((mainDoc) async {
              final subcollectionRef = mainDoc.reference.collection("FMData");

              final subcollectionQuery = await subcollectionRef
                  .where("owner", isEqualTo: userinfo['owner'])
                  .get();

              if (subcollectionQuery.docs.isNotEmpty) {
                var data = subcollectionQuery.docs[0].data();
                String parentId = data['parentID'];
                DocumentSnapshot parentDoc = await FirebaseFirestore.instance
                    .collection('UserRequest')
                    .doc(parentId)
                    .get();
                if (parentDoc.exists) {
                  // Step 2: Access the subcollection
                  QuerySnapshot subcollectionSnapshot = await parentDoc
                      .reference
                      .collection('FMData')
                      .limit(2)
                      .get();
                  if (subcollectionSnapshot.docs.isNotEmpty) {
                    // Access subcollection document data for the first document
                    Map<String, dynamic> firstDocData =
                        subcollectionSnapshot.docs[0].data()
                            as Map<String, dynamic>;

                    setState(() {
                      fmName = firstDocData['Name'];
                      fmphoneNo = firstDocData['phonenumber'];
                    });
                    print('First Subcollection Document Data: $firstDocData');

                    // Check if there is a second document before accessing
                    if (subcollectionSnapshot.docs.length > 1) {
                      // Access subcollection document data for the second document
                      Map<String, dynamic> secondDocData =
                          subcollectionSnapshot.docs[1].data()
                              as Map<String, dynamic>;
                      print(
                          'Second Subcollection Document Data: $secondDocData');
                      setState(() {
                        fmName1 = secondDocData['Name'];
                        fmphoneNo1 = secondDocData['phonenumber'];
                      });

                      print("FM 1 $fmName1    +++++++++++   $fmphoneNo1");
                    } else {
                      print('Subcollection has only one document.');
                    }
                  } else {
                    print('Subcollection is empty.');
                  }
                } else {
                  print('Document with ID $parentId does not exist.');
                }
                await Future.delayed(const Duration(seconds: 1));

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
                  'designation': '${userinfo["designation"]}',
                  'age': '${userinfo["age"]}',
                  'pressedTime': DateTime.now(),
                  'owner': '${userinfo["owner"]}',
                  'complainStatus': 'pending',
                  'FCMtoken': FCMtoken,
                  "edit": false,
                }).then((value) {
                  myVariable++;
                  print("Complain Added");
                  complian.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Your complain has been generated",
                    ),
                  ));
                }).catchError(
                  (error) => print("Failed to add Complaint : $error"),
                );
              } else {
                await Future.delayed(const Duration(seconds: 1));
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
                  'designation': '${userinfo["designation"]}',
                  'age': '${userinfo["age"]}',
                  'pressedTime': DateTime.now(),
                  'owner': '${userinfo["owner"]}',
                  'complainStatus': 'pending',
                  'FCMtoken': FCMtoken,
                  "edit": false,
                }).then((value) {
                  myVariable++;
                  print("Complain Added");
                  complian.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                      "Your complain has been generated",
                    ),
                  ));
                }).catchError(
                  (error) => print("Failed to add Complaint : $error"),
                );
              }
            });
          }
          await Future.delayed(const Duration(seconds: 5));
          if (btnDisable) {
            setState(() {
              btnDisable = false; // Re-enable the button
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter the complain first")));
        }
      }
    } else {
      Future.delayed(const Duration(minutes: 1), () {});
    }
  }

  void snack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Sorry, you have reached the limit for submitting complaints. "
          "Please try again later or contact our support team for assistance.",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
