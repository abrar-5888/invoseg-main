import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/Profile.dart';
import 'package:testapp/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Home extends StatefulWidget {
  static final routeName = "home";

  static List<IconData> navigatorsIcon = [
    Icons.desktop_mac_rounded,
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late YoutubePlayerController y_controller;
  String? videoUrl =
      "https://www.youtube.com/live/sUKwTVAc0Vo?si=hQmtBR1h1aGd8xFO";
  var buttonLabels;
  List<String> urls = [];
  bool _isInit = true;
  bool _isLoading = true;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('utility');

  void alertme(String collect) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to send a request?',
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Yes', style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final userinfo =
                  json.decode(prefs.getString('userinfo') as String);
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
                "uid": userinfo["uid"],
                "owner": userinfo["owner"],
                "email": userinfo["email"]
              });
              Navigator.of(ctx).pop(true);
              FirebaseFirestore.instance.collection("UserButtonRequest").add({
                "type": collect,
                "uid": userinfo["uid"],
                "pressedTime": FieldValue.serverTimestamp(),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Your Request is sent",
                    style: TextStyle(color: Colors.black),
                  ),
                  action: SnackBarAction(
                      label: 'OK', textColor: Colors.black, onPressed: () {}),
                  backgroundColor: Colors.grey[400],
                ),
              );
            },
          ),
          ElevatedButton(
            child: Text(
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
    _controller = VideoPlayerController.asset("assets/video-demo.mp4");
    if (_controller == null) {}
    _controller.addListener(() {
      if (startedPlaying && !_controller.value.isPlaying) {}
    });
    String? videoId = YoutubePlayer.convertUrlToId(
            'https://www.youtube.com/watch?v=qeW0pVBRCmQ') ??
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

    y_controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false, // Set to true if you want the video to auto-play
      ),
    );
    print("OKA");

    //   _controller.setLooping(true);
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

  var prefs;

  final List<String> navigators = [
    "View History",
  ];

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : WillPopScope(
            onWillPop: () async {
// Show a confirmation message
              bool test = true;
              if (test == true) {
                print("Working");
                return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('Do you want to exit the app?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await SystemNavigator.pop();
                                  // var c = await SharedPreferences.getInstance();
                                  // c.clear();
                                  // Navigator.push(
                                  //     context,
                                  //     PageTransition(
                                  //         duration: Duration(milliseconds: 700),
                                  //         type: PageTransitionType
                                  //             .rightToLeftWithFade,
                                  // child: LoginScreen()));
                                },
                                child: Text('Yes'),
                              )
                            ]));
              } else {
                print("not working");
                return true;
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image(
                      image: AssetImage('assets/Images/rehman.png'),
                      height: 60,
                      width: 60,
                    ),
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                        color: Color(0xff212121),
                        fontWeight: FontWeight.w700,
                        fontSize: 24),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 700),
                                type: PageTransitionType.rightToLeftWithFade,
                                child: UserProfile()));
                      },
                    ),
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
                          notification_count = 0;
                        });
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                // image: DecorationImage(
                                //     alignment: Alignment.bottomRight,
                                //     image:
                                //         AssetImage('assets/Images/Vector.png'),
                                //     fit: BoxFit.contain),
                                gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.0),
                                  end: Alignment(-0.96, -0.278),
                                  colors: [
                                    Colors.black,
                                    Colors.black87,
                                  ],
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 5,
                              child: Card(
                                elevation: 0,
                                color: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: AspectRatio(
                                    aspectRatio: 16 /
                                        9, // You can adjust this aspect ratio as needed
                                    child: YoutubePlayer(
                                      controller: y_controller,
                                      showVideoProgressIndicator: true,
                                      progressIndicatorColor: Colors.blueAccent,
                                      progressColors: ProgressBarColors(
                                        playedColor: Colors.blue,
                                        bufferedColor: Colors.grey,
                                      ),
                                      onReady: () {
                                        // Add custom logic here when the video is ready to play
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Center(
                                child: Text("News & Feeds",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 15),
                              height: 150,
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    width: 100,
                                    child: Center(
                                        child: Container(
                                      // margin: EdgeInsets.only(bottom: 2),
                                      child: FutureBuilder<bool>(
                                        future: started(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshot) {
                                          if (snapshot.data == true) {
                                            return Container(
                                              // margin: EdgeInsets.only(
                                              //     bottom: 2),
                                              height: double.infinity,
                                              width: 240,
                                              child: AspectRatio(
                                                aspectRatio: _controller
                                                    .value.aspectRatio,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    700),
                                                            type: PageTransitionType
                                                                .rightToLeftWithFade,
                                                            child: VideoPlayer(
                                                                _controller)));
                                                  },
                                                  child: Container(
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: VideoPlayer(
                                                              _controller))),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                              'Waiting for Video to load...',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            );
                                          }
                                        },
                                      ),
                                    )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              duration:
                                                  Duration(milliseconds: 700),
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: Image.network(
                                                urls[0],
                                                fit: BoxFit.fitHeight,
                                              )));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          urls[0],
                                          fit: BoxFit.fitHeight,
                                          width: 100,
                                          height: 250,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              duration:
                                                  Duration(milliseconds: 700),
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: Image.network(
                                                urls[1],
                                                fit: BoxFit.fitHeight,
                                              )));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          urls[1],
                                          fit: BoxFit.fitHeight,
                                          width: 100,
                                          height: 250,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              duration:
                                                  Duration(milliseconds: 700),
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: Image.network(
                                                urls[2],
                                                fit: BoxFit.fitHeight,
                                              )));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          urls[2],
                                          width: 100,
                                          fit: BoxFit.fitHeight,
                                          height: 250,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 5,
                                  right: 5,
                                ),
                                child: Card(
                                  color: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 20,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.speaker_phone_rounded,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              'Press any of these buttons!',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
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
                                              1.40,
                                          child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        20),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black)),
                                            onPressed: () async {
                                              var connectivityResult =
                                                  await (Connectivity()
                                                      .checkConnectivity());
                                              print(
                                                  "Connectivity == ${connectivityResult.toString()}");
                                              if (connectivityResult ==
                                                  ConnectivityResult.none) {
                                                await showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                            title: Text(
                                                                'Offline !'),
                                                            content: Text(
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
                                                                  final uri = Uri
                                                                      .encodeFull(
                                                                          'sms:${recipientPhoneNumber}?body=${messageBody}');
                                                                  await launchUrl(
                                                                      Uri.parse(
                                                                          uri));
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'Send Security Message'),
                                                              ),
                                                            ]));
                                              } else {
                                                print("Online");
                                                alertme("button-one");
                                              }
                                            },
                                            icon: Icon(
                                              Icons.security,
                                              color: Colors.white,
                                            ),
                                            label: Text('  ' + buttonLabels[0],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.40,
                                          child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        20),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black)),
                                            onPressed: () async {
                                              var connectivityResult =
                                                  await (Connectivity()
                                                      .checkConnectivity());
                                              print(
                                                  "Connectivity == ${connectivityResult.toString()}");
                                              if (connectivityResult ==
                                                  ConnectivityResult.none) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "This Feature is not available in Offline mode")));
                                              } else {
                                                alertme("button-two");
                                              }
                                            },
                                            label: Text('  ' + buttonLabels[1],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            icon: Icon(
                                              Icons.medical_information,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.40,
                                          child: ElevatedButton.icon(
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStateProperty.all(
                                                        20),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.black)),
                                            onPressed: () async {
                                              var connectivityResult =
                                                  await (Connectivity()
                                                      .checkConnectivity());
                                              print(
                                                  "Connectivity == ${connectivityResult.toString()}");
                                              if (connectivityResult ==
                                                  ConnectivityResult.none) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "This Feature is not available in Offline mode")));
                                              } else {
                                                alertme("button-three");
                                              }
                                            },
                                            label: Text(
                                              '  ' + buttonLabels[2],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            icon: Icon(
                                              Icons.local_grocery_store_sharp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ), //Column
                      )
                      //Padding
                      ), //Container
                )
                //Center
                ),
          ); //Scaffold
  }
}
