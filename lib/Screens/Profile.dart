import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/AddFamilyMembers.dart';
import 'package:testapp/Screens/Bill.dart';
import 'package:testapp/Screens/Complaint.dart';
import 'package:testapp/Screens/LoginPage.dart';
import 'package:path_provider/path_provider.dart';

class UserProfile extends StatefulWidget {
  static final routename = 'userprofile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String filePath = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            )),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.black,
            ),
            onPressed: () async {
              var c = await SharedPreferences.getInstance();
              c.clear();
              Navigator.push(
                  context,
                  PageTransition(
                      duration: Duration(milliseconds: 700),
                      type: PageTransitionType.rightToLeftWithFade,
                      child: LoginScreen()));
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
              userinfo["fname"],
              userinfo["designation"],
              userinfo["age"],
              userinfo["uid"],
              userinfo["owner"],
              userinfo["email"]
            ];

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.white],
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          CircleAvatar(
                            radius: 65.0,
                            backgroundImage: AssetImage(
                                'assets/Images/profile-Icon-SVG.jpg'),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(userinfo["name"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            userinfo["designation"] ?? "Not Mention",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton.icon(
                              label: Text(
                                'Add Family Members',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                String docid = userinfo["id"];
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FamilyMembers(id: docid),
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
                                      EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20))),
                              icon: Icon(Icons.add, color: Colors.white))
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.grey[200],
                        child: Center(
                            child: Card(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 55.0, 0.0, 20.0),
                                child: Container(
                                    width: 310.0,
                                    //height: 290.0,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
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
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
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
                                            SizedBox(
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
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
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
                                            SizedBox(
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
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Phone",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      userinfo["phoneNo"],
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
                                            SizedBox(
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
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
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
                                            SizedBox(
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
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Other Family Member Name",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
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
                                            SizedBox(
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
                                                SizedBox(
                                                  width: 20.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Other Family Member Phone",
                                                      style: TextStyle(
                                                        fontSize: 15.0,
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
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.currency_exchange,
                                                  color: Colors.green[800],
                                                  size: 35,
                                                ),
                                                // SizedBox(
                                                //   width: 10.0,
                                                // ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextButton(
                                                      child: Text(
                                                        "Bills",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        await generatePDF();
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    PDFViewerPage(
                                                                        pdfPath:
                                                                            filePath)));
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.list_alt_sharp,
                                                  color: Colors.yellow[800],
                                                  size: 35,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextButton(
                                                      child: Text(
                                                        "Complaints",
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                Complainform
                                                                    .routename);
                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
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
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.yellowAccent[400],
                            size: 35,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
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
    print("path = ${filePath}");

    // Save the PDF to the file
    await file.writeAsBytes(await pdf.save());
    print("PDF Generated");
  }
}
