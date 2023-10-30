import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/Bill.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/Tab.dart';
import 'package:testapp/Screens/Discounts/discounts.dart';
import 'package:testapp/Screens/drawer.dart';
import 'package:testapp/global.dart';
import 'dart:io';
import 'package:html/parser.dart' as parser;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeDesign1 extends StatefulWidget {
  static final routeName = "HomeDesign1";

  static List<IconData> navigatorsIcon = [
    Icons.desktop_mac_rounded,
  ];

  @override
  _HomeDesign1State createState() => _HomeDesign1State();
}

class _HomeDesign1State extends State<HomeDesign1> {
  String? link = "ddd";
  String videoId = "dd";
  var y_controller;

  Future<String?> fetchYoutubeLink() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('VideoPanel').get();

      // Initialize the link variable

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          link = data['Url'];
        });
        print("Linkdo=${link}");

        // print("Fetched Link: $link");
      } else {
        print("No documents found in the 'VideoPanel' collection.");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return null;
    }
  }

  // String? videoUrl = "https://www.youtube.com/watch?v=R7XNJ3r5n4k";
  var buttonLabels;
  String filePath = "";
  int button_count_sec = 1;
  int button_count_gro = 1;
  int button_count_med = 1;
  List<String> urls = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 60));
  bool _isInit = true;
  int _daysDifference = 0;

  TextEditingController _dateController = TextEditingController(
    text:
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
  );
  TextEditingController currentdate = TextEditingController(
      text:
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");
  DateTime selectedDate = DateTime.now();
  bool _isLoading = true;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('utility');

  Future _sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    // String name, email, subject, message;
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    var service_id = 'service_wg70055';
    var template_id = 'template_0yvlqvj';
    var user_id = 'Jg-9ZFPX61IpyTv1w';
    final response = await http.post(url,
        body: json.encode({
          'service_id': service_id,
          'template_id': template_id,
          'user_id': user_id,
          'template_params': {
            'user_name': name,
            'from_name': name,
            'mail': "venrablejutt310@gmail.com",
            'user_subject': subject,
            'to_email': "daniyalhumayun7@gmail.com",
            'user_message': message
          },
        }),
        headers: {
          'origin': "http://localhost",
          'Content-Type': 'application/json'
        });

    print(response.body);
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: startDate, // Change the start date as needed
      lastDate: endDate, // Change the end date as needed
    );
    final daysDifference = picked!.difference(DateTime.now()).inDays;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
        _daysDifference = daysDifference;
        print("days= ${_daysDifference}");
      });
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String FCMtoken = "";
  getMobileToken() {}
  bool btnOnOff = false;
  String generateRandomFourDigitCode() {
    Random random = Random();
    int code = random.nextInt(10000);

    // Ensure the code is four digits long (pad with leading zeros if necessary)
    return code.toString().padLeft(4, '0');
  }

  void alertme(String collect) async {
    String fourDigitCode = generateRandomFourDigitCode();
    setState(() {
      btnOnOff = false;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to send a request?',
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () async {
              if (btnOnOff == false) {
                final prefs = await SharedPreferences.getInstance();
                final userinfo =
                    json.decode(prefs.getString('userinfo') as String);
                await _firebaseMessaging.getToken().then((String? token) {
                  if (token != null) {
                    setState(() {
                      FCMtoken = token;
                      btnOnOff = true;
                    });

                    print("FCM Token: $FCMtoken");
                  } else {
                    print("Unable to get FCM token");
                  }
                });
                int num = 1;

                //no issue in upper code !

                // print("FCMtoken===${FCMtoken}");
                await FirebaseFirestore.instance.collection(collect).add({
                  "name": userinfo["name"],
                  "phoneNo": userinfo["phoneNo"],
                  "address": userinfo["address"],
                  "fphoneNo": userinfo["fphoneNo"],
                  "fname": userinfo["fname"],
                  "designation": userinfo["designation"],
                  "age": userinfo["age"],
                  "pressedTime": FieldValue.serverTimestamp(),
                  "type": collect,
                  "FM${num}": userinfo["FM${num}"],
                  "uid": userinfo["uid"],
                  "owner": userinfo["owner"],
                  "email": userinfo["email"],
                  "noti": true,
                  "residentID": "Invoseg${fourDigitCode}",
                  "FCMtoken": FCMtoken
                });
                num++;
                FirebaseFirestore.instance.collection("UserButtonRequest").add({
                  "type": collect,
                  "uid": userinfo["uid"],
                  "pressedTime": FieldValue.serverTimestamp(),
                });
                Navigator.of(ctx).pop(true);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      "Your Request is sent",
                      style: TextStyle(color: Colors.black),
                    ),
                    action: SnackBarAction(
                        label: 'OK', textColor: Colors.black, onPressed: () {}),
                    backgroundColor: Colors.grey[400],
                  ),
                );
                log(12);
                _sendEmail(
                    name: '${userinfo["name"]}',
                    email: '${userinfo["email"]}',
                    message:
                        "type : ${collect}\n name : ${userinfo["name"]}\nEmail : ${userinfo['email']}\nAddress : ${userinfo['address']}\nPhone No : ${userinfo['phoneNo']}\nF-Phone No ${userinfo['fphoneNo']}\nF-Name : ${userinfo['fname']}\nDesignation : ${userinfo['designation']}\nage : ${userinfo['age']}\nOwner : ${userinfo['owner']}",
                    subject: "test subject");
              } else {}
            },
          ),
          ElevatedButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _collectionRef.doc('Button').snapshots().listen((snap) {
        buttonLabels = [
          (snap.data() as Map)["btn1"],
          (snap.data() as Map)["btn2"],
          (snap.data() as Map)["btn3"]
        ];
        setState(() {
          _isLoading = false;
        });
      });
      _collectionRef.doc('Slider').snapshots().listen((snap) {
        urls = [
          (snap.data() as Map)["image1"],
          (snap.data() as Map)["image2"],
          (snap.data() as Map)["image3"],
          (snap.data() as Map)["image4"]
        ];
        print(buttonLabels);
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  late VideoPlayerController _controller;
  bool startedPlaying = false;

  void initState() {
    super.initState();
    fetchYoutubeLink().then((value) {
      videoId = YoutubePlayer.convertUrlToId(link!) ??
          'https://www.youtube.com/watch?v=-jMrZI4IeJw';
      y_controller = YoutubePlayerController(
        initialVideoId: this.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false, // Set to true if you want the video to auto-play
          showLiveFullscreenButton: false,
        ),
      );
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });

    // fetchDataAndUseLink();

    _controller = VideoPlayerController.asset("assets/video-demo.mp4");
    if (_controller == null) {}
    _controller.addListener(() {
      if (startedPlaying && !_controller.value.isPlaying) {}
    });

    print("OKA");

    //   _controller.setLooping(true);

    _dateController = TextEditingController(
      text: "${selectedDate.toLocal()}".split(' ')[0],
    );
  }

  Future<bool> started() async {
    await _controller.initialize();
    await _controller.play();
    startedPlaying = true;
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isLoading = true;

  var prefs;

  final List<String> navigators = [
    "View History",
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat.d().format(DateTime.now()); // Day of the month
    final formattedMonth =
        DateFormat.yMMMM().format(DateTime.now()); // Full month name
    final formattedYear = DateFormat.y().format(DateTime.now()); // Year
    final formattedTime = DateFormat('hh:mm:ss a')
        .format(DateTime.now()); // Time in 24-hour format

    final formattedDateTime =
        '${formattedDate} ${formattedMonth} at ${formattedTime} UTC+5';

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                key: _key,
                drawer: const DrawerWidg(),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image(
                      image: AssetImage('assets/Images/rehman.png'),
                      height: 60,
                      width: 60,
                    ),
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                        color: Color(0xff212121),
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Stack(
                        children: <Widget>[
                          Icon(
                            Icons.notifications,
                            color: Colors.black,
                          ),
                          if (notification_count >
                              0) // Show the badge only if there are unread notifications
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors
                                      .red, // You can customize the badge color
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 15,
                                  minHeight: 15,
                                ),
                                child: Text(
                                  notification_count.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        12, // You can customize the font size
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: () async {
                        // Handle tapping on the notifications icon
                        await Navigator.push(
                          context,
                          PageTransition(
                            duration: Duration(milliseconds: 700),
                            type: PageTransitionType.rightToLeftWithFade,
                            child: Notifications(),
                          ),
                        );
                        setState(() {
                          // notification_count = 0;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _key.currentState!.openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
                body: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      // image: DecorationImage(
                                      //     alignment: Alignment.bottomRight,
                                      //     image: AssetImage(
                                      //         ''),
                                      //     fit: BoxFit.contain),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Card(
                                      elevation: 1,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: AspectRatio(
                                          aspectRatio: 16 /
                                              9, // You can adjust this aspect ratio as needed
                                          child: YoutubePlayer(
                                              controller: y_controller,
                                              bottomActions: [
                                                const SizedBox(width: 8.0),
                                                CurrentPosition(),
                                                const SizedBox(width: 175.0),
                                                RemainingDuration(),
                                                const SizedBox(width: 10.0),
                                                PlaybackSpeedButton(),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 3.0, bottom: 1),
                                  //   child: Container(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(
                                  //           10.0), // Adjust the radius as needed

                                  //       color: const Color.fromARGB(
                                  //           179, 229, 229, 229),
                                  //     ),
                                  //     // width: 220,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(2.0),
                                  //       child: Container(
                                  //         width: 300,
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(
                                  //               10.0), // Adjust the radius as needed

                                  //           color: Color.fromRGBO(
                                  //               222, 226, 231, 1),
                                  //         ),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(2.0),
                                  //           child: Align(
                                  //             child: Text(
                                  //                 "What are you Looking for ?"),
                                  //             alignment: Alignment.center,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  const Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            right: 4,
                                            top: 5,
                                            bottom: 5),
                                        child: Text(
                                          "Emergency Calls",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Expanded(
                                  //   child:
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    child:

                                        //  Card(
                                        //   color: Colors.grey[200],
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius:
                                        //         BorderRadius.circular(20),
                                        //   ),
                                        //   elevation: 20,
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.all(4.0),
                                        //     child:

                                        Container(
                                      height: 130,
                                      width: double.infinity,
                                      child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceAround,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 10,
                                                left: 1,
                                                right: 1),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          // top: 5,
                                                          // bottom: 10,
                                                          left: 1,
                                                          right: 1),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            18,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromRGBO(
                                                            15, 39, 127, 1),
                                                        // gradient:
                                                        //     LinearGradient(
                                                        //   colors: [
                                                        //     Color.fromRGBO(
                                                        //         242, 13, 54, 1),
                                                        //     Color.fromRGBO(104,
                                                        //         109, 224, 1),
                                                        //   ],
                                                        // ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3), // Shadow color
                                                            offset: const Offset(
                                                                1,
                                                                4), // Offset of the shadow (x, y)
                                                            blurRadius:
                                                                5, // Blur radius
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextButton.icon(
                                                        onPressed: () async {
                                                          if (button_count_med <=
                                                              25) {
                                                            setState(() {
                                                              button_count_med =
                                                                  button_count_med +
                                                                      1;
                                                            });

                                                            var connectivityResult =
                                                                await (Connectivity()
                                                                    .checkConnectivity());
                                                            print(
                                                                "Connectivity == ${connectivityResult.toString()}");
                                                            if (connectivityResult ==
                                                                ConnectivityResult
                                                                    .none) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("This Feature is not available in Offline mode")));
                                                            } else {
                                                              alertme(
                                                                  "button-two");
                                                            }
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content:
                                                                    const Text(
                                                                  "Sorry ! but you have reached your todays limit .",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                action: SnackBarAction(
                                                                    label: 'OK',
                                                                    textColor:
                                                                        Colors
                                                                            .black,
                                                                    onPressed:
                                                                        () {}),
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        400],
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        label: Text(
                                                            '  ' +
                                                                buttonLabels[1],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        icon: const Icon(
                                                          Icons.emergency,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.4,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            18,
                                                    child: Container(
                                                      // height: 50,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromRGBO(
                                                            15, 39, 127, 1),

                                                        // gradient:
                                                        //     LinearGradient(
                                                        //   colors: [
                                                        //     Color.fromRGBO(
                                                        //         242, 13, 54, 1),
                                                        //     Color.fromRGBO(104,
                                                        //         109, 224, 1),
                                                        //   ],
                                                        // ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3), // Shadow color
                                                            offset: const Offset(
                                                                1,
                                                                4), // Offset of the shadow (x, y)
                                                            blurRadius:
                                                                5, // Blur radius
                                                          ),
                                                        ],
                                                      ),
                                                      child: TextButton.icon(
                                                        onPressed: () async {
                                                          if (button_count_gro <=
                                                              25) {
                                                            setState(() {
                                                              button_count_gro =
                                                                  button_count_gro +
                                                                      1;
                                                            });
                                                            var connectivityResult =
                                                                await (Connectivity()
                                                                    .checkConnectivity());
                                                            print(
                                                                "Connectivity == ${connectivityResult.toString()}");
                                                            if (connectivityResult ==
                                                                ConnectivityResult
                                                                    .none) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                          content:
                                                                              Text("This Feature is not available in Offline mode")));
                                                            } else {
                                                              alertme(
                                                                  "button-three");
                                                            }
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content:
                                                                    const Text(
                                                                  "Sorry ! but you have reached your todays limit .",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                action: SnackBarAction(
                                                                    label: 'OK',
                                                                    textColor:
                                                                        Colors
                                                                            .black,
                                                                    onPressed:
                                                                        () {}),
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        400],
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        label: Text(
                                                          '  ' +
                                                              buttonLabels[2],
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        icon: const Icon(
                                                          Icons
                                                              .local_grocery_store_sharp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  18,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      15, 39, 127, 1),
                                                  // gradient:
                                                  //     LinearGradient(
                                                  //   colors: [
                                                  //     Color.fromRGBO(
                                                  //         242, 13, 54, 1),
                                                  //     Color.fromRGBO(104,
                                                  //         109, 224, 1),
                                                  //   ],
                                                  // ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: Colors.black
                                                  //         .withOpacity(
                                                  //             0.3), // Shadow color
                                                  //     offset: Offset(1,
                                                  //         4), // Offset of the shadow (x, y)
                                                  //     blurRadius:
                                                  //         5, // Blur radius
                                                  //   ),
                                                  // ],
                                                ),
                                                child: TextButton.icon(
                                                  onPressed: () async {
                                                    if (button_count_sec <=
                                                        25) {
                                                      setState(() {
                                                        button_count_sec =
                                                            button_count_sec +
                                                                1;
                                                      });
                                                      var connectivityResult =
                                                          await (Connectivity()
                                                              .checkConnectivity());
                                                      print(
                                                          "Connectivity == ${connectivityResult.toString()}");
                                                      if (connectivityResult ==
                                                          ConnectivityResult
                                                              .none) {
                                                        await showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                AlertDialog(
                                                                    title: const Text(
                                                                        'Offline !'),
                                                                    content:
                                                                        const Text(
                                                                            'you are currently offline ! Contact us via Messages !'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          final recipientPhoneNumber =
                                                                              '03038465220'; // Replace with the recipient's phone number
                                                                          final String
                                                                              messageBody =
                                                                              'Hello, this is a test message.';
                                                                          final uri =
                                                                              Uri.encodeFull('sms:${recipientPhoneNumber}?body=${messageBody}');
                                                                          await launchUrl(
                                                                              Uri.parse(uri));
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Send Security Message'),
                                                                      ),
                                                                    ]));
                                                      } else {
                                                        print("Online");
                                                        alertme("button-one");
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: const Text(
                                                            "Sorry ! but you have reached your todays limit .",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          action: SnackBarAction(
                                                              label: 'OK',
                                                              textColor:
                                                                  Colors.black,
                                                              onPressed: () {}),
                                                          backgroundColor:
                                                              Colors.grey[400],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.security,
                                                    color: Colors.white,
                                                  ),
                                                  label: Text(
                                                      '  ' + buttonLabels[0],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //   ),
                                    // ),
                                  ),
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        child: InkWell(
                                          onTap: () async {
                                            await generatePDF();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PDFViewerPage(
                                                            pdfPath:
                                                                filePath)));
                                          },
                                          child: Container(
                                            // color: Colors.green,
                                            // height: 80,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              236, 238, 240, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: const Icon(
                                                      Icons
                                                          .table_chart_outlined,
                                                      color: Color.fromRGBO(
                                                          15, 39, 127, 1)),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Bills",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Discounts()));
                                          },
                                          child: Container(
                                            // color: Colors.green,
                                            // height: 80,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              236, 238, 240, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: const Icon(
                                                      Icons.wb_sunny_outlined,
                                                      color: Color.fromRGBO(
                                                          15, 39, 127, 1)),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Discount",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TabsScreen(index: 5)));
                                          },
                                          child: Container(
                                            // color: Colors.green,
                                            // height: 80,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              236, 238, 240, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  height: 50,
                                                  width: 50,
                                                  child: const Icon(
                                                      Icons.line_style_outlined,
                                                      //   Icons.line_style_sharp,
                                                      color: Color.fromRGBO(
                                                          15, 39, 127, 1)),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Plots",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        child: InkWell(
                                          child: Container(
                                            // color: Colors.green,
                                            // height: 80,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromRGBO(
                                                              236, 238, 240, 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: const Icon(Icons.home,
                                                      color: Color.fromRGBO(
                                                          15, 39, 127, 1)),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Not Home",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            print(
                                                "Datetime format = ${formattedDateTime}");
                                            showDialog(
                                                context: context,
                                                builder: (context) => Center(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            1.7,
                                                        // Adjust the width as needed
                                                        child: FutureBuilder(
                                                            future:
                                                                SharedPreferences
                                                                    .getInstance(),
                                                            builder: (context,
                                                                AsyncSnapshot
                                                                    snapshot) {
                                                              var userinfo = json
                                                                  .decode(snapshot
                                                                          .data
                                                                          .getString(
                                                                              'userinfo')
                                                                      as String);
                                                              final myListData =
                                                                  [
                                                                userinfo[
                                                                    "name"],
                                                                userinfo[
                                                                    "phoneNo"],
                                                                userinfo[
                                                                    "address"],
                                                                userinfo[
                                                                    "fphoneNo"],
                                                                userinfo[
                                                                    "fname"],
                                                                userinfo[
                                                                    "designation"],
                                                                userinfo["age"],
                                                                userinfo["uid"],
                                                                userinfo[
                                                                    "owner"],
                                                                userinfo[
                                                                    "email"]
                                                              ];
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Not Home'),
                                                                content: Column(
                                                                  children: [
                                                                    Text(
                                                                        'Select the date when you will be at home'),
                                                                    SizedBox(
                                                                        height:
                                                                            25),
                                                                    TextFormField(
                                                                      controller:
                                                                          currentdate,
                                                                      readOnly:
                                                                          true, // Prevent manual editing

                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'From',
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            25),
                                                                    TextFormField(
                                                                      controller:
                                                                          _dateController,
                                                                      readOnly:
                                                                          true, // Prevent manual editing
                                                                      onTap: () =>
                                                                          _selectDate(
                                                                              context),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        labelText:
                                                                            'To',
                                                                        suffixIcon:
                                                                            IconButton(
                                                                          icon:
                                                                              Icon(Icons.calendar_today),
                                                                          onPressed: () =>
                                                                              _selectDate(context),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      final FirebaseMessaging
                                                                          _firebaseMessaging =
                                                                          FirebaseMessaging
                                                                              .instance;
                                                                      String
                                                                          FCMtoken =
                                                                          "";
                                                                      await _firebaseMessaging
                                                                          .getToken()
                                                                          .then((String?
                                                                              token) {
                                                                        if (token !=
                                                                            null) {
                                                                          setState(
                                                                              () {
                                                                            FCMtoken =
                                                                                token;
                                                                          });

                                                                          print(
                                                                              "FCM Token: $FCMtoken");
                                                                        } else {
                                                                          print(
                                                                              "Unable to get FCM token");
                                                                        }
                                                                      });

                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "not_Home")
                                                                          .add({
                                                                        'FCMtoken':
                                                                            FCMtoken,
                                                                        'nh':
                                                                            false,
                                                                        'from':
                                                                            '${currentdate.text}',
                                                                        'to':
                                                                            '${_dateController.text}',
                                                                        "days":
                                                                            _daysDifference,
                                                                        'Name':
                                                                            '${userinfo['name']}',
                                                                        'Email':
                                                                            '${userinfo['email']}',
                                                                        'ID':
                                                                            '${userinfo["uid"]}',
                                                                        'PhoneNo':
                                                                            '${userinfo["phoneNo"]}',
                                                                        'Address':
                                                                            '${userinfo["address"]}',
                                                                        'FPhoneNo':
                                                                            '${userinfo["fphoneNo"]}',
                                                                        'FName':
                                                                            '${userinfo["fname"]}',
                                                                        'Designation':
                                                                            '${userinfo["designation"]}',
                                                                        'Age':
                                                                            '${userinfo["age"]}',
                                                                        'Owner':
                                                                            '${userinfo["owner"]}',
                                                                        'noti':
                                                                            true,
                                                                        'Status':
                                                                            true
                                                                      }).then((DocumentReference
                                                                              document) async {
                                                                        print(
                                                                            "ID= ${document.id}");
                                                                        String
                                                                            formattedTime =
                                                                            DateFormat('h:mm:ss a').format(DateTime.now());
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection("notifications")
                                                                            .add({
                                                                          'isRead':
                                                                              false,
                                                                          'id':
                                                                              document.id,
                                                                          'date':
                                                                              "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
                                                                          'description':
                                                                              "Not at Home is on !",
                                                                          'image':
                                                                              "https://blog.udemy.com/wp-content/uploads/2014/05/bigstock-test-icon-63758263.jpg",
                                                                          'time':
                                                                              formattedTime,
                                                                          'title':
                                                                              'Not at Home'
                                                                        });
                                                                      });

                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'OK'),
                                                                  ),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                    ));

                                            // _selectDate(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8,
                                            bottom: 1,
                                            right: 1,
                                            top: 6),
                                        child: Text(
                                          "Tredning Properties",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Container(
                                    // color: Colors.amber,
                                    height:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ListView.builder(
                                      itemCount: 4,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 6,
                                            top: 1,
                                            bottom: 1,
                                          ),
                                          child: Container(
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height /
                                            //     1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.4,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  15.0), // Adjust the radius as needed
                                              color: const Color.fromRGBO(
                                                  236, 238, 240, 1),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, top: 3, bottom: 3),
                                              child: Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                children: [
                                                  // Padding(
                                                  // padding:
                                                  // const EdgeInsets.all(8.0),
                                                  // child:
                                                  Container(
                                                    // height: 100,
                                                    // width:
                                                    //     MediaQuery.of(context)
                                                    //             .size
                                                    //             .width /
                                                    //         3.3,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.asset(
                                                        "assets/Images/plot4.jpeg",
                                                        height: 100,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.3,
                                                      ),
                                                    ),
                                                  ),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 2,
                                                      right: 2,
                                                      top: 6,
                                                      bottom: 2,
                                                    ),
                                                    child: Column(children: [
                                                      Container(
                                                        height: 90,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: ListTile(
                                                          title: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                ' Phase 1 house 68',
                                                                style: TextStyle(
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                'House no 61 street no 3',
                                                                style: TextStyle(
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black45),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                '3 bedroom 4 washroom 2 kitchens garage double story',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              )
                                                            ],
                                                          ),
                                                          //subtitle: ,
                                                        ),
                                                      ),
                                                    ]),

                                                    //         Column(
                                                    // mainAxisAlignment:
                                                    //     MainAxisAlignment
                                                    //         .spaceBetween,
                                                    //  children: [
                                                    // ListTile(
                                                    //   title: Text(
                                                    //       'Phase 1 house 68'),
                                                    // )
                                                    // Text("Brookline",
                                                    //     style: TextStyle(
                                                    //         fontSize:
                                                    //             7) // Limit to one line of text
                                                    //     ),
                                                    // Text("4.5")
                                                    //    ],
                                                    //  ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.only(),
                                                  //   //child:
                                                  //   //Align(
                                                  //   child: Text(
                                                  //       "Wiley's Cottage",
                                                  //       style: TextStyle(
                                                  //           fontSize: 6)),
                                                  //   //alignment: Alignment
                                                  //   //  .centerLeft,
                                                  //   // )
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ]),
                          )),
                    )));
  }
}
