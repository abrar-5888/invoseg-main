import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Complainform extends StatefulWidget {
  const Complainform({Key? key}) : super(key: key);
  static final routename = 'Complaint';

  @override
  State<Complainform> createState() => _ComplainformState();
}

class _ComplainformState extends State<Complainform> {
  CollectionReference complain =
      FirebaseFirestore.instance.collection("complian");
  bool show_res = false;
  TextEditingController complian = TextEditingController();
  var name;

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
                      child: Row(
                        children: <Widget>[
                          Padding(
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
                            margin:
                                const EdgeInsets.only(left: 00.0, right: 10.0),
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
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20.0),
                                labelText: 'Enter Complaint',
                                border: InputBorder.none,
                                hintText: 'Enter your Complaint',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Complain required!';
                                }
                              },
                              onSaved: (value) {},
                            ),
                          )
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
                            child: Text('Submit',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            onPressed: () async {
                              final FirebaseMessaging _firebaseMessaging =
                                  FirebaseMessaging.instance;
                              String FCMtoken = "";
                              await _firebaseMessaging
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

                              String compla = complian.text.trim();
                              complain.add({
                                'Complain': '${compla}',
                                'noti': true,
                                'Name': '${userinfo['name']}',
                                'Email': '${userinfo['email']}',
                                'ID': '${userinfo["uid"]}',
                                'PhoneNo': '${userinfo["phoneNo"]}',
                                'Address': '${userinfo["address"]}',
                                'FPhoneNo': '${userinfo["fphoneNo"]}',
                                'FName': '${userinfo["fname"]}',
                                'Designation': '${userinfo["designation"]}',
                                'Age': '${userinfo["age"]}',
                                'time': DateTime.now(),
                                'Owner': '${userinfo["owner"]}',
                                'complainStatus': 'pending',
                                'FCMtoken': FCMtoken,
                              }).then((value) {
                                print("Complain Added");
                                complian.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Your complain has been generated")));
                              }).catchError((error) =>
                                  print("Failed to add Complaint : $error"));
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20))),
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
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child:
                                      Text("Response to Previous Complians "),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Card(
                                        color:
                                            Color.fromARGB(255, 245, 245, 245),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        elevation: 5,
                                        child: FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('complain')
                                              .limit(30)
                                              .get(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(); // Display a loading indicator while fetching data
                                            }
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }
                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return Text(
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
                                                responses.add(
                                                    documentData["response"]);
                                                complainStatuses.add(
                                                    documentData[
                                                        "complainStatus"]);
                                                return ListTile(
                                                  title: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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

                                            return ListTile();
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
