import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Models/addFM.dart';

class FamilyMembers extends StatefulWidget {
  static const routename = 'Family-Members';
  var id, emailss, addresss, ownerss;
  FamilyMembers(
      {super.key,
      required this.id,
      required this.emailss,
      required this.addresss,
      required this.ownerss});
  @override
  _FamilyMembersState createState() => _FamilyMembersState();
}

class _FamilyMembersState extends State<FamilyMembers> {
  final GlobalKey<FormState> _FMformKey = GlobalKey();
  var remaining;
  final passContoller = TextEditingController();

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool isPhone(String em) {
    String p =
        r'^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }

  var addFMmodel = addFM(
      name: '',
      email: '',
      password: '',
      phoneNo: '',
      uid: '',
      address: '',
      owner: '',
      parentID: '',
      ownerEmail: '');
  var FMinitials = {
    'name': '',
    'email': '',
    'password': '',
    'phoneNo': '',
    'uid': '',
    'address': '',
    'owner': '',
    'parentID': '',
    'ownerEmail': ''
  };
  String generateRandomFourDigitCode() {
    Random random = Random();
    int code = random.nextInt(10000);

    // Ensure the code is four digits long (pad with leading zeros if necessary)
    return code.toString().padLeft(4, '0');
  }

  void generatePassword() {
    passContoller.text = addFMmodel.password;
    final random = Random();
    const upperCaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numericChars = '0123456789';

    String password = '';

    for (int i = 0; i < 4; i++) {
      password += upperCaseChars[random.nextInt(upperCaseChars.length)];
      // passContoller.text = password;
    }

    for (int i = 0; i < 4; i++) {
      password += numericChars[random.nextInt(numericChars.length)];
      // passContoller.text = password;
    }
    setState(() {
      passContoller.text = password;
    });
  }

  bool _isloading = true;

  void remain() async {
    _isloading = true;

    String documentId = "";
    SharedPreferences userinfo = await SharedPreferences.getInstance();
    String? emailaaa = userinfo.getString('email');
    var userrecord = FirebaseFirestore.instance
        .collection("UserRequest")
        .where('email', isEqualTo: emailaaa)
        .where('uid', isEqualTo: widget.id);
    print(widget.id);
    QuerySnapshot userQuerySnapshot = await userrecord.get();
    // print(userQuerySnapshot.toString());

    if (userQuerySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot documentSnapshot in userQuerySnapshot.docs) {
        print("Document ID: ${documentSnapshot.id}");
        setState(() {
          documentId = documentSnapshot.id;
        });
        // You can also access the document data if needed:
        // var data = documentSnapshot.data();
        // print("Document Data: $data");
      }
      DocumentReference userDocumentRef =
          userQuerySnapshot.docs.first.reference;
      print(documentId);

      // Reference to the "FmData" subcollection
      CollectionReference fmDataCollection =
          userDocumentRef.collection("FMData");
      QuerySnapshot fmDataSnapshot = await fmDataCollection.get();
      var length = fmDataSnapshot.docs.length;
      setState(() {
        _isloading = false;
      });

      if (length.toString() == null) {
        setState(() {
          _isloading = false;
          remaining = 8;
        });
      } else {
        setState(() {
          _isloading = false;
          remaining = 7 - length;
        });
        // print("Remaining = $remaining");
      }
      _isloading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    remain();
  }

  int fmNum = 1;
  void saveform() async {
    String documentId = "";
    String fourDigitCode = generateRandomFourDigitCode();

    print("digit code = $fourDigitCode");
    String email = "";
    String pass;
    if (_FMformKey.currentState!.validate()) {
      _FMformKey.currentState!.save();
      try {
        SharedPreferences userinfo = await SharedPreferences.getInstance();
        String? address = userinfo.getString('address');
        String? owner = userinfo.getString('owner');
        String? uid = userinfo.getString('uid');
        String? emailaaa = userinfo.getString('email');
        EasyLoading.show();
        if (addFMmodel.email != null) {
          setState(() {
            email = addFMmodel.email;
          });
        } else {
          setState(() {
            email = "${addFMmodel.phoneNo}@gmail.com";
          });
        }
        pass = addFMmodel.password;
        print("Email = $email,password = $pass");

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);

        User? user = userCredential.user;
        // await getMobileToken();

        var userrecord = FirebaseFirestore.instance
            .collection("UserRequest")
            .where('email', isEqualTo: emailaaa)
            .where('uid', isEqualTo: widget.id);
        print(widget.id);
        QuerySnapshot userQuerySnapshot = await userrecord.get();
        // print(userQuerySnapshot.toString());

        if (userQuerySnapshot.docs.isNotEmpty) {
          for (QueryDocumentSnapshot documentSnapshot
              in userQuerySnapshot.docs) {
            print("Document ID: ${documentSnapshot.id}");
            setState(() {
              documentId = documentSnapshot.id;
            });
            // You can also access the document data if needed:
            // var data = documentSnapshot.data();
            // print("Document Data: $data");
          }
          DocumentReference userDocumentRef =
              userQuerySnapshot.docs.first.reference;
          print(documentId);

          // Reference to the "FmData" subcollection
          CollectionReference fmDataCollection =
              userDocumentRef.collection("FMData");
          QuerySnapshot fmDataSnapshot = await fmDataCollection.get();
          var length = fmDataSnapshot.docs.length;

          if (fmDataSnapshot.docs.length >= 8) {
            // If the subcollection has 8 documents
            EasyLoading.showError("Maximum Logins Exceeded!");
          } else {
            if (length.toString() == null) {
              setState(() {
                remaining = 8;
              });
            } else {
              setState(() {
                remaining = 7 - length;
              });
              // print("Remaining = $remaining");
            }

            Map<String, dynamic> fmData = {
              "remaining": remaining,
              "Name": addFMmodel.name,
              "Phoneno": addFMmodel.phoneNo,
              "status": "Approve",
              "email": FirebaseAuth.instance.currentUser!.email,
              "uid": user?.uid,
              "password": addFMmodel.password,
              "residentID": "INVOSEG$fourDigitCode",
              // "CM_Token": FCMtoken,
              "address": widget.addresss,
              "owner": widget.ownerss,
              'parentID': widget.id,
              'ownermail': emailaaa,
            };
// commit 11 December 2023 
            DocumentReference parentDocumentReference = FirebaseFirestore
                .instance
                .collection('UserRequest')
                .doc(documentId);
            DocumentSnapshot parentDocumentSnapshot =
                await parentDocumentReference.get();
            int currentTFM = parentDocumentSnapshot.get('TFM');
            print(currentTFM);
            setState(() {
              fmNum = 1 + currentTFM;
            });

            CollectionReference subcollectionReference =
                parentDocumentReference.collection('FMData');

            DocumentReference fmDocumentReference =
                subcollectionReference.doc('FM$fmNum');
            await fmDocumentReference.set(fmData).then((value) => {
                  EasyLoading.dismiss(),
                  setState(() {
                    // fmNum = fmNum + 1;
                  })
                });
            print(parentDocumentReference);
            print("fmNum   $fmNum");
            await parentDocumentReference
                .update({'TFM': FieldValue.increment(1)});

            print("oka:");

            _FMformKey.currentState!.reset();
            FocusScope.of(context).unfocus();
            EasyLoading.dismiss();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Details Sent!',
                  style: TextStyle(color: Colors.black),
                ),
                action: SnackBarAction(
                    label: 'OK', textColor: Colors.black, onPressed: () {}),
                backgroundColor: Colors.grey[400],
              ),
            );
            // if (length <= 8) {
            showDialog1(context);
            // } else {
            //   showDialog2(context);
            // }
          }
        } else {
          print("Empty");
        }
      } catch (e) {
        EasyLoading.dismiss();
        showDialog2(context);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: const Text("Sorry ! An error Occured"),
        //   action: SnackBarAction(label: 'ok', onPressed: () {}),
        // ));
      }
    }
  }

  void showDialog1(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add another Family Member'),
            content: const Text('You want to add another family member?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Handle "No" button press
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             const MyPage())); // Close the dialog

                  // Close the dialog
                  // You can navigate back to the previous page here
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _FMformKey.currentState!.reset();
                  FocusScope.of(context).unfocus();
                  // Handle "Yes" button press
                  // You can navigate to the page where you want to add a family member
                  // using Navigator or any other navigation method
                },
                child: const Text('Yes'),
              ),
            ],
          );
        });
  }

  void showDialog2(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Family Member'),
            content: const Text(
                'Sorry You cannot add another family member.Thank You for your cordinations !'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Handle "No" button press
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             const MyPage())); // Close the dialog

                  // Close the dialog
                  // You can navigate back to the previous page here
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading == false) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Add Family Member",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            )),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Form(
                  key: _FMformKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: Column(
                          children: <Widget>[
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      "ADD FAMILY MEMBERS",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize:
                                            (MediaQuery.of(context).size.width -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top) *
                                                0.060,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Maximum 8 Inherited Logins Allowed",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .top) *
                                              0.040,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Your Remaining logins are $remaining",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  MediaQuery.of(context)
                                                      .padding
                                                      .top) *
                                              0.040,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Colors.grey.withOpacity(0.5),
                            //       width: 1.0,
                            //     ),
                            //     borderRadius: BorderRadius.circular(20.0),
                            //   ),
                            //   margin: const EdgeInsets.symmetric(
                            //       vertical: 20.0, horizontal: 20.0),
                            //   child: Row(
                            //     children: <Widget>[
                            //       const Padding(
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 10.0, horizontal: 15.0),
                            //         child: Icon(
                            //           Icons.person_outline,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //       Container(
                            //         height: 10.0,
                            //         width: 1.0,
                            //         color: Colors.grey.withOpacity(0.5),
                            //         margin: const EdgeInsets.only(
                            //             left: 00.0, right: 10.0),
                            //       ),
                            //       Expanded(
                            //         child: TextFormField(
                            //           onChanged: (val) {
                            //             setState(() {
                            //               name = val;
                            //             });
                            //           },
                            //           keyboardType: TextInputType.name,
                            //           decoration: const InputDecoration(
                            //             labelText: 'Family Member Name',
                            //             border: InputBorder.none,
                            //             hintText: 'Enter your Family Member Name',
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 10),
                            //           ),
                            //           validator: (value) {
                            //             if (value!.isEmpty) {
                            //               return 'Family Member Name is required!';
                            //             }
                            //             return null;
                            //           },
                            //           onSaved: (value) {},
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Colors.grey.withOpacity(0.5),
                            //       width: 1.0,
                            //     ),
                            //     borderRadius: BorderRadius.circular(20.0),
                            //   ),
                            //   margin: const EdgeInsets.symmetric(
                            //       vertical: 20.0, horizontal: 20.0),
                            //   child: Row(
                            //     children: <Widget>[
                            //       const Padding(
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 10.0, horizontal: 15.0),
                            //         child: Icon(
                            //           Icons.email,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //       Container(
                            //         height: 10.0,
                            //         width: 1.0,
                            //         color: Colors.grey.withOpacity(0.5),
                            //         margin: const EdgeInsets.only(
                            //             left: 00.0, right: 10.0),
                            //       ),
                            //       Expanded(
                            //         child: TextFormField(
                            //           onChanged: (val) {
                            //             emailaddress = val;
                            //           },
                            //           keyboardType: TextInputType.emailAddress,
                            //           decoration: const InputDecoration(
                            //             labelText: 'Email',
                            //             border: InputBorder.none,
                            //             hintText: 'Enter your Email Address',
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 10),
                            //           ),
                            //           validator: (value) {
                            //             if (value!.isEmpty ||
                            //                 !value.contains('@')) {
                            //               return 'Invalid email!';
                            //             }
                            //             return null;
                            //           },
                            //           onSaved: (value) {},
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Colors.grey.withOpacity(0.5),
                            //       width: 1.0,
                            //     ),
                            //     borderRadius: BorderRadius.circular(20.0),
                            //   ),
                            //   margin: const EdgeInsets.symmetric(
                            //       vertical: 20.0, horizontal: 20.0),
                            //   child: Row(
                            //     children: <Widget>[
                            //       const Padding(
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 10.0, horizontal: 15.0),
                            //         child: Icon(
                            //           Icons.phone,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //       Container(
                            //         height: 10.0,
                            //         width: 1.0,
                            //         color: Colors.grey.withOpacity(0.5),
                            //         margin: const EdgeInsets.only(
                            //             left: 00.0, right: 10.0),
                            //       ),
                            //       Expanded(
                            //         child: TextFormField(
                            //           onChanged: (val) {
                            //             phonenumber = val;
                            //           },
                            //           keyboardType: TextInputType.phone,
                            //           decoration: const InputDecoration(
                            //             labelText: 'Family Member Phone Number',
                            //             border: InputBorder.none,
                            //             hintText:
                            //                 'Enter your Family Member Phone Number',
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 10),
                            //           ),
                            //           validator: (value) {
                            //             if (value!.isEmpty) {
                            //               return 'Family Member Phone Number is required!';
                            //             }
                            //             return null;
                            //           },
                            //           onSaved: (value) {},
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Colors.grey.withOpacity(0.5),
                            //       width: 1.0,
                            //     ),
                            //     borderRadius: BorderRadius.circular(20.0),
                            //   ),
                            //   margin: const EdgeInsets.symmetric(
                            //       vertical: 10.0, horizontal: 20.0),
                            //   child: Row(
                            //     children: <Widget>[
                            //       const Padding(
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 10.0, horizontal: 15.0),
                            //         child: Icon(
                            //           Icons.lock_open,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //       Container(
                            //         height: 10.0,
                            //         width: 1.0,
                            //         color: Colors.grey.withOpacity(0.5),
                            //         margin: const EdgeInsets.only(
                            //             left: 00.0, right: 10.0),
                            //       ),
                            //       Expanded(
                            //         child: TextFormField(
                            //           onChanged: (val) {
                            //             setState(() {
                            //               password = val;
                            //             });
                            //           },
                            //           decoration: const InputDecoration(
                            //             labelText: 'Password',
                            //             border: InputBorder.none,
                            //             hintText: 'Enter your Password here',
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 10),
                            //           ),
                            //           validator: (value) {
                            //             if (value!.isEmpty || value.length < 6) {
                            //               return 'Password is too short!';
                            //             }
                            //             return null;
                            //           },
                            //           onSaved: (value) {},
                            //           obscureText: true,
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Colors.grey.withOpacity(0.5),
                            //       width: 1.0,
                            //     ),
                            //     borderRadius: BorderRadius.circular(20.0),
                            //   ),
                            //   margin: const EdgeInsets.symmetric(
                            //       vertical: 10.0, horizontal: 20.0),
                            //   child: Row(
                            //     children: <Widget>[
                            //       const Padding(
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 10.0, horizontal: 15.0),
                            //         child: Icon(
                            //           Icons.lock,
                            //           color: Colors.black,
                            //         ),
                            //       ),
                            //       Container(
                            //         height: 10.0,
                            //         width: 1.0,
                            //         color: Colors.grey.withOpacity(0.5),
                            //         margin: const EdgeInsets.only(
                            //             left: 00.0, right: 10.0),
                            //       ),
                            //       Expanded(
                            //         child: TextFormField(
                            //           onChanged: (val) {
                            //             setState(() {
                            //               cpassqord = val;
                            //             });
                            //           },
                            //           decoration: const InputDecoration(
                            //             labelText: 'Confirm Password',
                            //             border: InputBorder.none,
                            //             hintText:
                            //                 'Enter your Confirm Password here',
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 10),
                            //           ),
                            //           validator: (value) {
                            //             if (value!.isEmpty || value.length < 6) {
                            //               return 'Confirm Password is too short!';
                            //             }
                            //             return null;
                            //           },
                            //           onSaved: (value) {},
                            //           obscureText: true,
                            //         ),
                            //       )
                            //     ],
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
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 1.0,
                                    color: Colors.grey.withOpacity(0.5),
                                    margin: const EdgeInsets.only(
                                        left: 00.0, right: 10.0),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          FMinitials['name'] as String,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Your Full Name',
                                        border: InputBorder.none,
                                        hintText: 'Adam Hunt',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'This field is required and cannot be left empty!';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        addFMmodel.name = value!;
                                      },
                                      keyboardType: TextInputType.text,
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
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 1.0,
                                    color: Colors.grey.withOpacity(0.5),
                                    margin: const EdgeInsets.only(
                                        left: 00.0, right: 10.0),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          FMinitials['email'] as String,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Your Email',
                                        border: InputBorder.none,
                                        hintText: 'john@email.com',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                      ),
                                      validator: (value) {
                                        return null;
                                      },
                                      onSaved: (value) {
                                        addFMmodel.email = value!;
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
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 1.0,
                                    color: Colors.grey.withOpacity(0.5),
                                    margin: const EdgeInsets.only(
                                        left: 00.0, right: 10.0),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          FMinitials['phoneNo'] as String,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        labelText: 'Enter Your Phone Number',
                                        border: InputBorder.none,
                                        hintText: '030xxxxxxxx',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 10),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Phone Number is not valid!';
                                        } else if (!isPhone(value)) {
                                          return 'Please enter valid Phone.';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        addFMmodel.phoneNo = value!;
                                      },
                                    ),
                                  ),
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
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    height: 30.0,
                                    width: 1.0,
                                    color: Colors.grey.withOpacity(0.5),
                                    margin: const EdgeInsets.only(
                                        left: 00.0, right: 10.0),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      // obscureText: true,
                                      controller: passContoller,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                        suffixIcon: Container(
                                          margin: const EdgeInsets.all(8),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              minimumSize: const Size(100, 50),
                                            ),
                                            child: const Text(
                                              "generate pass",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            onPressed: () {
                                              generatePassword();
                                            },
                                          ),
                                        ),
                                        labelText: 'Enter Your Password',
                                        border: InputBorder.none,
                                        hintText: '********',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Password is not valid!';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        addFMmodel.password = value!;
                                      },
                                    ),
                                  ),
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
                                      onPressed: saveform,
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromRGBO(
                                                      15, 39, 127, 1)),
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 20))),
                                      child: const Text('Add Member',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ))
                          ],
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
    } else {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
  }
}
