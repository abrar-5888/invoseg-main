// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:com.invoseg.innovation/Providers/NotificationCounterProvider.dart';
// import 'package:com.invoseg.innovation/Providers/announcementProvider.dart';
// import 'package:com.invoseg.innovation/Providers/visitorProvider.dart';
// import 'package:com.invoseg.innovation/Screens/Complaint.dart';
// import 'package:com.invoseg.innovation/Screens/Discounts/discounts.dart';
// import 'package:com.invoseg.innovation/Screens/Notifications.dart';
// import 'package:com.invoseg.innovation/Screens/Tab.dart';
// import 'package:com.invoseg.innovation/Screens/drawer.dart';
// import 'package:com.invoseg.innovation/Screens/plots_detail.dart';
// import 'package:com.invoseg.innovation/Screens/visitors.dart';
// import 'package:com.invoseg.innovation/global.dart';
// import 'package:com.invoseg.innovation/widgets/announcemnetAlertBox.dart';
// import 'package:com.invoseg.innovation/widgets/visitorAlertBox.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class HomeDesign1 extends StatefulWidget {
//   static const routeName = "HomeDesign1";

//   static List<IconData> navigatorsIcon = [
//     Icons.desktop_mac_rounded,
//   ];

//   const HomeDesign1({super.key});

//   @override
//   _HomeDesign1State createState() => _HomeDesign1State();
// }

// class _HomeDesign1State extends State<HomeDesign1> {
//   bool? nh;
//   int? Fdays;
//   TextEditingController FfromDate = TextEditingController();
//   TextEditingController FtoDate = TextEditingController();
//   String? link = "ddd";
//   String videoId = "dd";

//   var y_controller;

//   Future<void> getchNH() async {
//     print(FirebaseAuth.instance.currentUser!.uid);
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('not_Home') // Replace with your collection name

//           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           // .orderBy('time', descending: true)
//           .limit(1)
//           .get();
//       // Initialize the link variable

//       if (querySnapshot.docs.isNotEmpty) {
//         Map<String, dynamic> data =
//             querySnapshot.docs.first.data() as Map<String, dynamic>;
//         setState(() {
//           nh = data['nh'];
//           Fdays = data['days'];
//           FfromDate.text = data['from'];
//           FtoDate.text = data['to'];
//         });
//         print("NH =$nh+$Fdays+${FfromDate.text}+${FtoDate.text}");

//         // print("Fetched Link: $link");
//       } else {
//         DateTime dateTime = DateTime.now();
//         String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

//         setState(() {
//           nh = false;
//           Fdays = 0;
//           FfromDate.text = formattedDate;
//           FtoDate.text = formattedDate;
//         });
//         print("No documents found in the 'Not_Home' collection.");
//       }
//     } catch (e) {
//       print("Error $e");
//     }
//   }

//   Future<String?> fetchYoutubeLink() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('VideoPanel') // Replace with your collection name
//           // .where('Email' == "oka1@gmail.com")
//           .orderBy('time', descending: true)
//           .limit(1)
//           .get();
//       // Initialize the link variable

//       if (querySnapshot.docs.isNotEmpty) {
//         Map<String, dynamic> data =
//             querySnapshot.docs.first.data() as Map<String, dynamic>;
//         setState(() {
//           link = data['Url'];
//         });
//         print("Linkdo=$link");

//         // print("Fetched Link: $link");
//       } else {
//         setState(() {
//           link = "";
//         });
//         print("No documents found in the 'VideoPanel' collection.");
//       }
//     } catch (e) {
//       setState(() {
//         link = "";
//       });
//       print("Error fetching data: $e");
//       return null;
//     }
//     return null;
//   }

//   // String? videoUrl = "https://www.youtube.com/watch?v=R7XNJ3r5n4k";
//   var buttonLabels;
//   String filePath = "";
//   int button_count_sec = 1;
//   int button_count_gro = 1;
//   int button_count_med = 1;
//   List<String> urls = [];
//   DateTime startDate = DateTime.now();
//   DateTime endDate = DateTime.now().add(const Duration(days: 60));
//   bool _isInit = true;
//   int _daysDifference = 0;

//   TextEditingController _dateController = TextEditingController(
//     text:
//         "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
//   );
//   TextEditingController currentdate = TextEditingController(
//       text:
//           "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
//   DateTime selectedDate = DateTime.now();
//   DateTime newSelectedDate = DateTime.now();
//   String fmName = "", fmphoneNo = "", fmName1 = "", fmphoneNo1 = "";
//   late DateTime fbToDate;
//   late DateTime fbFromDate;

//   // String fbToDate = '';
//   // String fbFromDate = '';

//   bool _isLoading = true;
//   final CollectionReference _collectionRef =
//       FirebaseFirestore.instance.collection('utility');

//   Future _sendEmail({
//     required String name,
//     required String email,
//     required String subject,
//     required String message,
//   }) async {
//     // String name, email, subject, message;
//     final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
//     var serviceId = 'service_s7hyzpr';
//     var templateId = 'template_0yvlqvj';
//     var userId = 'Jg-9ZFPX61IpyTv1w';
//     final response = await http.post(url,
//         body: json.encode({
//           'service_id': serviceId,
//           'template_id': templateId,
//           'user_id': userId,
//           'template_params': {
//             'user_name': name,
//             'from_name': name,
//             'mail': "venrablejutt310@gmail.com",
//             'user_subject': subject,
//             'to_email': "daniyalhumayun7@gmail.com",
//             'user_message': message
//           },
//         }),
//         headers: {
//           'origin': "http://localhost",
//           'Content-Type': 'application/json'
//         });

//     print(response.body);
//   }

//   Future<void> generatePDF() async {
//     final pdf = pw.Document();

//     // Add a page to the PDF
//     pdf.addPage(pw.MultiPage(
//       build: (pw.Context context) {
//         return <pw.Widget>[
//           pw.Center(
//             child: pw.Text('Hello, PDF!'),
//           ),
//         ];
//       },
//     ));

//     final directory = await getApplicationDocumentsDirectory();

//     setState(() {
//       filePath = '${directory.path}/test.pdf';
//     });
//     final file = File(filePath);
//     print("path = $filePath");

//     // Save the PDF to the file
//     await file.writeAsBytes(await pdf.save());
//     print("PDF Generated");
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate,
//       firstDate: startDate, // Change the start date as needed
//       lastDate: endDate, // Change the end date as needed
//     );
//     final daysDifference = picked!.difference(DateTime.now()).inDays;
//     if (picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         newSelectedDate = picked;

//         _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
//         _daysDifference = daysDifference;
//         print("days= $_daysDifference");
//       });
//     }
//   }

//   String FCMtoken = "";
//   getMobileToken() {}
//   bool btnOnOff = false;
//   String generateRandomFourDigitCode() {
//     Random random = Random();
//     int code = random.nextInt(10000);

//     // Ensure the code is four digits long (pad with leading zeros if necessary)
//     return code.toString().padLeft(4, '0');
//   }

//   String toField = "";
//   String docid = "";
//   bool status = false;
//   String guardName = "";
//   String guardEmail = "";
//   String guardPhone = "";

//   Future<String> fetchToFieldForLatestDocument(String? currentUserEmail) async {
//     try {
//       // Query to get the document with the latest 'FROM' date and matching 'Email'
//       final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('not_Home') // Replace with your collection name
//           // .where('Email' == "oka1@gmail.com")
//           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .where('Status', isEqualTo: true)
//           .limit(1)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         print("not");
//         // The first document in the result will be the latest one that matches the conditions
//         final DocumentSnapshot document = querySnapshot.docs.first;
//         final data = document.data() as Map<String, dynamic>;

//         print("data+++++++++++++++++++++===================$data");
//         setState(() {
//           guardPhone = data['guardPhone'] ?? "";
//           guardEmail = data['guardEmail'] ?? "";
//           guardName = data['guardName'] ?? "";
//         });

//         if (data.containsKey('to')) {
//           DateTime checkDate = DateTime.now();
//           var checkDateFormate = DateFormat('yyyy-MM-dd').format(checkDate);

//           if (checkDateFormate != data['to']) {
//             setState(() {
//               toField = data['to'] as String;
//               docid = document.id;
//               newSelectedDate = DateTime.parse(data['to'] as String);
//               //  temTODte = data['to'].substring(0.11) as String;
//               fbToDate = DateTime.parse(data['to'] as String);
//               fbFromDate = DateTime.parse(data['from'] as String);

//               // fbToDate =  data['to'] as String;
//               // fbFromDate = data['from'] as String;

//               status = data["Status"];

//               print("$status+$toField+$docid+$fbToDate+$fbFromDate");

//               print('if worksssssssssssssssssss $docid');
//             });
//           } else {
//             print("else work");
//             setState(() async {
//               await FirebaseFirestore.instance
//                   .collection("not_Home")
//                   .doc(docid)
//                   .update({
//                 'Status': false,
//                 // 'cancelled': true,
//                 'pressedTime1': DateTime.now()
//               });
//               toField = data['to'] as String;
//               docid = document.id;
//               newSelectedDate = DateTime.parse(data['to'] as String);
//               //  temTODte = data['to'].substring(0.11) as String;
//               fbToDate = DateTime.parse(data['to'] as String);
//               fbFromDate = DateTime.parse(data['from'] as String);

//               // fbToDate =  data['to'] as String;
//               // fbFromDate = data['from'] as String;

//               status = false;

//               print("$status+$toField+$docid+$fbToDate+$fbFromDate");
//             });
//           }

//           print(DateFormat('yyyy-MM-dd').format(fbToDate));
//           print("fbFromDate = $fbFromDate");
//           return toField;
//         }
//       }
//     } catch (e) {
//       print('Error fetching TO field: $e');
//     }

//     return ''; // Return an empty string or handle errors as needed
//   }

//   void alertMe(String collect) async {
//     // final Alertbtns = Provider.of<AlertBTNS>(context, listen: false);
//     DateTime now = DateTime.now();
//     String documentId;
//     String formattedDate = "${now.year}-${now.month}-${now.day}";
//     String formattedTime = DateFormat('hh:mm:ss a').format(now);
//     String fmName = "", fmphoneNo = "";
//     String fmName1 = "", fmphoneNo1 = "";
//     String fourDigitCode = generateRandomFourDigitCode();
//     try {
//       // EasyLoading.show(status: "Processing");
//       // Alertbtns.showMedConfirmDialogs(false);
//       // Alertbtns.showGroConfirmDialogs(false);
//       // Alertbtns.showSecConfirmDialogs(false);
//       if (!btnOnOff) {
//         final prefs = await SharedPreferences.getInstance();
//         final userinfo =
//             json.decode(prefs.getString('userinfo')!) as Map<String, dynamic>;

//         setState(() {
//           FCMtoken = prefs.getString('tokens')!;
//           btnOnOff = true;
//         });
//         updateButtonOne();

//         // Step 1: Query the main collection based on parentID
//         final mainCollectionQuery = await FirebaseFirestore.instance
//             .collection("UserRequest")
//             .where("parentID", isEqualTo: userinfo['parentID'])
//             .get();

//         if (mainCollectionQuery.docs.isNotEmpty) {
//           mainCollectionQuery.docs.forEach(
//             (mainDoc) async {
//               // Step 2: Query the subcollection "FMData"
//               final subcollectionRef = mainDoc.reference.collection("FMData");

//               final subcollectionQuery = await subcollectionRef
//                   .where("parentID", isEqualTo: userinfo['parentID'])
//                   .get();

//               if (subcollectionQuery.docs.isNotEmpty) {
//                 // Process the first document
//                 var data = subcollectionQuery.docs[0].data();
//                 String parentId = data['parentID'];
//                 DocumentSnapshot parentDoc = await FirebaseFirestore.instance
//                     .collection('UserRequest')
//                     .doc(parentId)
//                     .get();
//                 if (parentDoc.exists) {
//                   // Step 2: Access the subcollection
//                   QuerySnapshot subcollectionSnapshot = await parentDoc
//                       .reference
//                       .collection('FMData')
//                       .limit(2)
//                       .get();
//                   if (subcollectionSnapshot.docs.isNotEmpty) {
//                     // Access subcollection document data for the first document
//                     Map<String, dynamic> firstDocData =
//                         subcollectionSnapshot.docs[0].data()
//                             as Map<String, dynamic>;

//                     setState(() {
//                       fmName = firstDocData['Name'];
//                       fmphoneNo = firstDocData['phonenumber'];
//                     });
//                     print('First Subcollection Document Data: $firstDocData');

//                     // Check if there is a second document before accessing
//                     if (subcollectionSnapshot.docs.length > 1) {
//                       // Access subcollection document data for the second document
//                       Map<String, dynamic> secondDocData =
//                           subcollectionSnapshot.docs[1].data()
//                               as Map<String, dynamic>;
//                       print(
//                           'Second Subcollection Document Data: $secondDocData');
//                       setState(() {
//                         fmName1 = secondDocData['Name'];
//                         fmphoneNo1 = secondDocData['phonenumber'];
//                       });

//                       print("FM 1 $fmName1    +++++++++++   $fmphoneNo1");
//                     } else {
//                       print('Subcollection has only one document.');
//                     }
//                   } else {
//                     print('Subcollection is empty.');
//                   }
//                 } else {
//                   print('Document with ID $parentId does not exist.');
//                 }

//                 // Process the second document if it exists

//                 await FirebaseFirestore.instance.collection(collect).add(
//                   {
//                     "edit": false,
//                     "name": userinfo["name"],
//                     "phoneNo": userinfo["phoneNo"],
//                     "address": userinfo["address"],
//                     "fmphoneNo": fmphoneNo,
//                     "fmphoneNo1": fmphoneNo1,
//                     "fname": userinfo['fname'],
//                     "fPhoneNo": userinfo['fphoneNo'],
//                     "fmName": fmName,
//                     "fmName1": fmName1,
//                     "designation": userinfo["designation"],
//                     "age": userinfo["age"],
//                     "pressedTime": FieldValue.serverTimestamp(),
//                     "type": collect,
//                     "time": formattedTime,
//                     "date": formattedDate,
//                     "uid": userinfo["uid"],
//                     "owner": userinfo["owner"],
//                     "email": userinfo["email"],
//                     "noti": true,
//                     "residentID": "Invoseg$fourDigitCode",
//                     "FCMtoken": FCMtoken
//                   },
//                 ).then(
//                   (DocumentReference document) => {
//                     documentId = document.id,
//                     print("DOCUMENT ID +++++++ $documentId"),
//                   },
//                 );

//                 FirebaseFirestore.instance.collection("UserButtonRequest").add(
//                   {
//                     "type": collect,
//                     "uid": userinfo["uid"],
//                     "pressedTime": FieldValue.serverTimestamp(),
//                   },
//                 );
//                 popAndSnackBar();
//                 EasyLoading.showSuccess('Request sent');
//               } else {
//                 print("No matching documents found in the Sub collection.");
//                 await FirebaseFirestore.instance.collection(collect).add(
//                   {
//                     "name": userinfo["name"],
//                     "phoneNo": userinfo["phoneNo"],
//                     "address": userinfo["address"],
//                     "fmphoneNo": fmphoneNo ?? "",
//                     "fmName1": fmName1 ?? "",
//                     "fmphoneNo1": fmphoneNo1 ?? "",
//                     "fname": userinfo['fname'],
//                     "fPhoneNo": userinfo['fphoneNo'],
//                     "fmName": fmName ?? "",
//                     "edit": false,
//                     "designation": userinfo["designation"],
//                     "age": userinfo["age"],
//                     "pressedTime": FieldValue.serverTimestamp(),
//                     "type": collect,
//                     "time": formattedTime,
//                     "date": formattedDate,
//                     "uid": userinfo["uid"],
//                     "owner": userinfo["owner"],
//                     "email": userinfo["email"],
//                     "noti": true,
//                     "residentID": "Invoseg$fourDigitCode",
//                     "FCMtoken": FCMtoken
//                   },
//                 ).then(
//                   (DocumentReference document) => {
//                     documentId = document.id,
//                     print("DOCUMENT ID +++++++ $documentId"),
//                   },
//                 );

//                 FirebaseFirestore.instance.collection("UserButtonRequest").add(
//                   {
//                     "type": collect,
//                     "uid": userinfo["uid"],
//                     "pressedTime": FieldValue.serverTimestamp(),
//                   },
//                 );
//                 popAndSnackBar();
//                 EasyLoading.showSuccess('Request sent');
//               }
//             },
//           );
//           // EasyLoading.showSuccess('Request sent');
//         } else {
//           // EasyLoading.showSuccess('Request sent');
//           print("No matching documents found in the main collection.");
//         }

//         print("FCM Token: $FCMtoken");

//         // EasyLoading.showSuccess('Request sent');

//         _sendEmail(
//             name: '${userinfo["name"]}',
//             email: '${userinfo["email"]}',
//             message:
//                 "type : $collect\n name : ${userinfo["name"]}\nEmail : ${userinfo['email']}\nAddress : ${userinfo['address']}\nPhone No : ${userinfo['phoneNo']}\nF-Phone No ${userinfo['fphoneNo']}\nF-Name : ${userinfo['fname']}\nDesignation : ${userinfo['designation']}\nage : ${userinfo['age']}\nOwner : ${userinfo['owner']}",
//             subject: "test subject");
//       } else {}
//     } catch (e) {
//       // popAndSnackBar();
//       // EasyLoading.showSuccess('Request sent');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text(
//           "Request not sent. please check your internet connection and try again !",
//           style: TextStyle(color: Colors.black),
//         ),
//         action: SnackBarAction(
//           label: 'OK',
//           textColor: Colors.black,
//           onPressed: () {},
//         ),
//         backgroundColor: Colors.grey[400],
//       ));
//     }
//   }

//   void popAndSnackBar() {
//     // Navigator.pop(context);

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text(
//           "Your Request is sent",
//           style: TextStyle(color: Colors.black),
//         ),
//         action: SnackBarAction(
//           label: 'OK',
//           textColor: Colors.black,
//           onPressed: () {},
//         ),
//         backgroundColor: Colors.grey[400],
//       ),
//     );
//   }

//   void secAlertMe(String collect) async {
//     // final Alertbtns = Provider.of<AlertBTNS>(context, listen: false);

//     setState(() {
//       btnOnOff = false;
//     });

//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text(
//           'Confirmation',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: Text(
//           'Are you sure you want to send a ${buttonLabels[0].toString().toLowerCase()} request?',
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(Colors.black),
//             ),
//             onPressed: () async {
//               if (button_count_sec <= 25) {
//                 setState(() {
//                   button_count_sec = button_count_sec + 1;
//                 });
//                 var connectivityResult =
//                     await (Connectivity().checkConnectivity());
//                 print("Connectivity == ${connectivityResult.toString()}");
//                 if (connectivityResult == ConnectivityResult.none) {
//                   await showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                               title: const Text('Offline !'),
//                               content: const Text(
//                                   'you are currently offline ! Contact us via Messages !'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () async {
//                                     const recipientPhoneNumber =
//                                         '03038465220'; // Replace with the recipient's phone number
//                                     const String messageBody =
//                                         'Hello, this is a test message.';
//                                     final uri = Uri.encodeFull(
//                                         'sms:$recipientPhoneNumber?body=$messageBody');
//                                     await launchUrl(Uri.parse(uri));
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text('Send Maintenance Message'),
//                                 ),
//                               ]));
//                 } else {
//                   print("Online");
//                   // Alertbtns.showSecConfirmDialogs(false);
//                   var connectivityResult =
//                       await (Connectivity().checkConnectivity());
//                   print("Connectivity == ${connectivityResult.toString()}");
//                   if (connectivityResult == ConnectivityResult.none) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: const Text(
//                           "This Feature is not available in Offline mode",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         action: SnackBarAction(
//                           label: 'OK',
//                           textColor: Colors.black,
//                           onPressed: () {},
//                         ),
//                         backgroundColor: Colors.grey[400],
//                       ),
//                     );
//                   } else {
//                     // Alertbtns.showSecConfirmDialogs(false);
//                     Navigator.pop(context);
//                     try {
//                       // EasyLoading.show(status: 'Processing',);
//                       // Attempt to make a GET request to a reliable server
//                       final response =
//                           await http.get(Uri.parse('https://www.google.com'));
//                       print(response.statusCode);
//                       if (response.statusCode == 200) {
//                         // Alertbtns.showSecConfirmDialogs(false);
//                         EasyLoading.dismiss();
//                         alertMe(collect);
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: const Text(
//                             "Your Internet connection is not stable. Please try again later",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           action: SnackBarAction(
//                             label: 'OK',
//                             textColor: Colors.black,
//                             onPressed: () {},
//                           ),
//                           backgroundColor: Colors.grey[400],
//                         ));

//                         EasyLoading.dismiss();
//                       }
//                     } catch (e) {
//                       // Alertbtns.showSecConfirmDialogs(false);
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: const Text(
//                           "Your Internet connection is not stable. Please try again later",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         action: SnackBarAction(
//                           label: 'OK',
//                           textColor: Colors.black,
//                           onPressed: () {},
//                         ),
//                         backgroundColor: Colors.grey[400],
//                       ));
//                       EasyLoading.dismiss();
//                     }
//                   }
//                 }
//               } else {
//                 // Alertbtns.showSecConfirmDialogs(false);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text(
//                       "Sorry ! but you have reached your todays limit .",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     action: SnackBarAction(
//                         label: 'OK', textColor: Colors.black, onPressed: () {}),
//                     backgroundColor: Colors.grey[400],
//                   ),
//                 );
//               }
//             },
//             child: const Text('Yes', style: TextStyle(color: Colors.white)),
//           ),
//           ElevatedButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(Colors.black),
//             ),
//             onPressed: () {
//               Navigator.of(ctx).pop(false);
//               // // Alertbtns.// Alertbtns.showMedConfirmDialogs(false);/
//               // // Alertbtns.showGroConfirmDialogs(false);
//               // Alertbtns.showSecConfirmDialogs(false);
//               // (false);
//             },
//             child: const Text(
//               'No',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void groAlertMe(String collect) async {
//     // final Alertbtns = Provider.of<AlertBTNS>(context, listen: false);
//     setState(() {
//       btnOnOff = false;
//     });
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text(
//           'Confirmation',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text(
//           'Are you sure you want to send a grocery request?',
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.black)),
//             onPressed: () async {
//               // Alertbtns.showGroConfirmDialogs(false);
//               if (button_count_gro <= 25) {
//                 setState(() {
//                   button_count_gro = button_count_gro + 1;
//                 });
//                 var connectivityResult =
//                     await (Connectivity().checkConnectivity());
//                 print("Connectivity == ${connectivityResult.toString()}");
//                 if (connectivityResult == ConnectivityResult.none) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: const Text(
//                       "This Feature is not available in Offline mode",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     action: SnackBarAction(
//                       label: 'OK',
//                       textColor: Colors.black,
//                       onPressed: () {},
//                     ),
//                     backgroundColor: Colors.grey[400],
//                   ));
//                 } else {
//                   Navigator.pop(context);
//                   var connectivityResult =
//                       await (Connectivity().checkConnectivity());
//                   print("Connectivity == ${connectivityResult.toString()}");
//                   if (connectivityResult == ConnectivityResult.none) {
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: const Text(
//                         "This Feature is not available in Offline mode",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       action: SnackBarAction(
//                         label: 'OK',
//                         textColor: Colors.black,
//                         onPressed: () {},
//                       ),
//                       backgroundColor: Colors.grey[400],
//                     ));
//                   } else {
//                     try {
//                       // EasyLoading.show(status: ' Processing');
//                       // Attempt to make a GET request to a reliable server
//                       final response =
//                           await http.get(Uri.parse('https://www.google.com'));
//                       print(response.statusCode);
//                       if (response.statusCode == 200) {
//                         EasyLoading.dismiss();
//                         alertMe(collect);
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: const Text(
//                             "Your Internet connection is not stable. Please try again later",
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           action: SnackBarAction(
//                             label: 'OK',
//                             textColor: Colors.black,
//                             onPressed: () {},
//                           ),
//                           backgroundColor: Colors.grey[400],
//                         ));
//                         EasyLoading.dismiss();
//                       }
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: const Text(
//                           "Your Internet connection is not stable. Please try again later",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         action: SnackBarAction(
//                           label: 'OK',
//                           textColor: Colors.black,
//                           onPressed: () {},
//                         ),
//                         backgroundColor: Colors.grey[400],
//                       ));
//                       EasyLoading.dismiss();
//                     }
//                   }
//                 }
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text(
//                       "Sorry ! but you have reached your todays limit .",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     action: SnackBarAction(
//                         label: 'OK', textColor: Colors.black, onPressed: () {}),
//                     backgroundColor: Colors.grey[400],
//                   ),
//                 );
//               }
//             },
//             child: const Text('Yes', style: TextStyle(color: Colors.white)),
//           ),
//           ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.black)),
//             onPressed: () {
//               // Alertbtns.showGroConfirmDialogs(false);
//               Navigator.of(ctx).pop(false);
//             },
//             child: const Text(
//               'No',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void medAlertMe(String collect) async {
//     // final Alertbtns = Provider.of<AlertBTNS>(context, listen: false);
//     setState(() {
//       btnOnOff = false;
//     });
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text(
//           'Confirmation',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text(
//           'Are you sure you want to send a medical consultation request?',
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.black)),
//             onPressed: () async {
//               // Alertbtns.showMedConfirmDialogs(false);
//               // Alertbtns.showGroConfirmDialogs(false);
//               // Alertbtns.showSecConfirmDialogs(false);
//               if (button_count_med <= 25) {
//                 setState(() {
//                   button_count_med = button_count_med + 1;
//                 });

//                 var connectivityResult =
//                     await (Connectivity().checkConnectivity());
//                 print("Connectivity == ${connectivityResult.toString()}");
//                 if (connectivityResult == ConnectivityResult.none) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: const Text(
//                       "This Feature is not available in Offline mode",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     action: SnackBarAction(
//                       label: 'OK',
//                       textColor: Colors.black,
//                       onPressed: () {},
//                     ),
//                     backgroundColor: Colors.grey[400],
//                   ));
//                 } else {
//                   Navigator.pop(context);
//                   try {
//                     // EasyLoading.show(status: 'Processing');

//                     // Attempt to make a GET request to a reliable server
//                     final response =
//                         await http.get(Uri.parse('https://www.google.com'));
//                     print(response.statusCode);
//                     if (response.statusCode == 200) {
//                       // Alertbtns.showMedConfirmDialogs(false);
//                       // Alertbtns.showGroConfirmDialogs(false);
//                       // // Alertbtns.showSecConfirmDialogs(false);
//                       EasyLoading.dismiss();
//                       Navigator.pop(context);
//                       alertMe(collect);
//                     } else {
//                       // Alertbtns.showMedConfirmDialogs(false);
//                       // Alertbtns.showGroConfirmDialogs(false);
//                       // Alertbtns.showSecConfirmDialogs(false);
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         content: const Text(
//                           "Your Internet connection is not stable. Please try again later",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         action: SnackBarAction(
//                           label: 'OK',
//                           textColor: Colors.black,
//                           onPressed: () {},
//                         ),
//                         backgroundColor: Colors.grey[400],
//                       ));
//                       EasyLoading.dismiss();
//                     }
//                   } catch (e) {
//                     // Alertbtns.showMedConfirmDialogs(false);
//                     // Alertbtns.showGroConfirmDialogs(false);
//                     // Alertbtns.showSecConfirmDialogs(false);
//                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                       content: const Text(
//                         "Your Internet connection is not stable. Please try again later",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       action: SnackBarAction(
//                         label: 'OK',
//                         textColor: Colors.black,
//                         onPressed: () {},
//                       ),
//                       backgroundColor: Colors.grey[400],
//                     ));
//                     EasyLoading.dismiss();
//                   }
//                 }
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text(
//                       "Sorry ! but you have reached your todays limit .",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                     action: SnackBarAction(
//                         label: 'OK', textColor: Colors.black, onPressed: () {}),
//                     backgroundColor: Colors.grey[400],
//                   ),
//                 );
//               }
//             },
//             child: const Text('Yes', style: TextStyle(color: Colors.white)),
//           ),
//           ElevatedButton(
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(Colors.black)),
//             onPressed: () {
//               Navigator.of(ctx).pop(false);
//               // Alertbtns.showMedConfirmDialogs(false);
//               // Alertbtns.showGroConfirmDialogs(false);
//               // Alertbtns.showSecConfirmDialogs(false);
//             },
//             child: const Text(
//               'No',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void didChangeDependencies() async {
//     if (_isInit) {
//       setState(() {
//         _isLoading = true;
//       });
//       _collectionRef.doc('Button').snapshots().listen((snap) {
//         buttonLabels = [
//           (snap.data() as Map)["btn1"],
//           (snap.data() as Map)["btn2"],
//           (snap.data() as Map)["btn3"]
//         ];
//         setState(() {
//           _isLoading = false;
//         });
//       });
//       _collectionRef.doc('Slider').snapshots().listen((snap) {
//         urls = [
//           (snap.data() as Map)["image1"],
//           (snap.data() as Map)["image2"],
//           (snap.data() as Map)["image3"],
//           (snap.data() as Map)["image4"]
//         ];
//         print(buttonLabels);
//         setState(() {
//           _isLoading = false;
//         });
//       });
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   // late VideoPlayerController _controller;
//   // bool startedPlaying = false;
//   String video = "";
//   // int counter = 0;
//   @override
//   void initState() {
//     Future.delayed(const Duration(seconds: 3), () {
//       const CircularProgressIndicator(
//         color: Color.fromRGBO(15, 39, 127, 1),
//       );
//     });
//     fetchPlots();
//     DateTime currentTime = DateTime.now();

//     // Format the time with AM/PM indicator
//     String formattedTime = DateFormat('hh:mm:ss a').format(currentTime);

//     // Print the result
//     print("Formatted time: $formattedTime");
//     super.initState();
//     // getLogo();
//     getchNH();
//     fetchToFieldForLatestDocument(FirebaseAuth.instance.currentUser!.uid);
//     fetchYoutubeLink().then((value) {
//       videoId = YoutubePlayer.convertUrlToId(link!) ??
//           'https://www.youtube.com/watch?v=-jMrZI4IeJw';
//       // video = YoutubePlayer.convertUrlToId(
//       //         "https://www.youtube.com/watch?v=hFjLbA1GhnM") ??
//       //     "https://www.youtube.com/watch?v=hFjLbA1GhnM";
//       y_controller = YoutubePlayerController(
//         initialVideoId: videoId,
//         flags: const YoutubePlayerFlags(
//           // isLive: true,
//           // forceHD: true,

//           autoPlay: false, // Set to true if you want the video to auto-play
//           showLiveFullscreenButton: false,
//         ),
//       );
//     });
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//     getAllIsReadStatus();
//     // Timer.periodic(const Duration(seconds: 3), (Timer timer) {
//     //   getAllIsReadStatus();
//     // });

//     // fetchDataAndUseLink();

//     // _controller = VideoPlayerController.asset("assets/video-demo.mp4");
//     // _controller.addListener(() {
//     //   if (startedPlaying && !_controller.value.isPlaying) {}
//     // });

//     print("OKA");

//     //   _controller.setLooping(true);

//     _dateController = TextEditingController(
//       text: "${selectedDate.toLocal()}".split(' ')[0],
//     );
//   }

//   // Future<bool> started() async {
//   //   await _controller.initialize();
//   //   await _controller.play();
//   //   startedPlaying = true;
//   //   return true;
//   // }

//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }

//   bool isLoading = true;

//   var prefs;

//   final List<String> navigators = [
//     "View History",
//   ];
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     // final Alertbtns = Provider.of<AlertBTNS>(context, listen: false);
//     final formattedDate =
//         DateFormat.d().format(DateTime.now()); // Day of the month
//     final formattedMonth =
//         DateFormat.yMMMM().format(DateTime.now()); // Full month name
//     final formattedYear = DateFormat.y().format(DateTime.now()); // Year
//     final formattedTime = DateFormat('hh:mm:ss a')
//         .format(DateTime.now()); // Time in 24-hour format

//     final formattedDateTime =
//         '$formattedDate $formattedMonth at $formattedTime UTC+5';
//     final notificationCounter =
//         Provider.of<NotificationCounter>(context, listen: false);
//     FirebaseFirestore.instance
//         .collection('notifications')
//         .where('isRead', isEqualTo: false)
//         .snapshots()
//         .listen((snapshot) {
//       notificationCounter.updateCount(snapshot.docs.length);
//     });
//     final visitorProvider =
//         Provider.of<VisitorProvider>(context, listen: false);
//     FirebaseFirestore.instance
//         .collection('notifications')
//         .where('description',
//             isEqualTo: 'please confirm identity of your friend')
//         .orderBy('pressedTime', descending: true)
//         .snapshots()
//         .listen((snapshot) {
//       var doc = snapshot.docs.first;
//       var data = doc.data();
//       String id = data['id'];
//       visitorProvider.notiDocId = doc.id;

//       visitorProvider.fetchNotiInfo(id);
//       visitorProvider.showVisitorDialogs(true);
//     });
//     final announceMentProvider =
//         Provider.of<AnnouncementProvider>(context, listen: false);
//     FirebaseFirestore.instance
//         .collection('Annoucements')
//         .orderBy('pressedTime', descending: true)
//         // .limit(1)
//         .snapshots()
//         .listen((snapshot) {
//       print("SNAPSHOT +++++$snapshot");
//       if (snapshot.docs.isNotEmpty) {
//         print("NOT EMPTY");
//         var doc = snapshot.docs.first;
//         var data = doc.data();

//         var seenUids = data['seenUids'] ?? [];

//         if (seenUids.contains(FirebaseAuth.instance.currentUser!.uid)) {
//           print("FOUND");
//           announceMentProvider.announcementDialog(false);
//         } else {
//           print("NOT FOUND");
//           var id = doc.id;
//           announceMentProvider.fetchAnnouncement(id);
//           announceMentProvider.announcementDialog(true);
//         }
//       } else {
//         print("EMPTY");
//         announceMentProvider.announcementDialog(false);
//       }
//     });

//     return _isLoading
//         ? const Center(child: CircularProgressIndicator())
//         : isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : Scaffold(
//                 key: _key,
//                 drawer: const DrawerWidg(),
//                 appBar: AppBar(
//                   backgroundColor: Colors.white,
//                   elevation: 0,
//                   centerTitle: true,
//                   leading: const Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: Padding(
//                       padding: EdgeInsets.all(1.0),
//                       child: Image(
//                         image: AssetImage("assets/Images/izmir.jpg"),
//                         height: 70,
//                         width: 70,
//                       ),
//                     ),
//                   ),
//                   title: const Text(
//                     'Home',
//                     style: TextStyle(
//                         color: Color(0xff212121),
//                         fontWeight: FontWeight.w700,
//                         fontSize: 24),
//                   ),
//                   actions: <Widget>[
//                     IconButton(
//                       icon: Stack(
//                         children: <Widget>[
//                           const Icon(
//                             Icons.notifications,
//                             color: Colors.black,
//                           ),
//                           Consumer<NotificationCounter>(
//                             builder: (context, counter, child) {
//                               if (notificationCounter.count >
//                                   0) // Show the badge only if there are unread notifications
//                               {
//                                 return Positioned(
//                                   right: 0,
//                                   top: 0,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(2),
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors
//                                           .red, // You can customize the badge color
//                                     ),
//                                     constraints: const BoxConstraints(
//                                       minWidth: 15,
//                                       minHeight: 15,
//                                     ),
//                                     child: Text(
//                                       "${notificationCounter.count}",
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize:
//                                             12, // You can customize the font size
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 return Container();
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                       onPressed: () async {
//                         // Handle tapping on the notifications icon
//                         setState(() {
//                           notification_count = 0;
//                         });
//                         await Navigator.push(
//                           context,
//                           PageTransition(
//                             duration: const Duration(milliseconds: 700),
//                             type: PageTransitionType.rightToLeftWithFade,
//                             child: const Notifications(),
//                           ),
//                         );
//                         setState(() {
//                           updateAllIsReadStatus(true);
//                           notification_count = 0;
//                         });
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.menu,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {
//                           _key.currentState!.openDrawer();
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//                 body: Stack(
//                   children: [
//                     Column(
//                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         // crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           // if (visitorProvider.showVisitorDialog == true)
//                           //   Positioned(
//                           //     top: 50,
//                           //     bottom: 50,
//                           //     left: 50,
//                           //     right: 50,
//                           //     child: Container(
//                           //       height: 300,
//                           //       width: 300,
//                           //       color: Colors.red,
//                           //     ),
//                           //   ),
//                           Container(
//                             decoration: const BoxDecoration(
//                                 // borderRadius: BorderRadius.circular(15),
//                                 // image: DecorationImage(
//                                 //     alignment: Alignment.bottomRight,
//                                 //     image: AssetImage(
//                                 //         ''),
//                                 //     fit: BoxFit.contain),
//                                 ),
//                             width: MediaQuery.of(context).size.width,
//                             height: MediaQuery.of(context).size.height / 4,
//                             child: Card(
//                               elevation: 1,
//                               color: const Color.fromARGB(255, 255, 255, 255),
//                               child: ClipRRect(
//                                 // borderRadius: BorderRadius.circular(15),
//                                 child: AspectRatio(
//                                   aspectRatio: 16 /
//                                       9, // You can adjust this aspect ratio as needed
//                                   child: YoutubePlayer(
//                                       controller: y_controller,
//                                       showVideoProgressIndicator: true,
//                                       bottomActions: [
//                                         const SizedBox(width: 8.0),
//                                         CurrentPosition(),
//                                         const SizedBox(width: 175.0),
//                                         RemainingDuration(),
//                                         const SizedBox(width: 10.0),
//                                         const PlaybackSpeedButton(),
//                                       ]),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Padding(
//                           //   padding: const EdgeInsets.only(
//                           //       top: 3.0, bottom: 1),
//                           //   child: Container(
//                           //     decoration: BoxDecoration(
//                           //       borderRadius: BorderRadius.circular(
//                           //           10.0), // Adjust the radius as needed

//                           //       color: const Color.fromARGB(
//                           //           179, 229, 229, 229),
//                           //     ),
//                           //     // width: 220,
//                           //     child: Padding(
//                           //       padding: const EdgeInsets.all(2.0),
//                           //       child: Container(
//                           //         width: 300,
//                           //         decoration: BoxDecoration(
//                           //           borderRadius: BorderRadius.circular(
//                           //               10.0), // Adjust the radius as needed

//                           //           color: Color.fromRGBO(
//                           //               222, 226, 231, 1),
//                           //         ),
//                           //         child: Padding(
//                           //           padding: const EdgeInsets.all(2.0),
//                           //           child: Align(
//                           //             child: Text(
//                           //                 "What are you Looking for ?"),
//                           //             alignment: Alignment.center,
//                           //           ),
//                           //         ),
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
//                           const Row(
//                             // mainAxisAlignment: MainAxisAlignment.start,
//                             // crossAxisAlignment:
//                             //     CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 8, right: 4, top: 5, bottom: 5),
//                                 child: Text(
//                                   "Emergency Calls",
//                                   style: TextStyle(fontWeight: FontWeight.w900),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // Expanded(
//                           //   child:
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 2, horizontal: 8),
//                             child:

//                                 //  Card(
//                                 //   color: Colors.grey[200],
//                                 //   shape: RoundedRectangleBorder(
//                                 //     borderRadius:
//                                 //         BorderRadius.circular(20),
//                                 //   ),
//                                 //   elevation: 20,
//                                 //   child: Padding(
//                                 //     padding: const EdgeInsets.all(4.0),
//                                 //     child:

//                                 SizedBox(
//                               height: MediaQuery.of(context).size.height / 6.8,
//                               width: double.infinity,
//                               child: Column(
//                                 // mainAxisAlignment:
//                                 //     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                         top: 5, bottom: 10, left: 1, right: 1),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               // top: 5,
//                                               // bottom: 10,
//                                               left: 1,
//                                               right: 1),
//                                           child: SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2.2,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 18,
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 color: const Color.fromRGBO(
//                                                     15, 39, 127, 1),
//                                                 // gradient:
//                                                 //     LinearGradient(
//                                                 //   colors: [
//                                                 //     Color.fromRGBO(
//                                                 //         242, 13, 54, 1),
//                                                 //     Color.fromRGBO(104,
//                                                 //         109, 224, 1),
//                                                 //   ],
//                                                 // ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10.0),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.black
//                                                         .withOpacity(
//                                                             0.3), // Shadow color
//                                                     offset: const Offset(1,
//                                                         4), // Offset of the shadow (x, y)
//                                                     blurRadius:
//                                                         5, // Blur radius
//                                                   ),
//                                                 ],
//                                               ),
//                                               child: TextButton.icon(
//                                                 onPressed: () async {
//                                                   // Alertbtns
//                                                   //     .showMedConfirmDialogs(
//                                                   //         true);
//                                                   // if (Alertbtns
//                                                   //         .showMedConfirmDialog ==
//                                                   //     true) {
//                                                   medAlertMe('button-two');
//                                                   // } else {
//                                                   //   null;
//                                                   //   Alertbtns
//                                                   //       .showMedConfirmDialogs(
//                                                   //           false);
//                                                   // }
//                                                 },
//                                                 label: Text(
//                                                     '  ' + buttonLabels[1],
//                                                     style: const TextStyle(
//                                                         color: Colors.white,
//                                                         fontWeight:
//                                                             FontWeight.bold)),
//                                                 icon: const Icon(
//                                                   Icons.emergency,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.all(1.0),
//                                           child: SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2.2,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 18,
//                                             child: Container(
//                                               // height: 50,
//                                               decoration: BoxDecoration(
//                                                 color: const Color.fromRGBO(
//                                                     15, 39, 127, 1),

//                                                 // gradient:
//                                                 //     LinearGradient(
//                                                 //   colors: [
//                                                 //     Color.fromRGBO(
//                                                 //         242, 13, 54, 1),
//                                                 //     Color.fromRGBO(104,
//                                                 //         109, 224, 1),
//                                                 //   ],
//                                                 // ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(10.0),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.black
//                                                         .withOpacity(
//                                                             0.3), // Shadow color
//                                                     offset: const Offset(1,
//                                                         4), // Offset of the shadow (x, y)
//                                                     blurRadius:
//                                                         5, // Blur radius
//                                                   ),
//                                                 ],
//                                               ),
//                                               child: TextButton.icon(
//                                                 onPressed: () async {
//                                                   // Alertbtns
//                                                   //     .showGroConfirmDialogs(
//                                                   //         true);
//                                                   // if (Alertbtns
//                                                   //         .showGroConfirmDialog ==
//                                                   //     true) {
//                                                   groAlertMe("button-three");
//                                                   // } else {
//                                                   //   null;
//                                                   //   Alertbtns
//                                                   //       .showGroConfirmDialogs(
//                                                   //           false);
//                                                   // }
//                                                 },
//                                                 label: Text(
//                                                   '  ' + buttonLabels[2],
//                                                   style: const TextStyle(
//                                                       color: Colors.white,
//                                                       fontWeight:
//                                                           FontWeight.bold),
//                                                 ),
//                                                 icon: const Icon(
//                                                   Icons
//                                                       .local_grocery_store_sharp,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(1.0),
//                                     child: SizedBox(
//                                       width:
//                                           MediaQuery.of(context).size.width / 1,
//                                       height:
//                                           MediaQuery.of(context).size.height /
//                                               18,
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: const Color.fromRGBO(
//                                               15, 39, 127, 1),
//                                           // gradient:
//                                           //     LinearGradient(
//                                           //   colors: [
//                                           //     Color.fromRGBO(
//                                           //         242, 13, 54, 1),
//                                           //     Color.fromRGBO(104,
//                                           //         109, 224, 1),
//                                           //   ],
//                                           // ),
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           // boxShadow: [
//                                           //   BoxShadow(
//                                           //     color: Colors.black
//                                           //         .withOpacity(
//                                           //             0.3), // Shadow color
//                                           //     offset: Offset(1,
//                                           //         4), // Offset of the shadow (x, y)
//                                           //     blurRadius:
//                                           //         5, // Blur radius
//                                           //   ),
//                                           // ],
//                                         ),
//                                         child: TextButton.icon(
//                                           onPressed: () async {
//                                             // Alertbtns.showSecConfirmDialogs(
//                                             //     true);
//                                             // if (Alertbtns
//                                             //         .showSecConfirmDialog ==
//                                             //     true) {
//                                             secAlertMe("button-one");
//                                             // } else {
//                                             //   null;
//                                             //   Alertbtns.showSecConfirmDialogs(
//                                             //       false);
//                                             // }
//                                           },
//                                           icon: const Icon(
//                                             Icons.security,
//                                             // Icons.home_repair_service,
//                                             color: Colors.white,
//                                           ),
//                                           label: Text('  ' + buttonLabels[0],
//                                               style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontWeight: FontWeight.bold)),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             //   ),
//                             // ),
//                           ),
//                           // ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 0, vertical: 3),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 InkWell(
//                                   onTap: () async {
//                                     //  await generatePDF();
//                                     updateMainIcons();
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 // PDFViewerPage(pdfPath: filePath)
//                                                 const Visitors()));
//                                   },
//                                   child: SizedBox(
//                                     // color: Colors.green,
//                                     // height: 80,
//                                     width:
//                                         MediaQuery.of(context).size.width / 4,
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           height: 50,
//                                           width: 50,
//                                           decoration: BoxDecoration(
//                                               color: const Color.fromRGBO(
//                                                   236, 238, 240, 1),
//                                               borderRadius:
//                                                   BorderRadius.circular(30)),
//                                           child: const Icon(Icons.car_rental,
//                                               //  Icons.table_chart_outlined,
//                                               color: Color.fromRGBO(
//                                                   15, 39, 127, 1)),
//                                         ),
//                                         const Padding(
//                                           padding: EdgeInsets.all(5.0),
//                                           child: Text(
//                                             'Visitors',
//                                             // "Bills",
//                                             style: TextStyle(
//                                                 fontSize: 11,
//                                                 // ),
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     updateMainIcons();
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const Discounts()));
//                                   },
//                                   child: SizedBox(
//                                     // color: Colors.green,
//                                     // height: 80,
//                                     width:
//                                         MediaQuery.of(context).size.width / 4,
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           height: 50,
//                                           width: 50,
//                                           decoration: BoxDecoration(
//                                               color: const Color.fromRGBO(
//                                                   236, 238, 240, 1),
//                                               borderRadius:
//                                                   BorderRadius.circular(30)),
//                                           child: const Icon(
//                                               Icons.wb_sunny_outlined,
//                                               color: Color.fromRGBO(
//                                                   15, 39, 127, 1)),
//                                         ),
//                                         const Padding(
//                                           padding: EdgeInsets.all(5.0),
//                                           child: Text(
//                                             "Discount",
//                                             style: TextStyle(
//                                                 fontSize: 11,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     updateMainIcons();
//                                     Navigator.push(
//                                         context,
//                                         PageTransition(
//                                             duration: const Duration(
//                                                 milliseconds: 700),
//                                             type: PageTransitionType
//                                                 .rightToLeftWithFade,
//                                             child: const Complainform()));
//                                   },
//                                   child: SizedBox(
//                                     // color: Colors.green,
//                                     // height: 80,
//                                     width:
//                                         MediaQuery.of(context).size.width / 4,
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               color: const Color.fromRGBO(
//                                                   236, 238, 240, 1),
//                                               borderRadius:
//                                                   BorderRadius.circular(30)),
//                                           height: 50,
//                                           width: 50,
//                                           child: const Icon(
//                                               Icons.line_style_outlined,
//                                               //   Icons.line_style_sharp,
//                                               color: Color.fromRGBO(
//                                                   15, 39, 127, 1)),
//                                         ),
//                                         const Padding(
//                                           padding: EdgeInsets.all(5.0),
//                                           child: FittedBox(
//                                             child: Text(
//                                               "Complaint",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),

//                                 InkWell(
//                                     child: SizedBox(
//                                       // color: Colors.green,
//                                       // height: 80,
//                                       width:
//                                           MediaQuery.of(context).size.width / 4,
//                                       child: Column(
//                                         children: [
//                                           Container(
//                                             height: 50,
//                                             width: 50,
//                                             decoration: BoxDecoration(
//                                                 color: const Color.fromRGBO(
//                                                     236, 238, 240, 1),
//                                                 borderRadius:
//                                                     BorderRadius.circular(30)),
//                                             child: const Icon(Icons.home,
//                                                 color: Color.fromRGBO(
//                                                     15, 39, 127, 1)),
//                                           ),
//                                           const Padding(
//                                             padding: EdgeInsets.all(5.0),
//                                             child: FittedBox(
//                                               child: Text(
//                                                 "Not Home",
//                                                 style: TextStyle(
//                                                     fontSize: 12,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     onTap: () async {
//                                       updateMainIcons();

//                                       var connectivityResult =
//                                           await (Connectivity()
//                                               .checkConnectivity());
//                                       print(
//                                           "Connectivity == ${connectivityResult.toString()}");
//                                       if (connectivityResult ==
//                                           ConnectivityResult.none) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                           content: const Text(
//                                             "This Feature is not available in Offline mode",
//                                             style:
//                                                 TextStyle(color: Colors.black),
//                                           ),
//                                           action: SnackBarAction(
//                                             label: 'OK',
//                                             textColor: Colors.black,
//                                             onPressed: () {},
//                                           ),
//                                           backgroundColor: Colors.grey[400],
//                                         ));
//                                       } else {
//                                         try {
//                                           // EasyLoading.show(status: ' Processing');
//                                           // Attempt to make a GET request to a reliable server
//                                           final response = await http.get(
//                                               Uri.parse(
//                                                   'https://www.google.com'));

//                                           if (response.statusCode == 200) {
//                                             EasyLoading.dismiss();
//                                             if (status == false) {
//                                               notHomeStatusFalse();

//                                               // _selectDate(context);
//                                             } else if (status
//                                                 .toString()
//                                                 .isEmpty) {
//                                               notHomeStatusFalse();

//                                               // _selectDate(context);
//                                             } else if (status == true) {
//                                               cancelRequest(formattedTime);
//                                             }
//                                           } else {
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(SnackBar(
//                                               content: const Text(
//                                                 "Your Internet connection is not stable. Please try again later",
//                                                 style: TextStyle(
//                                                     color: Colors.black),
//                                               ),
//                                               action: SnackBarAction(
//                                                 label: 'OK',
//                                                 textColor: Colors.black,
//                                                 onPressed: () {},
//                                               ),
//                                               backgroundColor: Colors.grey[400],
//                                             ));
//                                             EasyLoading.dismiss();
//                                           }
//                                         } catch (e) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             content: const Text(
//                                               "Your Internet connection is not stable. Please try again later",
//                                               style: TextStyle(
//                                                   color: Colors.black),
//                                             ),
//                                             action: SnackBarAction(
//                                               label: 'OK',
//                                               textColor: Colors.black,
//                                               onPressed: () {},
//                                             ),
//                                             backgroundColor: Colors.grey[400],
//                                           ));
//                                           EasyLoading.dismiss();
//                                         }
//                                       }
//                                     }
//                                     //hello

//                                     ), //
//                               ],
//                             ),
//                           ),
//                           const Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 8, bottom: 3, right: 1, top: 6),
//                                 child: Text(
//                                   "Trending Properties",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w800),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8.0),
//                             child: InkWell(
//                               onTap: () {},
//                               child: SizedBox(
//                                 // color: Colors.amber,
//                                 height: MediaQuery.of(context).size.width / 3,
//                                 child: ListView.builder(
//                                   itemCount: plotsDetails.length,
//                                   scrollDirection: Axis.horizontal,
//                                   itemBuilder: (context, index) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 10,
//                                         right: 6,
//                                         top: 6,
//                                         bottom: 2,
//                                       ),
//                                       child: Container(
//                                         height:
//                                             MediaQuery.of(context).size.height /
//                                                 3.2,
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 1.3,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                               15.0), // Adjust the radius as needed
//                                           color: const Color.fromRGBO(
//                                               236, 238, 240, 1),
//                                         ),
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 8, top: 3, bottom: 3),
//                                           child: Row(
//                                             // mainAxisAlignment:
//                                             //     MainAxisAlignment
//                                             //         .spaceBetween,
//                                             children: [
//                                               // Padding(
//                                               // padding:
//                                               // const EdgeInsets.all(8.0),
//                                               // child:
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                                 child: Image.network(
//                                                   plotsDetails[index]['image'],
//                                                   // height: 300,
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width /
//                                                       2.5,
//                                                 ),
//                                               ),
//                                               // ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                   left: 2,
//                                                   right: 2,
//                                                   top: 3,
//                                                   // bottom: 2,
//                                                 ),
//                                                 child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       SizedBox(
//                                                         height: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .height /
//                                                             9,
//                                                         width: MediaQuery.of(
//                                                                     context)
//                                                                 .size
//                                                                 .width /
//                                                             3,
//                                                         child: ListTile(
//                                                           onTap: () {
//                                                             updateTrendingP();
//                                                             Navigator.push(
//                                                                 context,
//                                                                 PageTransition(
//                                                                     duration: const Duration(
//                                                                         milliseconds:
//                                                                             700),
//                                                                     type: PageTransitionType
//                                                                         .rightToLeftWithFade,
//                                                                     child: PlotsDetail(
//                                                                         ids: plotsDetails[index]
//                                                                             [
//                                                                             'id'])));
//                                                           },
//                                                           title: Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               FittedBox(
//                                                                 child: Text(
//                                                                   "PKR " +
//                                                                       plotsDetails[
//                                                                               index]
//                                                                           [
//                                                                           'price'],
//                                                                   style: const TextStyle(
//                                                                       fontSize:
//                                                                           10,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 5,
//                                                               ),
//                                                               FittedBox(
//                                                                 child: Text(
//                                                                   plotsDetails[
//                                                                           index]
//                                                                       [
//                                                                       'address'],
//                                                                   style: const TextStyle(
//                                                                       fontSize:
//                                                                           10,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold,
//                                                                       color: Colors
//                                                                           .black45),
//                                                                 ),
//                                                               ),
//                                                               const SizedBox(
//                                                                 height: 5,
//                                                               ),
//                                                               FittedBox(
//                                                                 child: Text(
//                                                                   "${plotsDetails[index]['area']}, ${plotsDetails[index]['room']},\n${plotsDetails[index]['bath']}",
//                                                                   style:
//                                                                       const TextStyle(
//                                                                     fontSize:
//                                                                         12,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           //subtitle: ,
//                                                         ),
//                                                       ),
//                                                     ]),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ]),
//                     Consumer<VisitorProvider>(
//                         builder: (context, counter, child) {
//                       if (visitorProvider.showVisitorDialog == true) {
//                         // visitorProvider.playAlarmSound();
//                         return visitorAlertBox(
//                             visitorProvider: visitorProvider);
//                       } else {
//                         return Container();
//                       }
//                     }),
//                     Consumer<AnnouncementProvider>(
//                       builder: (context, counter, child) {
//                         if (announceMentProvider.showAnnouncementDialog ==
//                             true) {
//                           return AnnouncementAlertBox(
//                               announceMentProvider: announceMentProvider);
//                         } else {
//                           return Container(); // Return an empty container as a placeholder
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               );
//     // ));
//   }

//   void notHomeStatusFalse() {
//     showDialog(
//         context: context,
//         builder: (context) => Center(
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height / 1.65,
//                 // Adjust the width as needed
//                 child: FutureBuilder(
//                     future: SharedPreferences.getInstance(),
//                     builder: (context, AsyncSnapshot snapshot) {
//                       var userinfo = json.decode(
//                           snapshot.data.getString('userinfo') as String);
//                       final myListData = [
//                         userinfo["name"],
//                         userinfo["phoneNo"],
//                         userinfo["address"],
//                         userinfo["fphoneNo"],
//                         userinfo["fname"],
//                         userinfo["designation"],
//                         userinfo["age"],
//                         userinfo["uid"],
//                         userinfo["owner"],
//                         userinfo["email"]
//                       ];
//                       return AlertDialog(
//                         title: const Text('Not Home'),
//                         content: Column(
//                           children: [
//                             const Text(
//                                 'Select the date when you will be at home'),
//                             const SizedBox(height: 10),
//                             TextFormField(
//                               controller: currentdate,
//                               readOnly: true,
//                               decoration: const InputDecoration(
//                                 labelText: 'From',
//                               ),
//                             ),
//                             const SizedBox(height: 25),
//                             TextFormField(
//                               controller: _dateController,
//                               readOnly: true,
//                               onTap: () {
//                                 if (newSelectedDate == DateTime.now() ||
//                                     status == false) {
//                                   print(
//                                       "New Selected Date    $newSelectedDate");
//                                   _selectDate(context);
//                                 } else {
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(SnackBar(
//                                     content: const Text(
//                                       "You can not send another request",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     action: SnackBarAction(
//                                       label: 'OK',
//                                       textColor: Colors.black,
//                                       onPressed: () {},
//                                     ),
//                                     backgroundColor: Colors.grey[400],
//                                   ));
//                                 }
//                               },
//                               decoration: InputDecoration(
//                                 labelText: 'To',
//                                 suffixIcon: IconButton(
//                                   icon: const Icon(Icons.calendar_today),
//                                   onPressed: () {
//                                     if (newSelectedDate == DateTime.now() ||
//                                         status == false) {
//                                       print(
//                                           "New Selected Date    $newSelectedDate");
//                                       _selectDate(context);
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                         content: const Text(
//                                           "You can not send another request",
//                                           style: TextStyle(color: Colors.black),
//                                         ),
//                                         action: SnackBarAction(
//                                           label: 'OK',
//                                           textColor: Colors.black,
//                                           onPressed: () {},
//                                         ),
//                                         backgroundColor: Colors.grey[400],
//                                       ));
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         actions: <Widget>[
//                           TextButton(
//                             onPressed: () {
//                               if (DateTime.now() != toField || status == true) {
//                                 print("feild == $toField");
//                                 // Uncomment this code to show the confirmation dialog
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       title: const Text(
//                                         'Confirmation',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       content: _daysDifference + 1 == 1
//                                           ? Text(
//                                               'You will not be home for ${_daysDifference + 1} day, Security will look after your house.\nPress YES to send your request.',
//                                             )
//                                           : Text(
//                                               'You will not be home for ${_daysDifference + 1} days, Security will look after your house.\nPress YES to send your request.',
//                                             ),
//                                       actions: <Widget>[
//                                         ElevatedButton(
//                                           style: ButtonStyle(
//                                             backgroundColor:
//                                                 MaterialStateProperty.all(
//                                                     Colors.black),
//                                           ),
//                                           onPressed: () async {
//                                             SharedPreferences token =
//                                                 await SharedPreferences
//                                                     .getInstance();
//                                             String FCMtoken =
//                                                 token.getString('tokens')!;

//                                             final mainCollectionQuery =
//                                                 await FirebaseFirestore.instance
//                                                     .collection(
//                                                         "UserRequest") // Replace with your main collection
//                                                     .where("parentID",
//                                                         isEqualTo: userinfo[
//                                                             'parentID'])
//                                                     .get();

//                                             if (mainCollectionQuery
//                                                 .docs.isNotEmpty) {
//                                               mainCollectionQuery.docs
//                                                   .forEach((mainDoc) async {
//                                                 final subcollectionRef = mainDoc
//                                                     .reference
//                                                     .collection("FMData");

//                                                 final subcollectionQuery =
//                                                     await subcollectionRef
//                                                         .where("owner",
//                                                             isEqualTo: userinfo[
//                                                                 'owner'])
//                                                         .get();

//                                                 if (subcollectionQuery
//                                                     .docs.isNotEmpty) {
//                                                   print("oka");
//                                                   // Process the first document
//                                                   var data = subcollectionQuery
//                                                       .docs[0]
//                                                       .data();
//                                                   String parentId =
//                                                       data['parentID'];
//                                                   DocumentSnapshot parentDoc =
//                                                       await FirebaseFirestore
//                                                           .instance
//                                                           .collection(
//                                                               'UserRequest')
//                                                           .doc(parentId)
//                                                           .get();
//                                                   if (parentDoc.exists) {
//                                                     // Step 2: Access the subcollection
//                                                     QuerySnapshot
//                                                         subcollectionSnapshot =
//                                                         await parentDoc
//                                                             .reference
//                                                             .collection(
//                                                                 'FMData')
//                                                             .limit(2)
//                                                             .get();
//                                                     if (subcollectionSnapshot
//                                                         .docs.isNotEmpty) {
//                                                       // Access subcollection document data for the first document
//                                                       Map<String, dynamic>
//                                                           firstDocData =
//                                                           subcollectionSnapshot
//                                                                   .docs[0]
//                                                                   .data()
//                                                               as Map<String,
//                                                                   dynamic>;

//                                                       setState(() {
//                                                         fmName = firstDocData[
//                                                             'Name'];
//                                                         fmphoneNo =
//                                                             firstDocData[
//                                                                 'phonenumber'];
//                                                       });
//                                                       print(
//                                                           'First Subcollection Document Data: $firstDocData');

//                                                       // Check if there is a second document before accessing
//                                                       if (subcollectionSnapshot
//                                                               .docs.length >
//                                                           1) {
//                                                         // Access subcollection document data for the second document
//                                                         Map<String, dynamic>
//                                                             secondDocData =
//                                                             subcollectionSnapshot
//                                                                     .docs[1]
//                                                                     .data()
//                                                                 as Map<String,
//                                                                     dynamic>;
//                                                         print(
//                                                             'Second Subcollection Document Data: $secondDocData');
//                                                         setState(() {
//                                                           fmName1 =
//                                                               secondDocData[
//                                                                   'Name'];
//                                                           fmphoneNo1 =
//                                                               secondDocData[
//                                                                   'phonenumber'];
//                                                         });

//                                                         print(
//                                                             "FM 1 $fmName1    +++++++++++   $fmphoneNo1");
//                                                       } else {
//                                                         print(
//                                                             'Subcollection has only one document.');
//                                                       }
//                                                     } else {
//                                                       print(
//                                                           'Subcollection is empty.');
//                                                     }
//                                                   } else {
//                                                     // print(
//                                                     //     'Document with ID $parentId does not exist.')
//                                                   }
//                                                   String month =
//                                                       DateFormat('MM').format(
//                                                           DateTime.now());

//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection("not_Home")
//                                                       .add({
//                                                     'FCMtoken': FCMtoken,
//                                                     'time': DateTime.now(),
//                                                     'nh': false,
//                                                     "edit": false,
//                                                     'pressedTime':
//                                                         DateTime.now(),
//                                                     "fmName": fmName,
//                                                     "fmName1": fmName1,
//                                                     "fmphoneNo": fmphoneNo,
//                                                     "fmphoneNo1": fmphoneNo1,
//                                                     // 'from': currentdate.text,
//                                                     'from':
//                                                         "${DateTime.now().year}-$month-${DateTime.now().day}",
//                                                     'to': _dateController.text,
//                                                     "days": _daysDifference,
//                                                     'Name':
//                                                         '${userinfo['name']}',
//                                                     'Email':
//                                                         '${userinfo['email']}',
//                                                     'ID': '${userinfo["uid"]}',
//                                                     'PhoneNo':
//                                                         '${userinfo["phoneNo"]}',
//                                                     'Address':
//                                                         '${userinfo["address"]}',
//                                                     "fname": userinfo['fname'],
//                                                     "fPhoneNo":
//                                                         userinfo['fphoneNo'],
//                                                     'Designation':
//                                                         '${userinfo["designation"]}',
//                                                     'Age': '${userinfo["age"]}',
//                                                     'Owner':
//                                                         '${userinfo["owner"]}',
//                                                     'noti': true,
//                                                     'Status': true,
//                                                     'uid': userinfo['uid'],
//                                                     'cancelled': false,
//                                                   }).then((DocumentReference
//                                                           document) async {
//                                                     print("ID= ${document.id}");

//                                                     String formattedTime =
//                                                         DateFormat('h:mm:ss a')
//                                                             .format(
//                                                                 DateTime.now());
//                                                     await FirebaseFirestore
//                                                         .instance
//                                                         .collection(
//                                                             "notifications")
//                                                         .add({
//                                                       'isRead': false,
//                                                       'id': document.id,
//                                                       'date':
//                                                           "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
//                                                       'description':
//                                                           "Not at Home is on !",
//                                                       'image':
//                                                           "https://blog.udemy.com/wp-content/uploads/2014/05/bigstock-test-icon-63758263.jpg",
//                                                       'time': formattedTime,
//                                                       'title': 'Not at Home',
//                                                       'uid': userinfo['uid'],
//                                                       'pressedTime':
//                                                           DateTime.now(),
//                                                     }).then((value) => {
//                                                               Navigator.push(
//                                                                   context,
//                                                                   MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             TabsScreen(
//                                                                       index: 0,
//                                                                     ),
//                                                                   )),
//                                                               ScaffoldMessenger.of(context).showSnackBar(
//                                                                   SnackBar(
//                                                                       action:
//                                                                           SnackBarAction(
//                                                                         label:
//                                                                             "Ok",
//                                                                         textColor:
//                                                                             Colors.black,
//                                                                         onPressed:
//                                                                             () {},
//                                                                       ),
//                                                                       backgroundColor:
//                                                                           Colors.grey[
//                                                                               400],
//                                                                       content: const Text(
//                                                                           "Your Details has been sent ",
//                                                                           style:
//                                                                               TextStyle(color: Colors.black)))),
//                                                             });
//                                                   });
//                                                 } else {
//                                                   String month =
//                                                       DateFormat('MM').format(
//                                                           DateTime.now());
//                                                   await FirebaseFirestore
//                                                       .instance
//                                                       .collection("not_Home")
//                                                       .add({
//                                                     'FCMtoken': FCMtoken,
//                                                     'time': DateTime.now(),
//                                                     'nh': false,
//                                                     "edit": false,
//                                                     'pressedTime':
//                                                         DateTime.now(),
//                                                     "fmName": "",
//                                                     "fmName1": "",
//                                                     "fmphoneNo": "",
//                                                     "fmphoneNo1": "",
//                                                     // 'from': currentdate.text,
//                                                     'from':
//                                                         "${DateTime.now().year}-$month-${DateTime.now().day}",

//                                                     'to': _dateController.text,
//                                                     "days": _daysDifference,
//                                                     'Name':
//                                                         '${userinfo['name']}',
//                                                     'Email':
//                                                         '${userinfo['email']}',
//                                                     'ID': '${userinfo["uid"]}',
//                                                     'PhoneNo':
//                                                         '${userinfo["phoneNo"]}',
//                                                     'Address':
//                                                         '${userinfo["address"]}',
//                                                     "fname": userinfo['fname'],
//                                                     "fPhoneNo":
//                                                         userinfo['fphoneNo'],
//                                                     'Designation':
//                                                         '${userinfo["designation"]}',
//                                                     'Age': '${userinfo["age"]}',
//                                                     'Owner':
//                                                         '${userinfo["owner"]}',
//                                                     'noti': true,
//                                                     'Status': true,
//                                                     'uid': userinfo['uid'],
//                                                     'cancelled': false,
//                                                   }).then((DocumentReference
//                                                           document) async {
//                                                     print("ID= ${document.id}");

//                                                     String formattedTime =
//                                                         DateFormat('h:mm:ss a')
//                                                             .format(
//                                                                 DateTime.now());
//                                                     await FirebaseFirestore
//                                                         .instance
//                                                         .collection(
//                                                             "notifications")
//                                                         .add({
//                                                       'isRead': false,
//                                                       'id': document.id,
//                                                       'date':
//                                                           "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
//                                                       'description':
//                                                           "Not at Home is on !",
//                                                       'image':
//                                                           "https://blog.udemy.com/wp-content/uploads/2014/05/bigstock-test-icon-63758263.jpg",
//                                                       'time': formattedTime,
//                                                       'title': 'Not at Home',
//                                                       'uid': userinfo['uid'],
//                                                       'pressedTime':
//                                                           DateTime.now(),
//                                                     });
//                                                   });

//                                                   Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             TabsScreen(
//                                                           index: 0,
//                                                         ),
//                                                       ));

//                                                   ScaffoldMessenger.of(context)
//                                                       .showSnackBar(SnackBar(
//                                                           action:
//                                                               SnackBarAction(
//                                                             label: "Ok",
//                                                             textColor:
//                                                                 Colors.black,
//                                                             onPressed: () {},
//                                                           ),
//                                                           backgroundColor:
//                                                               Colors.grey[400],
//                                                           content: const Text(
//                                                               "Your Details has been sent ",
//                                                               style: TextStyle(
//                                                                   color: Colors
//                                                                       .black))));
//                                                 }
//                                               });
//                                             } else {
//                                               print("main Document is empty");
//                                             }
//                                           },
//                                           child: const Text('Yes',
//                                               style: TextStyle(
//                                                   color: Colors.white)),
//                                         ),
//                                         ElevatedButton(
//                                           style: ButtonStyle(
//                                             backgroundColor:
//                                                 MaterialStateProperty.all(
//                                                     Colors.black),
//                                           ),
//                                           onPressed: () {
//                                             Navigator.of(context)
//                                                 .pop(); // Close the confirmation dialog
//                                           },
//                                           child: const Text('No',
//                                               style: TextStyle(
//                                                   color: Colors.white)),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         backgroundColor: Colors.grey[400],
//                                         content: const Text(
//                                             "You can not send another request",
//                                             style: TextStyle(
//                                                 color: Colors.black))));
//                               }
//                             },
//                             child: const Text('OK'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text("Cancel"),
//                           ),
//                         ],
//                       );
//                     }),
//               ),
//             ));
//   }

//   // void notHomeStatusEmpty() {
//   //   showDialog(
//   //       context: context,
//   //       builder: (context) => Center(
//   //             child: SizedBox(
//   //               height: MediaQuery.of(context).size.height / 1.65,
//   //               // Adjust the width as needed
//   //               child: FutureBuilder(
//   //                   future: SharedPreferences.getInstance(),
//   //                   builder: (context, AsyncSnapshot snapshot) {
//   //                     var userinfo = json.decode(
//   //                         snapshot.data.getString('userinfo') as String);
//   //                     final myListData = [
//   //                       userinfo["name"],
//   //                       userinfo["phoneNo"],
//   //                       userinfo["address"],
//   //                       userinfo["fphoneNo"],
//   //                       userinfo["fname"],
//   //                       userinfo["designation"],
//   //                       userinfo["age"],
//   //                       userinfo["uid"],
//   //                       userinfo["owner"],
//   //                       userinfo["email"]
//   //                     ];
//   //                     return AlertDialog(
//   //                       title: const Text('Not Home'),
//   //                       content: Column(
//   //                         children: [
//   //                           const Text(
//   //                               'Select the date when you will be at home'),
//   //                           const SizedBox(height: 10),
//   //                           TextFormField(
//   //                             controller: currentdate,
//   //                             readOnly: true,
//   //                             decoration: const InputDecoration(
//   //                               labelText: 'From',
//   //                             ),
//   //                           ),
//   //                           const SizedBox(height: 25),
//   //                           TextFormField(
//   //                             controller: _dateController,
//   //                             readOnly: true,
//   //                             onTap: () {
//   //                               if (newSelectedDate == DateTime.now() ||
//   //                                   status == false) {
//   //                                 print(
//   //                                     "New Selected Date    $newSelectedDate");
//   //                                 _selectDate(context);
//   //                               } else {
//   //                                 ScaffoldMessenger.of(context).showSnackBar(
//   //                                     SnackBar(
//   //                                         backgroundColor: Colors.grey[400],
//   //                                         content: const Text(
//   //                                             "You can not send another request")));
//   //                               }
//   //                             },
//   //                             decoration: InputDecoration(
//   //                               labelText: 'To',
//   //                               suffixIcon: IconButton(
//   //                                 icon: const Icon(Icons.calendar_today),
//   //                                 onPressed: () {
//   //                                   if (newSelectedDate == DateTime.now() ||
//   //                                       status == false) {
//   //                                     print(
//   //                                         "New Selected Date    $newSelectedDate");
//   //                                     _selectDate(context);
//   //                                   } else {
//   //                                     ScaffoldMessenger.of(context)
//   //                                         .showSnackBar(SnackBar(
//   //                                             backgroundColor: Colors.grey[400],
//   //                                             content: const Text(
//   //                                                 "You can not send another request")));
//   //                                   }
//   //                                 },
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       actions: <Widget>[
//   //                         TextButton(
//   //                           onPressed: () {
//   //                             if (DateTime.now() != toField || status == true) {
//   //                               print("feild == $toField");
//   //                               // Uncomment this code to show the confirmation dialog
//   //                               showDialog(
//   //                                 context: context,
//   //                                 builder: (context) {
//   //                                   return AlertDialog(
//   //                                     title: const Text(
//   //                                       'Confirmation',
//   //                                       style: TextStyle(
//   //                                           fontWeight: FontWeight.bold),
//   //                                     ),
//   //                                     content: Text(
//   //                                       'You will not be home for ${_daysDifference + 1} days, Security will look after your house.\nPress YES to send your request.',
//   //                                     ),
//   //                                     actions: <Widget>[
//   //                                       ElevatedButton(
//   //                                         style: ButtonStyle(
//   //                                           backgroundColor:
//   //                                               MaterialStateProperty.all(
//   //                                                   Colors.black),
//   //                                         ),
//   //                                         onPressed: () async {
//   //                                           SharedPreferences token =
//   //                                               await SharedPreferences
//   //                                                   .getInstance();
//   //                                           String FCMtoken =
//   //                                               token.getString('tokens')!;

//   //                                           final mainCollectionQuery =
//   //                                               await FirebaseFirestore.instance
//   //                                                   .collection(
//   //                                                       "UserRequest") // Replace with your main collection
//   //                                                   .where("uid",
//   //                                                       isEqualTo:
//   //                                                           userinfo['uid'])
//   //                                                   .get();

//   //                                           if (mainCollectionQuery
//   //                                               .docs.isNotEmpty) {
//   //                                             mainCollectionQuery.docs
//   //                                                 .forEach((mainDoc) async {
//   //                                               final subcollectionRef = mainDoc
//   //                                                   .reference
//   //                                                   .collection("FMData");

//   //                                               final subcollectionQuery =
//   //                                                   await subcollectionRef
//   //                                                       .where("owner",
//   //                                                           isEqualTo: userinfo[
//   //                                                               'owner'])
//   //                                                       .get();

//   //                                               if (subcollectionQuery
//   //                                                   .docs.isNotEmpty) {
//   //                                                 // Process the first document
//   //                                                 var data = subcollectionQuery
//   //                                                     .docs[0]
//   //                                                     .data();
//   //                                                 setState(() {
//   //                                                   fmName = data['Name'];
//   //                                                   fmphoneNo = data['Phoneno'];
//   //                                                   print(
//   //                                                       "Document 1 - Name: $fmName, Phone No: $fmphoneNo");
//   //                                                 });

//   //                                                 // Process the second document if it exists
//   //                                                 if (subcollectionQuery
//   //                                                         .docs.length >
//   //                                                     1) {
//   //                                                   var data1 =
//   //                                                       subcollectionQuery
//   //                                                           .docs[1]
//   //                                                           .data();
//   //                                                   setState(() {
//   //                                                     fmName1 = data1['Name'];
//   //                                                     fmphoneNo1 =
//   //                                                         data1['Phoneno'];
//   //                                                     print(
//   //                                                         "Document 2 - Name: $fmName1, Phone No: $fmphoneNo1");
//   //                                                   });
//   //                                                 }
//   //                                                 String month =
//   //                                                     DateFormat('MM').format(
//   //                                                         DateTime.now());
//   //                                                 await FirebaseFirestore
//   //                                                     .instance
//   //                                                     .collection("not_Home")
//   //                                                     .add({
//   //                                                   'FCMtoken': FCMtoken,
//   //                                                   'time': DateTime.now(),
//   //                                                   'nh': false,
//   //                                                   "uid": userinfo['uid'],
//   //                                                   "edit": false,
//   //                                                   "fmName": fmName,
//   //                                                   'pressedTime':
//   //                                                       DateTime.now(),
//   //                                                   "fmName1": fmName1,
//   //                                                   "fmphoneNo": fmphoneNo,
//   //                                                   "fmphoneNo1": fmphoneNo1,
//   //                                                   // 'from': currentdate.text,
//   //                                                   'from':
//   //                                                       "${DateTime.now().year}-$month-${DateTime.now().day}",

//   //                                                   'to': _dateController.text,
//   //                                                   "days": _daysDifference,
//   //                                                   'Name':
//   //                                                       '${userinfo['name']}',
//   //                                                   'Email':
//   //                                                       '${userinfo['email']}',
//   //                                                   'ID': '${userinfo["uid"]}',
//   //                                                   'PhoneNo':
//   //                                                       '${userinfo["phoneNo"]}',
//   //                                                   'Address':
//   //                                                       '${userinfo["address"]}',
//   //                                                   "fname": userinfo['fname'],
//   //                                                   "fPhoneNo":
//   //                                                       userinfo['fphoneNo'],
//   //                                                   'Designation':
//   //                                                       '${userinfo["designation"]}',
//   //                                                   'Age': '${userinfo["age"]}',
//   //                                                   'Owner':
//   //                                                       '${userinfo["owner"]}',
//   //                                                   'noti': true,
//   //                                                   'Status': true,
//   //                                                   'cancelled': false,
//   //                                                 }).then((DocumentReference
//   //                                                         document) async {
//   //                                                   print("ID= ${document.id}");

//   //                                                   String formattedTime =
//   //                                                       DateFormat('h:mm:ss a')
//   //                                                           .format(
//   //                                                               DateTime.now());
//   //                                                   await FirebaseFirestore
//   //                                                       .instance
//   //                                                       .collection(
//   //                                                           "notifications")
//   //                                                       .add({
//   //                                                     'isRead': false,
//   //                                                     'id': document.id,
//   //                                                     'date':
//   //                                                         "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
//   //                                                     'description':
//   //                                                         "Not at Home is on !",
//   //                                                     'image':
//   //                                                         "https://blog.udemy.com/wp-content/uploads/2014/05/bigstock-test-icon-63758263.jpg",
//   //                                                     'time': formattedTime,
//   //                                                     'title': 'Not at Home',
//   //                                                     "uid": userinfo['uid'],
//   //                                                     'pressedTime':
//   //                                                         DateTime.now(),
//   //                                                   });
//   //                                                 });

//   //                                                 Navigator.push(
//   //                                                     context,
//   //                                                     MaterialPageRoute(
//   //                                                       builder: (context) =>
//   //                                                           TabsScreen(
//   //                                                         index: 0,
//   //                                                       ),
//   //                                                     ));

//   //                                                 ScaffoldMessenger.of(context)
//   //                                                     .showSnackBar(SnackBar(
//   //                                                         action:
//   //                                                             SnackBarAction(
//   //                                                           label: "Ok",
//   //                                                           onPressed: () {},
//   //                                                         ),
//   //                                                         backgroundColor:
//   //                                                             Colors.grey[400],
//   //                                                         content: const Text(
//   //                                                             "Your Details has been sent ")));
//   //                                               }
//   //                                             });
//   //                                           }
//   //                                         },
//   //                                         child: const Text('Yes',
//   //                                             style: TextStyle(
//   //                                                 color: Colors.white)),
//   //                                       ),
//   //                                       ElevatedButton(
//   //                                         style: ButtonStyle(
//   //                                           backgroundColor:
//   //                                               MaterialStateProperty.all(
//   //                                                   Colors.black),
//   //                                         ),
//   //                                         onPressed: () {
//   //                                           Navigator.of(context)
//   //                                               .pop(); // Close the confirmation dialog
//   //                                         },
//   //                                         child: const Text('No',
//   //                                             style: TextStyle(
//   //                                                 color: Colors.white)),
//   //                                       ),
//   //                                     ],
//   //                                   );
//   //                                 },
//   //                               );
//   //                             } else {
//   //                               ScaffoldMessenger.of(context).showSnackBar(
//   //                                   SnackBar(
//   //                                       backgroundColor: Colors.grey[400],
//   //                                       content: const Text(
//   //                                           "You can not send another request")));
//   //                             }
//   //                           },
//   //                           child: const Text('OK'),
//   //                         ),
//   //                         TextButton(
//   //                           onPressed: () {
//   //                             Navigator.pop(context);
//   //                           },
//   //                           child: const Text("Cancel"),
//   //                         ),
//   //                       ],
//   //                     );
//   //                   }),
//   //             ),
//   //           ));
//   // }

//   void cancelRequest(String formattedTime) {
//     if (status == true) {
//       print("$status+$toField+$docid+$fbToDate+$fbFromDate");

//       showDialog(
//           context: context,
//           builder: (context) => Center(
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height / 1.65,
//                   // Adjust the width as needed
//                   child: FutureBuilder(
//                       future: SharedPreferences.getInstance(),
//                       builder: (context, AsyncSnapshot snapshot) {
//                         var userinfo = json.decode(
//                             snapshot.data.getString('userinfo') as String);
//                         final myListData = [
//                           userinfo["name"],
//                           userinfo["phoneNo"],
//                           userinfo["address"],
//                           userinfo["fphoneNo"],
//                           userinfo["fname"],
//                           userinfo["designation"],
//                           userinfo["age"],
//                           userinfo["uid"],
//                           userinfo["owner"],
//                           userinfo["email"]
//                         ];
//                         print("$fbFromDate");
//                         return AlertDialog(
//                           title: const Text('Not Home'),
//                           content: Column(
//                             children: [
//                               Text(
//                                   'Security will look after your house for the next ${Fdays! + 1} days. From ${DateFormat('yyyy-MM-dd').format(fbFromDate)} to ${DateFormat('yyyy-MM-dd').format(fbToDate)} days'),
//                               const Text(''),
//                               const SizedBox(height: 10),
//                               SizedBox(
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 height: MediaQuery.of(context).size.height / 18,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: const Color.fromRGBO(15, 39, 127, 1),
//                                     borderRadius: BorderRadius.circular(10.0),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black
//                                             .withOpacity(0.3), // Shadow color
//                                         offset: const Offset(1,
//                                             4), // Offset of the shadow (x, y)
//                                         blurRadius: 5, // Blur radius
//                                       ),
//                                     ],
//                                   ),
//                                   child: InkWell(
//                                       onTap: () async {
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                               title: const Text(
//                                                 'Confirmation',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               content: const Text(
//                                                 'Do you want to cancel your Not Home Request.',
//                                               ),
//                                               actions: <Widget>[
//                                                 ElevatedButton(
//                                                   style: ButtonStyle(
//                                                     backgroundColor:
//                                                         MaterialStateProperty
//                                                             .all(Colors.black),
//                                                   ),
//                                                   onPressed: () async {
//                                                     print(
//                                                         "KDDDDDDDDDDDDDDDDDD$docid");
//                                                     await FirebaseFirestore
//                                                         .instance
//                                                         .collection("not_Home")
//                                                         .doc(docid)
//                                                         .update({
//                                                       'Status': false,
//                                                       'cancelled': true,
//                                                       'pressedTime1':
//                                                           DateTime.now()
//                                                     });
//                                                     await FirebaseFirestore
//                                                         .instance
//                                                         .collection(
//                                                             "notifications")
//                                                         .add({
//                                                       'isRead': false,
//                                                       'id': docid,
//                                                       'date':
//                                                           "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
//                                                       'description':
//                                                           "You Have Cancelled Your not home request !",
//                                                       'image':
//                                                           "https://blog.udemy.com/wp-content/uploads/2014/05/bigstock-test-icon-63758263.jpg",
//                                                       'time': formattedTime,
//                                                       'title': 'Not at Home',
//                                                       "uid": userinfo['uid'],
//                                                       'pressedTime':
//                                                           DateTime.now(),
//                                                     });
//                                                     // await fetchToFieldForLatestDocument(FirebaseAuth.instance.currentUser!.uid);

//                                                     print(
//                                                         "NOT HOMEE STATUS $status");

//                                                     Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               TabsScreen(
//                                                             index: 0,
//                                                           ),
//                                                         ));

//                                                     ScaffoldMessenger.of(
//                                                             context)
//                                                         .showSnackBar(SnackBar(
//                                                             action:
//                                                                 SnackBarAction(
//                                                               label: "Ok",
//                                                               textColor:
//                                                                   Colors.black,
//                                                               onPressed: () {},
//                                                             ),
//                                                             backgroundColor:
//                                                                 Colors
//                                                                     .grey[400],
//                                                             content: const Text(
//                                                                 "Your Not Home request has been Cancelled ",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .black))));
//                                                   },
//                                                   child: const Text('Yes',
//                                                       style: TextStyle(
//                                                           color: Colors.white)),
//                                                 ),
//                                                 ElevatedButton(
//                                                   style: ButtonStyle(
//                                                     backgroundColor:
//                                                         MaterialStateProperty
//                                                             .all(Colors.black),
//                                                   ),
//                                                   onPressed: () {
//                                                     Navigator.of(context)
//                                                         .pop(); // Close the confirmation dialog
//                                                   },
//                                                   child: const Text('No',
//                                                       style: TextStyle(
//                                                           color: Colors.white)),
//                                                 ),
//                                               ],
//                                             );
//                                           },
//                                         );
//                                       },
//                                       child: const Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Text('Cancel my request',
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight:
//                                                         FontWeight.bold)),
//                                             Icon(
//                                               Icons.delete,
//                                               color: Colors.white,
//                                             ),
//                                           ],
//                                         ),
//                                       )),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           actions: <Widget>[
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Text("back"),
//                             ),
//                           ],
//                         );
//                       }),
//                 ),
//               ));
//     }
//   }

//   List plotsDetails = [];

//   Future<void> fetchPlots() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('plots')
//           .orderBy('timestamp', descending: true)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
//           var data = documentSnapshot.data() as Map<String, dynamic>;
//           var media = data['mediaUrls'] as List<dynamic>;
//           var image = media[0];
//           var price = data['price'];
//           var address = data['address'];
//           var area = data['area'];
//           var bath = data['bath'];
//           var room = data['room'];
//           var id = data['id'];
//           setState(() {
//             plotsDetails.add({
//               'id': id,
//               'image': image,
//               'area': area,
//               'address': address,
//               'price': price,
//               'room': room,
//               'bath': bath,
//             });
//           });
//         }
//       } else {
//         print('No documents found in the "plots" collection.');
//       }
//     } catch (e) {
//       print('Error fetching plots: $e');
//     }
//   }

//   Future<void> fetchSubcollectionDocuments(
//       String currentUserEmail, owner) async {
//     try {
//       final mainCollectionQuery = await FirebaseFirestore.instance
//           .collection("UserRequest") // Replace with your main collection
//           .where("owner", isEqualTo: owner)
//           .get();

//       if (mainCollectionQuery.docs.isNotEmpty) {
//         mainCollectionQuery.docs.forEach((mainDoc) async {
//           final subcollectionRef = mainDoc.reference.collection("FMData");

//           final subcollectionQuery = await subcollectionRef
//               .where("ownerMail", isEqualTo: currentUserEmail)
//               .get();

//           if (subcollectionQuery.docs.isNotEmpty) {
//             for (var subDoc in subcollectionQuery.docs) {
//               // Process subcollection documents here
//               print("data===${subDoc.data()}");
//             }
//           }
//         });
//       } else {
//         print("No matching documents found in the main collection.");
//       }
//     } catch (error) {
//       print("Error: $error");
//     }
//   }
// }
