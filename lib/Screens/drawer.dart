// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_string_interpolations, override_on_non_overriding_member

import 'dart:convert';

import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/Bill.dart';
import 'package:testapp/Screens/Complaint.dart';
import 'package:testapp/Screens/History.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/Profile.dart';
import 'package:testapp/Screens/Tab.dart';
import 'package:testapp/Screens/Discounts/discounts.dart';

class DrawerWidg extends StatefulWidget {
  const DrawerWidg({super.key});

  @override
  State<DrawerWidg> createState() => _DrawerWidgState();
}

class _DrawerWidgState extends State<DrawerWidg> {
  String filePath = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            height: double.infinity,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3.1,
                    child: DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    color: Colors.grey,
                                    spreadRadius: 1)
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/Images/profile-Icon-SVG.jpg'),
                              radius: 52,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(
                            top: 10,
                          )),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              userinfo["name"],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(
                            top: 5,
                          )),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${userinfo["phoneNO"] ?? "+92 318 7113880"}  ${userinfo["email"]}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1, right: 1),
                            child: Column(
                              children: [
                                Center(
                                  child: InkWell(
                                    child: Container(
                                      width: 122,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff3A1D8C),
                                          borderRadius:
                                              BorderRadius.circular(80)),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              'View Profile',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserProfile(),
                                          ));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 10, left: 30),
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 238, 240, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.house_rounded,
                                    color: Color(0xff3A1D8C)),
                              ),
                              title: const Text(
                                ' Home ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TabsScreen(index: 0),
                                    ));
                              },
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 238, 240, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.medical_services,
                                    color: Color(0xff3A1D8C)),
                              ),
                              title: const Text(
                                ' Medical ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            TabsScreen(index: 2))));
                              },
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            // ListTile(
                            //   dense: true,
                            //   visualDensity: const VisualDensity(vertical: -3),
                            //   leading: Container(
                            //     height: 30,
                            //     width: 30,
                            //     decoration: BoxDecoration(
                            //         color:
                            //             const Color.fromRGBO(236, 238, 240, 1),
                            //         borderRadius: BorderRadius.circular(30)),
                            //     child: const Icon(Icons.list_alt_sharp,
                            //         color: Color(0xff3A1D8C)),
                            //   ),
                            //   title: const Text(
                            //     ' Complains ',
                            //     style: TextStyle(
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w500,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => Complainform(),
                            //         ));
                            //   },
                            // ),
                            // const SizedBox(
                            //   height: 7,
                            // ),
                            ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 238, 240, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.shopping_basket_rounded,
                                    color: Color(0xff3A1D8C)),
                              ),
                              title: const Text(
                                ' Grocery ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            TabsScreen(index: 1))));
                              },
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 238, 240, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.feed,
                                    color: Color(0xff3A1D8C)),
                              ),
                              title: const Text(
                                ' History ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              // trailing: const Badge(
                              //   label: Text(
                              //     '2',
                              //     style: TextStyle(color: Colors.white),
                              //   ),
                              // ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ButtonsHistory()));
                              },
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 238, 240, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.line_style_outlined,
                                    color: Color(0xff3A1D8C)),
                              ),
                              title: const Text(
                                ' Plots ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        TabsScreen(index: 4)),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 238, 240, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.request_page,
                                    color: Color(0xff3A1D8C)),
                              ),
                              title: const Text(
                                ' Bills',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () async {
                                await generatePDF();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PDFViewerPage(pdfPath: filePath)));
                              },
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(vertical: -3),
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(236, 238, 240, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Icon(Icons.settings,
                                    color: Color(0xff3A1D8C)),
                              ),
                              // const Icon(
                              //   FontAwesomeIcons.circleQuestion,
                              //   color: Colors.amberAccent,
                              //   size: 17,
                              // ),
                              title: const Text(
                                ' Settings',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              onTap: () {
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: ((context) => const MainProfile()),
                                //   ),
                                // );
                              },
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 45, right: 30),
                            //   child: Column(
                            //     children: [
                            //       Center(
                            //         child: InkWell(
                            //           child: Container(
                            //             width: 122,
                            //             height: 40,
                            //             decoration: BoxDecoration(
                            //                 color: Colors.amberAccent,
                            //                 borderRadius: BorderRadius.circular(80)),
                            //             child: Row(
                            //               // ignore: prefer_const_literals_to_create_immutables
                            //               children: [
                            //                 const Padding(
                            //                   padding:
                            //                       EdgeInsets.only(left: 17, right: 7),
                            //                   child: Icon(
                            //                     FontAwesomeIcons.powerOff,
                            //                     color: Colors.white,
                            //                     size: 20,
                            //                   ),
                            //                 ),
                            //                 const Center(
                            //                   child: Text(
                            //                     'LOGOUT',
                            //                     style: TextStyle(
                            //                       fontSize: 14,
                            //                       fontWeight: FontWeight.w500,
                            //                       color: Colors.white,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //           onTap: () async {

                            //           },
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )
                            const SizedBox(
                              height: 30,
                            ),
                            const Column(
                              children: [
                                Text(
                                  'POWERED BY',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Image(
                                  image: AssetImage(
                                    'assets/Images/TransparentLogo.png',
                                  ),
                                  height: 50,
                                  width: 50,
                                ),
                                Text(
                                  'INVOSEG',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
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
