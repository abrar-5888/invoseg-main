import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/Screens/main/AddFamilyMembers.dart';
import 'package:com.invoseg.innovation/Screens/main/LoginPage.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  static const routename = 'userprofile';

  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateViewProf();
  }

  String filePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            )),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.black,
            ),
            onPressed: () async {
              var c = await SharedPreferences.getInstance();
              c.clear();
              Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(milliseconds: 700),
                      type: PageTransitionType.rightToLeftWithFade,
                      child: const LoginScreen()));
            },
          )
        ],
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
              userinfo["Fname"],
              userinfo["designation"],
              userinfo["age"],
              userinfo['id'],
              userinfo["uid"],
              userinfo["owner"],
              userinfo["email"]
            ];
            // setState(() {

            // });
            print("uid = ${userinfo['id']}");
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.white],
                          ),
                        ),
                        child: Column(children: [
                          const SizedBox(
                            height: 30.0,
                          ),
                          const CircleAvatar(
                            radius: 65.0,
                            backgroundImage: AssetImage(
                                'assets/Images/profile-Icon-SVG.jpg'),
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(userinfo["name"] ?? "null",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              )),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            userinfo["designation"] ?? "Not Mention",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          if (!userinfo["id"].toString().startsWith('FM'))
                            ElevatedButton.icon(
                                label: const Text(
                                  'Add Family Members',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  updateAddFM();
                                  String docid = userinfo["uid"];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FamilyMembers(
                                            id: docid,
                                            emailss: userinfo["email"],
                                            addresss: userinfo["address"],
                                            ownerss: userinfo['owner']),
                                      ));
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
                                        const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20))),
                                icon:
                                    const Icon(Icons.add, color: Colors.white))
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.grey[200],
                        child: Center(
                            child: Card(
                                margin: const EdgeInsets.fromLTRB(
                                    0.0, 55.0, 0.0, 20.0),
                                child: SizedBox(
                                    width: 310.0,
                                    //height: 290.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "More Information",
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.home,
                                                  color: Colors.blueAccent[400],
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Address",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      userinfo["address"] ??
                                                          "Not Medntioned",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[400],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.date_range_rounded,
                                                  color:
                                                      Colors.greenAccent[400],
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Age",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      userinfo["age"] ??
                                                          "Not Mentioned",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[400],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  color: Colors.pinkAccent[400],
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Phone",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      userinfo["phoneNo"] ??
                                                          "not Mentioned",
                                                      // "TEST",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[400],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.star_purple500_outlined,
                                                  color: Colors.blue[400],
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Owner Or Related Family Member",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      userinfo["owner"] ??
                                                          "Not Mentioned",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.people,
                                                  color: Colors.lightGreen[400],
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const FittedBox(
                                                      child: Text(
                                                        "Other Family Member Name",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      userinfo["fname"] ??
                                                          "Not Mentioned",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.phone_in_talk_rounded,
                                                  color: Colors.teal[400],
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const FittedBox(
                                                      child: Text(
                                                        "Other Family Member Phone",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      userinfo["fphoneNo"] ??
                                                          "Not Mentioned",
                                                      // "TEST",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.grey[400],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.no_accounts_outlined,
                                                  color: Colors.redAccent[400],
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  child: const Text(
                                                    "Deactivate My Account",
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    print('working');
                                                    showDeactivateConfirmationDialog(
                                                        context, userinfo);
                                                  },
                                                )
                                              ],
                                            ),

                                            // SizedBox(
                                            //   width: 10.0,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    )))),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.40,
                    left: 20.0,
                    right: 20.0,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.yellowAccent[400],
                            size: 35,
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                userinfo["email"],
                                // "TEST",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[400],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))),
              ],
            );
          }),
    );
  }

  void showDeactivateConfirmationDialog(BuildContext context, userinfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Deactivate Account",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: const [
                TextSpan(
                  text:
                      "Note:\nYour request will be sent to the admin after 5 working days.\n\n",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: "Are you sure you want to deactivate your account?",
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('deActivated')
                      .add({
                    'pressedTime': DateTime.now(),
                    'name': userinfo["name"] ?? "",
                    'phoneNo': userinfo["phoneNo"] ?? "",
                    'address': userinfo["address"] ?? "",
                    'FphoneNo': userinfo["fphoneNo"] ?? "",
                    'Fname': userinfo["fname"] ?? "",
                    'designation': userinfo["designation"] ?? "",
                    'age': userinfo["age"] ?? "",
                    'uid': userinfo["uid"] ?? "",
                    'owner': userinfo["owner"] ?? "",
                    'email': userinfo["email"] ?? ""
                  }).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Deactivation request sent!'),
                        action: SnackBarAction(
                          label: 'Ok',
                          onPressed: () {},
                        ),
                      ),
                    );
                  });

                  // Get a QuerySnapshot to perform the update

                  // Update each document

                  // print(
                  //     "User request deactivated successfully!");
                } catch (error) {
                  print("Error deactivating user request: $error");
                }
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(pw.MultiPage(
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
            child: pw.Text('Hello, PDF!'),
          ),
        ];
      },
    ));

    final directory = await getApplicationDocumentsDirectory();

    setState(() {
      filePath = '${directory.path}/test.pdf';
    });
    final file = File(filePath);
    print("path = $filePath");

    // Save the PDF to the file
    await file.writeAsBytes(await pdf.save());
    print("PDF Generated");
  }
}
