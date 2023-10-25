import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/LoginPage.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/Profile.dart';
import 'package:testapp/Screens/drawer.dart';
import 'package:testapp/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Newsandfeeds extends StatefulWidget {
  static final routeName = "Menu2";

  static List<IconData> navigatorsIcon = [
    Icons.desktop_mac_rounded,
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Newsandfeeds> {
  late YoutubePlayerController y_controller;
  var buttonLabels;
  List<String> urls = [];
  bool _isInit = true;
  bool _isLoading = true;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('utility');

  void alertme(String collect) async {
    final prefs = await SharedPreferences.getInstance();
    final userinfo = json.decode(prefs.getString('userinfo') as String);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Your Request is sent"),
        action: SnackBarAction(
            label: 'OK', textColor: Colors.greenAccent, onPressed: () {}),
        backgroundColor: Colors.teal,
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
    feed_count=0;
    _controller = VideoPlayerController.asset('assets/Demo.mp4');
    _controller.addListener(() {
      if (startedPlaying && !_controller.value.isPlaying) {}
    });
    _controller.setLooping(true);
    String? videoId = YoutubePlayer.convertUrlToId(
            'https://www.youtube.com/watch?v=SArwSz6kBDU') ??
        'https://www.youtube.com/watch?v=SArwSz6kBDU';

    y_controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false, // Set to true if you want the video to auto-play
      ),
    );
    print("OKA");
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

  bool isIconChanged = false;

  void toggleIcon() {
    setState(() {
      isIconChanged = !isIconChanged;
    });
  }

  var prefs;

  final List<String> navigators = [
    "View History",
  ];
  int _current = 0;
  final CarouselController _carouselcontroller = CarouselController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
          key: _key,
          drawer: DrawerWidg(),
          appBar: AppBar( centerTitle: true,
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
              'News & Feeds',
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
                    notification_count = 0;
                  });
                },
              ),
              //final GlobalKey<ScaffoldState> _key = GlobalKey();

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
              // ElevatedButton(
              //   onPressed: () => {},
              //   style: ButtonStyle(
              //     backgroundColor:
              //         MaterialStateProperty.all(Colors.greenAccent),
              //   ),
              //   child: FittedBox(
              //       fit: BoxFit.cover,
              //       child: Text(
              //         'Logout',
              //         style: TextStyle(
              //             color: Colors.teal[900],
              //             fontWeight: FontWeight.bold),
              //       )),
              // ),
            ],
          ),
          // drawer: Drawner(navigators: navigators),

          // LayoutBuilder(builder: (ctx, constraints) {
          //   return Center(
          //       child: Container(
          //     color: Colors.white,
          //     child: Padding(
          //       padding: const EdgeInsets.all(14.0),
          //       child: Column(children: <Widget>[
          //         Container(
          //           color: Colors.grey[200],
          //           height: 30,
          //           child: Marquee(
          //             text: 'Security Notify App',
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 color: Colors.black),
          //             scrollAxis: Axis.horizontal,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             blankSpace: 20.0,
          //             velocity: 100.0,
          //             pauseAfterRound: Duration(milliseconds: 100),
          //             startPadding: 10.0,
          //             accelerationDuration: Duration(seconds: 1),
          //             accelerationCurve: Curves.linear,
          //             decelerationDuration: Duration(milliseconds: 500),
          //             decelerationCurve: Curves.easeOut,
          //           ),
          //         ),
          //         Expanded(
          //           child: CarouselSlider(
          //             carouselController: _carouselcontroller,

          //             items: urls
          //                 .map((e) => Container(
          //                       margin: EdgeInsets.all(6.0),
          //                       decoration: BoxDecoration(
          //                         borderRadius:
          //                             BorderRadius.circular(8.0),
          //                         image: DecorationImage(
          //                           image: NetworkImage(e.toString()),
          //                           fit: BoxFit.cover,
          //                         ),
          //                       ),
          //                     ))
          //                 .toList(),
          //             //Slider Container properties
          //             options: CarouselOptions(
          //                 height:
          //                     MediaQuery.of(context).size.height * .68,
          //                 enlargeCenterPage: true,
          //                 autoPlay: true,
          //                 aspectRatio: 30 / 46,
          //                 autoPlayCurve: Curves.fastOutSlowIn,
          //                 enableInfiniteScroll: true,
          //                 autoPlayAnimationDuration:
          //                     Duration(milliseconds: 800),
          //                 viewportFraction: 1,
          //                 onPageChanged: (index, reason) {
          //                   setState(() {
          //                     _current = index;
          //                   });
          //                 }),
          //           ),
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: urls.asMap().entries.map((entry) {
          //             return GestureDetector(
          //               onTap: () =>
          //                   _carouselcontroller.animateToPage(entry.key),
          //               child: Container(
          //                 width: 12.0,
          //                 height: 12.0,
          //                 margin: EdgeInsets.symmetric(
          //                     vertical: 8.0, horizontal: 4.0),
          //                 decoration: BoxDecoration(
          //                     shape: BoxShape.circle,
          //                     color: (Theme.of(context).brightness ==
          //                                 Brightness.dark
          //                             ? Colors.white
          //                             : Colors.black)
          //                         .withOpacity(
          //                             _current == entry.key ? 0.9 : 0.4)),
          //               ),
          //             );
          //           }).toList(),
          //         ),
          //       ]),
          //       //<Widget>[]
          //     ), //Column
          //   )
          //       //Padding
          //       //Container
          //       );
          // }) //Center
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
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
                        elevation: 5,
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
                  ),
                  Container(
                    height: 6,
                    color: Colors.grey[350],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 15.0, vertical: 5),
                  //   child: Card(
                  //     elevation: 5,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Column(
                  //         children: [
                  //           Row(
                  //             children: [
                  //               // Container(
                  //               //   height: 60,
                  //               //   width: 60,
                  //               //   child: ClipRRect(
                  //               //       borderRadius:
                  //               //           BorderRadius.circular(100),
                  //               //       child: Image.asset(
                  //               //           "assets/Images/rehman.png")),
                  //               // ),
                  //               SizedBox(
                  //                 width: 10,
                  //               ),
                  //               Column(
                  //                 // mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text(
                  //                     "AL-REHMAN GARDEN",
                  //                     style: TextStyle(fontSize: 20),
                  //                   ),
                  //                   SizedBox(
                  //                     height: 5,
                  //                   ),
                  //                   // Text(
                  //                   //   // "22 Hours ago",
                  //                   //   style: TextStyle(color: Colors.blue),
                  //                   // )
                  //                 ],
                  //               )
                  //             ],
                  //           ),
                  //           SizedBox(
                  //             height: 8,
                  //           ),
                  //           Text(
                  //               " Discover peace of mind at Al Rehman Garden Phase II with the presence of Al Rehman Hospital. This cutting-edge medical facility ensures that your well-being remains a top priority. From emergency care to specialized treatments, the hospital caters to your healthcare needs with state-of-the-art equipment and expert medical professionals. "),
                  //           // SizedBox(
                  //           //   height: 8,
                  //           // ),
                  //           Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(10),
                  //                   child: Image.network(
                  //                       "https://firebasestorage.googleapis.com/v0/b/usman-a51d1.appspot.com/o/images%2FDoctor.jpg?alt=media&token=5379c5a7-1009-45c3-820a-bd428a77fcde"))),

                  //           Row(
                  //             children: [
                  //               IconButton(
                  //                 icon: isIconChanged
                  //                     ? Icon(Icons.favorite,
                  //                         color: Colors
                  //                             .red) // Change this to your desired icon
                  //                     : Icon(
                  //                         Icons.favorite_border,
                  //                       ), // Initial icon
                  //                 onPressed: () {
                  //                   toggleIcon();
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Container(
                                //   height: 60,
                                //   width: 60,
                                //   child: ClipRRect(
                                //       borderRadius:
                                //           BorderRadius.circular(100),
                                //       child: Image.asset(
                                //           "assets/Images/rehman.png")),
                                // ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "AL-REHMAN GARDEN ",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Text(
                                    //   "22 Hours ago",
                                    //   style: TextStyle(color: Colors.blue),
                                    // )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                                "Exciting News!\nMuhammad Ali Khan, Country Head of Al Rehman Developers, has brought into effect a game-changing policy for Al Rehman's authorized real estate dealers. Proving to be quite beneficial for our valued partners this new policy is committed to providing stability, better opportunities, and prosperity for all in the real estate sector.\nTogether, we'll build a brighter future!"),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                      "assets/Images/nf1.jpg")),
                            ),

                            Row(
                              children: [
                                IconButton(
                                  icon: isIconChanged
                                      ? Icon(Icons.favorite,
                                          color: Colors
                                              .red) // Change this to your desired icon
                                      : Icon(
                                          Icons.favorite_border,
                                        ), // Initial icon
                                  onPressed: () {
                                    toggleIcon();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Container(
                                //   height: 60,
                                //   width: 60,
                                //   child: ClipRRect(
                                //       borderRadius:
                                //           BorderRadius.circular(100),
                                //       child: Image.asset(
                                //           "assets/Images/rehman.png")),
                                // ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "AL-REHMAN GARDEN",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Text(
                                    //   "22 Hours ago",
                                    //   style: TextStyle(color: Colors.blue),
                                    // )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                                " Hey there, fitness enthusiasts and lifestyle lovers! Welcome to Al Rehman Garden’s hottest new wellness destination, Shapes Community Club.\nGet ready to sweat it out with state-of-the-art gym equipment and expert trainers to help you reach your fitness goals. Discover the benefits of a healthy lifestyle with our nutrition counselling and diet plans to keep you feeling your best."),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                      "assets/Images/nf2.jpg")),
                            ),

                            Row(
                              children: [
                                IconButton(
                                  icon: isIconChanged
                                      ? Icon(Icons.favorite,
                                          color: Colors
                                              .red) // Change this to your desired icon
                                      : Icon(
                                          Icons.favorite_border,
                                        ), // Initial icon
                                  onPressed: () {
                                    toggleIcon();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Container(
                                //   height: 60,
                                //   width: 60,
                                //   child: ClipRRect(
                                //       borderRadius:
                                //           BorderRadius.circular(100),
                                //       child: Image.asset(
                                //           "assets/Images/rehman.png")),
                                // ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "AL-REHMAN GARDEN",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    // Text(
                                    //   "22 Hours ago",
                                    //   style: TextStyle(color: Colors.blue),
                                    // )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Column(
                              children: [
                                Text(
                                    " Al Rehman Garden Phase 2: Where beauty meets serenity. From the Grand mosque that graces the skyline to lush parks where families gather – it's a complete community experience!\nFor more information call our UAN: 042-111-191-191 or visit our website "),
                                    Align( alignment: Alignment.centerLeft,   child: TextButton(onPressed: (){launch("https://alrehmangardens.com/");}, child:Text("https://alrehmangardens.com/")))
                              ],
                            ),
                            // SizedBox(
                            //   height: 8,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                      "assets/Images/nf3.jpg")),
                            ),

                            Row(
                              children: [
                                IconButton(
                                  icon: isIconChanged
                                      ? Icon(Icons.favorite,
                                          color: Colors
                                              .red) // Change this to your desired icon
                                      : Icon(
                                          Icons.favorite_border,
                                        ), // Initial icon
                                  onPressed: () {
                                    toggleIcon();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                 ])))); //Scaffold
  }
}
