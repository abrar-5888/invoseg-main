import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Rider/rider.dart';
import 'package:testapp/Screens/Tab.dart';
import 'package:testapp/Screens/forgotPass.dart';
import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  static final routename = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var logins = {"user": "", "pass": ""};
  final GlobalKey<FormState> _formKey = GlobalKey();

  void login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      EasyLoading.show(status: 'Authenticating...');
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: logins['user'].toString().trim(),
              password: logins['pass'].toString().trim())
          .then((e) async {
        if (logins['user'].toString().contains("rider")) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Rider()));
        } else
        // if (ifelse != null)
        {
          FirebaseFirestore.instance
              .collection("UserRequest")
              .where("email", isEqualTo: e.user!.email)
              .where("uid", isEqualTo: e.user!.uid)
              .where("status", isEqualTo: "Approve")
              .get()
              .then((main) async {
            if (main.docs.length < 1) {
              // If condition is not true in the first collection, check the second collection
              FirebaseFirestore.instance
                  .collection(
                      "UserRequest") // Replace with your second collection name
                  .where("email", isEqualTo: e.user!.email)
                  .where("uid", isEqualTo: e.user!.uid)
                  .where("status", isEqualTo: "Approve")
                  .get()
                  .then((secondCollection) async {
                print(secondCollection);
                print("second ${secondCollection.docs.length}");

                if (secondCollection.docs.length < 1) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //         'Your Application is Not Approved in the Second Collection'),
                  //     action: SnackBarAction(label: 'OK', onPressed: () {}),
                  //     backgroundColor: Colors.teal,
                  //   ),
                  // );
                  FirebaseFirestore.instance
                      .collection("UserRequest")
                      // .where("email", isEqualTo: e.user!.email)
                      .where("uid", isEqualTo: e.user!.uid)
                      .get()
                      .then((querySnapshot) {
                    querySnapshot.docs.forEach((document) {
                      // Access the parent document
                      final parentDocument = document.reference;

                      // Now, query the subcollection within the parent document
                      parentDocument
                          .collection(
                              "FMData") // Replace "YourSubcollectionName" with the actual subcollection name
                          .where("status", isEqualTo: "Approve")
                          .where('email', isEqualTo: e.user!.email)
                          .get()
                          .then((subcollectionSnapshot) {
                        subcollectionSnapshot.docs.forEach((subDoc) async {
                          // Process subcollection documents here
                          if (subcollectionSnapshot.docs.length < 1) {
                            // If condition is not true in the first collection, check the second collection
                            parentDocument
                                .collection(
                                    "FMData") // Replace "YourSubcollectionName" with the actual subcollection name
                                .where("status", isEqualTo: "Approve")
                                .where('email', isEqualTo: e.user!.email)
                                .get()
                                .then((secondCollection) async {
                              print(secondCollection);
                              print("second ${secondCollection.docs.length}");

                              if (secondCollection.docs.length < 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid Credentials'),
                                    action: SnackBarAction(
                                        label: 'OK', onPressed: () {}),
                                    backgroundColor: Colors.teal,
                                  ),
                                );
                              } else {
                                print("1");
                                // int num = 0;

                                // Process user data and navigate if conditions are met for the second collection
                                var info = secondCollection.docs[0]
                                    .data(); // Use secondCollection here
                                print('umair');
                                print(info["FM1"]);
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final userinfo = json.encode({
                                  "Fname": info["Name"],
                                  "FphoneNo": info["Phoneno"],

                                  // "FM${num}": info["FM1"][0]['FamilyName']
                                });
                                // num++;
                                await prefs.setString('userinfo', userinfo);
                                await prefs.setString('email', info["email"]);
                                await prefs.setString(
                                    'pass', logins['pass'].toString().trim());
                                await prefs.setBool("token", true);
                                EasyLoading.dismiss();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    duration: Duration(milliseconds: 100),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    child: TabsScreen(
                                      index: 0,
                                    ),
                                  ),
                                );
                              }
                            });
                            //
                          }

                          ///next
                          else {
                            // int num = 1;
                            print("2");
                            // Process user data and navigate if conditions are met for the first collection
                            var info = subcollectionSnapshot.docs[0].data();
                            var id = subcollectionSnapshot.docs[0].id;
                            print('umair');
                            // print(info["FM${num}"]['FamilyName']);
                            final prefs = await SharedPreferences.getInstance();
                            print("id");
                            final userinfo = json.encode({
                              "name": info["Name"],
                              "phoneNo": info["phonenumber"],
                              "address": info["address"],
                              "fphoneNo": info["fPhonenumber"],
                              "fname": info["fName"],
                              "designation": info["designation"],
                              "age": info["age"],
                              "uid": e.user!.uid,
                              "owner": info["owner"],
                              "id": id,
                              "email": info["email"],
                              // "FM${num}": info["FM${num}"]['FamilyName']
                              // ? "test"
                              // : info["FM${num}"]['FamilyName']
                            });
                            // num++;
                            await prefs.setString('userinfo', userinfo);
                            await prefs.setString('email', info["email"]);
                            await prefs.setString(
                                'pass', logins['pass'].toString().trim());

                            await prefs.setBool("token", true);
                            EasyLoading.dismiss();
                            Navigator.push(
                              context,
                              PageTransition(
                                duration: Duration(milliseconds: 100),
                                type: PageTransitionType.rightToLeftWithFade,
                                child: TabsScreen(
                                  index: 0,
                                ),
                              ),
                            );
                          }
                        });
                      });
                    });
                  });
                  EasyLoading.dismiss();
                } else {
                  print("1");
                  // int num = 0;

                  // Process user data and navigate if conditions are met for the second collection
                  var info = secondCollection.docs[0]
                      .data(); // Use secondCollection here
                  print('umair');
                  print(info["FM1"]);
                  final prefs = await SharedPreferences.getInstance();
                  final userinfo = json.encode({
                    "name": info["Name"],
                    "phoneNo": info["phonenumber"],
                    "address": info["address"],
                    "fphoneNo": info["fPhonenumber"],
                    "fname": info["fName"],
                    "designation": info["designation"],
                    "age": info["age"],
                    "uid": e.user!.uid,
                    "owner": info["owner"],
                    "email": info["email"],
                    // "FM${num}": info["FM1"][0]['FamilyName']
                  });
                  // num++;
                  await prefs.setString('userinfo', userinfo);
                  await prefs.setString('email', info["email"]);
                  await prefs.setString(
                      'pass', logins['pass'].toString().trim());
                  await prefs.setBool("token", true);
                  EasyLoading.dismiss();
                  Navigator.push(
                    context,
                    PageTransition(
                      duration: Duration(milliseconds: 100),
                      type: PageTransitionType.rightToLeftWithFade,
                      child: TabsScreen(
                        index: 0,
                      ),
                    ),
                  );
                }
              });
              //
            } else {
              // int num = 1;
              print("2");
              // Process user data and navigate if conditions are met for the first collection
              var info = main.docs[0].data();
              var id = main.docs[0].id;
              print('umair');
              // print(info["FM${num}"]['FamilyName']);
              final prefs = await SharedPreferences.getInstance();
              print("id");
              final userinfo = json.encode({
                "name": info["Name"],
                "phoneNo": info["phonenumber"],
                "address": info["address"],
                "fphoneNo": info["fPhonenumber"],
                "fname": info["fName"],
                "designation": info["designation"],
                "age": info["age"],
                "uid": e.user!.uid,
                "owner": info["owner"],
                "id": id,
                "email": info["email"],
                // "FM${num}": info["FM${num}"]['FamilyName']
                // ? "test"
                // : info["FM${num}"]['FamilyName']
              });
              // num++;
              await prefs.setString('userinfo', userinfo);
              await prefs.setString('email', info["email"]);
              await prefs.setString('pass', logins['pass'].toString().trim());

              await prefs.setBool("token", true);
              EasyLoading.dismiss();
              Navigator.push(
                context,
                PageTransition(
                  duration: Duration(milliseconds: 100),
                  type: PageTransitionType.rightToLeftWithFade,
                  child: TabsScreen(
                    index: 0,
                  ),
                ),
              );
            }
          });
        }
        // else {

        // }
      }).catchError((e) async {
        try {
          var parentColl = FirebaseFirestore.instance.collection('UserRequest');

          parentColl
              .where('phonenumber', isEqualTo: logins['user'])
              .get()
              .then((QuerySnapshot querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              // Phone number match found in parent collection
              var doc = querySnapshot.docs.first;
              var data = doc.data() as Map<String, dynamic>;
              var email = data['email'];

              // Authenticate with email and password
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: email, password: logins['pass'].toString().trim())
                  .then((e) async {
                FirebaseFirestore.instance
                    .collection("UserRequest")
                    .where("email", isEqualTo: email)
                    .where("uid", isEqualTo: e.user!.uid)
                    // .where("status", isEqualTo: "Approve")
                    .get()
                    .then((main) async {
                  if (main.docs.length < 1) {
                    print("object");
                  } else {
                    // int num = 1;
                    print("2");
                    // Process user data and navigate if conditions are met for the first collection
                    var info = main.docs[0].data();
                    var id = main.docs[0].id;
                    print('umair');
                    // print(info["FM${num}"]['FamilyName']);
                    final prefs = await SharedPreferences.getInstance();
                    print("id");
                    final userinfo = json.encode({
                      "name": info["Name"],
                      "phoneNo": info["phonenumber"],
                      "address": info["address"],
                      "fphoneNo": info["fPhonenumber"],
                      "fname": info["fName"],
                      "designation": info["designation"],
                      "age": info["age"],
                      "uid": e.user!.uid,
                      "owner": info["owner"],
                      "id": id,
                      "email": info["email"],
                      // "FM${num}": info["FM${num}"]['FamilyName']
                      // ? "test"
                      // : info["FM${num}"]['FamilyName']
                    });

                    // num++;
                    await prefs.setString('userinfo', userinfo);
                    await prefs.setString('email', info["email"]);
                    await prefs.setString(
                        'pass', logins['pass'].toString().trim());

                    await prefs.setBool("token", true);
                    EasyLoading.dismiss();
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 100),
                        type: PageTransitionType.rightToLeftWithFade,
                        child: TabsScreen(
                          index: 0,
                        ),
                      ),
                    );
                  }
                }).catchError((error) {
                  // Handle authentication failure
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Invalid Credentials"),
                    action: SnackBarAction(label: 'Ok', onPressed: () {}),
                  ));
                });
              });
            } else {
              // No match in parent collection, check subcollections

              parentColl.get().then((querySnapshot) {
                querySnapshot.docs.forEach((document) {
                  final parentDocument = document.reference;

                  // Query the subcollection within the parent document
                  parentDocument
                      .collection(
                          'FMData') // Replace with your subcollection name
                      .where('Phoneno', isEqualTo: logins['user'])
                      .get()
                      .then((subcollectionSnapshot) {
                    subcollectionSnapshot.docs.forEach((subDoc) {
                      print(subDoc.data());
                      var data = subDoc.data() as Map<String, dynamic>;
                      logins['user'] = data['email'];
                      var email = data['email'];

                      // Authenticate with email and password
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email,
                              password: logins['pass'].toString().trim())
                          .then((e) async {
                        print("Success");
                        if (subcollectionSnapshot.docs.length < 1) {
                          // If condition is not true in the first collection, check the second collection
                          parentDocument
                              .collection(
                                  "FMData") // Replace "YourSubcollectionName" with the actual subcollection name
                              .where("status", isEqualTo: "Approve")
                              .where('email', isEqualTo: email)
                              .get()
                              .then((secondCollection) async {
                            print(secondCollection);
                            print("second ${secondCollection.docs.length}");

                            if (secondCollection.docs.length < 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid Credentials'),
                                  action: SnackBarAction(
                                      label: 'OK', onPressed: () {}),
                                  backgroundColor: Colors.teal,
                                ),
                              );
                            } else {
                              print("1");
                              // int num = 0;

                              // Process user data and navigate if conditions are met for the second collection
                              var info = secondCollection.docs[0]
                                  .data(); // Use secondCollection here
                              print('umair');
                              print(info["FM1"]);
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final userinfo = json.encode({
                                "Fname": info["Name"],
                                "FphoneNo": info["Phoneno"],

                                // "FM${num}": info["FM1"][0]['FamilyName']
                              });
                              // num++;
                              await prefs.setString('userinfo', userinfo);
                              await prefs.setString('email', info["email"]);
                              await prefs.setString(
                                  'pass', logins['pass'].toString().trim());
                              await prefs.setBool("token", true);
                              EasyLoading.dismiss();
                              Navigator.push(
                                context,
                                PageTransition(
                                  duration: Duration(milliseconds: 100),
                                  type: PageTransitionType.rightToLeftWithFade,
                                  child: TabsScreen(
                                    index: 0,
                                  ),
                                ),
                              );
                            }
                          });
                          //
                        }
                        //..next
                        else {
                          // int num = 1;
                          print("2");
                          // Process user data and navigate if conditions are met for the first collection
                          var info = subcollectionSnapshot.docs[0].data();
                          var id = subcollectionSnapshot.docs[0].id;
                          print('umair');
                          // print(info["FM${num}"]['FamilyName']);
                          final prefs = await SharedPreferences.getInstance();
                          print("id");
                          final userinfo = json.encode({
                            "name": info["Name"],
                            "phoneNo": info["phonenumber"],
                            "address": info["address"],
                            "fphoneNo": info["fPhonenumber"],
                            "fname": info["fName"],
                            "designation": info["designation"],
                            "age": info["age"],
                            "uid": e.user!.uid,
                            "owner": info["owner"],
                            "id": id,
                            "email": info["email"],
                            // "FM${num}": info["FM${num}"]['FamilyName']
                            // ? "test"
                            // : info["FM${num}"]['FamilyName']
                          });
                          // num++;
                          await prefs.setString('userinfo', userinfo);
                          await prefs.setString('email', info["email"]);
                          await prefs.setString(
                              'pass', logins['pass'].toString().trim());

                          await prefs.setBool("token", true);
                          EasyLoading.dismiss();
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: Duration(milliseconds: 100),
                              type: PageTransitionType.rightToLeftWithFade,
                              child: TabsScreen(
                                index: 0,
                              ),
                            ),
                          );
                          print(e.user!.uid);
                        }
                        // Authentication successful
                        // Add your navigation logic here
                      }).catchError((error) {
                        EasyLoading.dismiss();
                        // Handle authentication failure
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Inavlid Credentials"),
                          action: SnackBarAction(label: 'Ok', onPressed: () {}),
                        ));
                      });
                    });
                  });
                });

                // Handle the case where no match was found in the subcollections
                // ...
              });
            }
          });
          EasyLoading.dismiss();
        } catch (e) {
          EasyLoading.dismiss();
          // Handle any errors that occur during Firestore or Authentication operations
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Invalid Credentials"),
            action: SnackBarAction(label: 'Ok', onPressed: () {}),
          ));
        }
      });
    }
    ;
  }

  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: Text(e.toString()),
  //     action: SnackBarAction(
  //         label: 'OK', textColor: Colors.black, onPressed: () {}),
  //     backgroundColor: Colors.grey[400],
  //   ),
  // );

/* My Try
  void login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      EasyLoading.show(status: 'Authenticating...');

      String? userEmail = logins['user']?.toString().trim();
      String? userPass = logins['pass']?.toString().trim();

      if (userEmail != null && userPass != null) {
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: userEmail,
          password: userPass,
        )
            .then((e) {
          if (logins['user'].toString().contains("rider")) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Rider()));
          } else {
            FirebaseFirestore.instance
                .collection("UserRequest")
                .where("email", isEqualTo: e.user!.email)
                .get()
                .then((main) async {
              if (main.docs.length < 1) {
                // If condition is not true in the first collection, check the second collection

                FirebaseFirestore.instance
                    .collection(
                        "UserRequest") // Replace with your second collection name
                    .where("email", isEqualTo: e.user!.email)
                    .where("uid", isEqualTo: e.user!.uid)
                    .where("status", isEqualTo: "Approve")
                    .get()
                    .then((secondCollection) async {
                  print(secondCollection);
                  print("second ${secondCollection.docs.length}");

                  if (secondCollection.docs.length < 1) {
                    //  = secondCollection.docs[0].id;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Your Application is Not Approved in the Second Collection'),
                        action: SnackBarAction(label: 'OK', onPressed: () {}),
                        backgroundColor: Colors.teal,
                      ),
                    );
                    EasyLoading.dismiss();
                  } else {
                    print("working");

                    EasyLoading.dismiss();
                  }
                });
              } else {
                print("Subcollection");
              }
            });
          }
        });
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            //     image: DecorationImage(
            //   image: NetworkImage(
            //       'https://w0.peakpx.com/wallpaper/395/822/HD-wallpaper-city-amoled-black-building-city-new-night-sky.jpg'),
            //   fit: BoxFit.cover,
            //   colorFilter: new ColorFilter.mode(
            //       Colors.black.withOpacity(0.7), BlendMode.dstATop),
            // )
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(),
                            child: Column(
                              children: <Widget>[
                                Image(
                                  image: AssetImage('assets/Images/rehman.png'),
                                  height: 150,
                                  width: 150,
                                ),
                                // FittedBox(
                                //   fit: BoxFit.fitWidth,
                                //   child: Container(
                                //     child: Text(
                                //       "Shop, Heal, and Stay Secure with the Smart Lake City",
                                //       style: TextStyle(
                                //         fontSize: (MediaQuery.of(context).size.width -
                                //                 MediaQuery.of(context).padding.top) *
                                //             0.060,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black,
                                //       ),
                                //       textAlign: TextAlign.center,
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: Icon(
                                          Icons.person_outline,
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
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Email or PhoneNo',
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter your Email Address or PhoneNo',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          validator: (value) {
                                            // if (value!.isEmpty) {
                                            //   return 'Invalid email!';
                                            // } else if (!value.contains('@')) {
                                            //   // return 'Invalid email';
                                            //   if (!value.contains('03') ||
                                            //       !value.contains('+92')) {
                                            //     return 'Invalid Number';
                                            //   }
                                            //   return ' invalid email';
                                            // }
                                          },
                                          onSaved: (value) {
                                            logins['user'] = value!;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: Icon(
                                          Icons.lock_open,
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
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter your Password here',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 6) {
                                              return 'Password is too short!';
                                            }
                                          },
                                          onSaved: (value) {
                                            logins['pass'] = value!;
                                          },
                                          obscureText: true,
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    height: 50,
                                    child: Container(
                                      child: ElevatedButton(
                                        child: Text('Login',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                        onPressed: () {
                                          login();
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20))),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 10),
                                        ),
                                        onPressed: () {
                                          // Navigator.push(
                                          //     context,
                                          //     PageTransition(
                                          //         duration: Duration(
                                          //             milliseconds: 700),
                                          //         type: PageTransitionType
                                          //             .rightToLeftWithFade,
                                          //         child:
                                          //             PhoneVerificationScreen()));
                                        },
                                        child: const Text(
                                          'Forgot Password ?',
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
