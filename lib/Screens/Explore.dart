// /*import 'dart:convert';

// import 'package:connectivity_plus/connectivity_plus.dart'; // Import the connectivity_plus package
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_sms/flutter_sms.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:testapp/Screens/LoginPage.dart';
// import 'package:testapp/Screens/Notifications.dart';
// import 'package:testapp/Screens/Profile.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Explore extends StatefulWidget {
//   const Explore({Key? key}) : super(key: key);

//   @override
//   State<Explore> createState() => _ExploreState();
// }

// class _ExploreState extends State<Explore> {
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         bool test = true;
//         if (test == true) {
//           print("Working");
//           return await showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                     title: Text('Are you sure?'),
//                     content: Text('Do you want to exit the app?'),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(false),
//                         child: Text('No'),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           await SystemNavigator.pop();
//                         },
//                         child: Text('Yes'),
//                       )
//                     ],
//                   ));
//         } else {
//           print("not working");
//           return true;
//         }
//       },
//       child: FutureBuilder(
//           future: SharedPreferences.getInstance(),
//           builder: (context, AsyncSnapshot snapshot) {
//             var userinfo =
//                 json.decode(snapshot.data.getString('userinfo') as String);
//             final myListData = [
//               userinfo["name"],
//               userinfo["phoneNo"],
//               userinfo["address"],
//               userinfo["fphoneNo"],
//               userinfo["fname"],
//               userinfo["designation"],
//               userinfo["age"],
//               userinfo["uid"],
//               userinfo["owner"],
//               userinfo["email"]
//             ];
//             return Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Image(
//                     image: AssetImage('assets/Images/Lake-City-Logo.png'),
//                     height: 60,
//                     width: 60,
//                   ),
//                 ),
//                 title: Text(
//                   'Explore',
//                   style: TextStyle(
//                       color: Color(0xff212121),
//                       fontWeight: FontWeight.w700,
//                       fontSize: 24),
//                 ),
//                 actions: <Widget>[
//                   IconButton(
//                     icon: Icon(
//                       Icons.person,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                               duration: Duration(milliseconds: 700),
//                               type: PageTransitionType.rightToLeftWithFade,
//                               child: UserProfile()));
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.notifications,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                               duration: Duration(milliseconds: 700),
//                               type: PageTransitionType.rightToLeftWithFade,
//                               child: Notifications()));
//                     },
//                   ),
//                 ],
//               ),
//               body: Center(
//                 child: ElevatedButton(
//                   child: Text("Test"),
//                   onPressed: () async {
//                     var connectivityResult =
//                         await (Connectivity().checkConnectivity());
//                     print("Connectivity == ${connectivityResult.toString()}");
//                     if (connectivityResult == ConnectivityResult.none) {
//                       print("Offline");
//                       await showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                                   title: Text('Offline !'),
//                                   content: Text(
//                                       'you are currently offline ! Contact us through Messages !'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () async {
//                                         final recipientPhoneNumber =
//                                             '03038465220';
//                                         final String messageBody =
//                                             'Name : ${userinfo["name"]},\nAddress : ${userinfo["address"]},\nPhone No : ${userinfo["phoneNo"]}';

//                                         final uri = Uri.encodeFull(
//                                             'sms:${recipientPhoneNumber}?body=${messageBody}');
//                                         await launchUrl(Uri.parse(uri));
//                                         Navigator.pop(context);
//                                       },
//                                       child: Text('Send Security Message'),
//                                     ),
//                                   ]));
//                     } else {
//                       print("Online");
//                     }
//                   },
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
// */
import 'dart:convert'; // Import the connectivity_plus package
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_sms/flutter_sms.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/Profile.dart';
import 'package:testapp/Screens/webview.dart';
import 'package:testapp/global.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  int unreadNotificationCount = 4;

  final String _accountSid = 'YOUR_ACCOUNT_SID';
  final String _authToken = 'YOUR_AUTH_TOKEN';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => WebView()));
          },
          child: Text("Web View")),
    );
//     return WillPopScope(
//       onWillPop: () async {
//         bool test = true;
//         if (test == true) {
//           print("Working");
//           return await showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                     title: Text('Are you sure?'),
//                     content: Text('Do you want to exit the app?'),
//                     actions: <Widget>[
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(false),
//                         child: Text('No'),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           await SystemNavigator.pop();
//                         },
//                         child: Text('Yes'),
//                       )
//                     ],
//                   ));
//         } else {
//           print("not working");
//           return true;
//         }
//       },
//       child: FutureBuilder(
//           future: SharedPreferences.getInstance(),
//           builder: (context, AsyncSnapshot snapshot) {
//             var userinfo =
//                 json.decode(snapshot.data.getString('userinfo') as String);
//             final myListData = [
//               userinfo["name"],
//               userinfo["phoneNo"],
//               userinfo["address"],
//               userinfo["fphoneNo"],
//               userinfo["fname"],
//               userinfo["designation"],
//               userinfo["age"],
//               userinfo["uid"],
//               userinfo["owner"],
//               userinfo["email"]
//             ];
//             return Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.white,
//                 elevation: 0,
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Image(
//                     image: AssetImage('assets/Images/rehman.png'),
//                     height: 60,
//                     width: 60,
//                   ),
//                 ),
//                 title: Text(
//                   'Explore',
//                   style: TextStyle(
//                       color: Color(0xff212121),
//                       fontWeight: FontWeight.w700,
//                       fontSize: 24),
//                 ),
//                 actions: <Widget>[
//                   IconButton(
//                     icon: Icon(
//                       Icons.person,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                               duration: Duration(milliseconds: 700),
//                               type: PageTransitionType.rightToLeftWithFade,
//                               child: UserProfile()));
//                     },
//                   ),
//                   IconButton(
//                     icon: Stack(
//                       children: <Widget>[
//                         Icon(
//                           Icons.notifications,
//                           color: Colors.black,
//                         ),
//                         if (notification_count >
//                             0) // Show the badge only if there are unread notifications
//                           Positioned(
//                             right: 0,
//                             top: 0,
//                             child: Container(
//                               padding: EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors
//                                     .red, // You can customize the badge color
//                               ),
//                               constraints: BoxConstraints(
//                                 minWidth: 15,
//                                 minHeight: 15,
//                               ),
//                               child: Text(
//                                 notification_count.toString(),
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize:
//                                       12, // You can customize the font size
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                     onPressed: () async {
//                       // Handle tapping on the notifications icon
//                       await Navigator.push(
//                         context,
//                         PageTransition(
//                           duration: Duration(milliseconds: 700),
//                           type: PageTransitionType.rightToLeftWithFade,
//                           child: Notifications(),
//                         ),
//                       );
//                       setState(() {
//                         notification_count = 0;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               body: Center(
//                 child: TextButton(
//                   child: Text("Test"),
//                   onPressed: () {},
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Diagonal Modal Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DiagonalModalPage(),
//               ),
//             );
//           },
//           child: Text('Open Modal'),
//         ),
//       ),
//     );
//   }
// }

// class DiagonalModalPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: Container(
//               color: Colors.black.withOpacity(0.5),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: DiagonalCurve(),
//           ),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: ModalButtons(),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Text(
//               'Choose Your Actions',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DiagonalCurve extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: DiagonalClipper(),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height / 2,
//         color: Colors.white,
//       ),
//     );
//   }
// }

// class DiagonalClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, size.height / 2);
//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

// class ModalButtons extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: FloatingActionButton(
//             onPressed: () {
//               // Add your action here
//             },
//             child: Icon(Icons.add),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: FloatingActionButton(
//             onPressed: () {
//               // Add your action here
//             },
//             child: Icon(Icons.edit),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: FloatingActionButton(
//             onPressed: () {
//               // Add your action here
//             },
//             child: Icon(Icons.delete),
//           ),
//         ),
//       ],
//     );
  }
}
