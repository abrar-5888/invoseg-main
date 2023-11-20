import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Providers/NotificationCounterProvider.dart';
import 'package:testapp/Screens/Complaint.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/Prescription.dart';
import 'package:testapp/Screens/drawer.dart';
import 'package:testapp/global.dart';
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
  String? link = "ddd";
  String videoId = "dd";
  var y_controller;

// Fetch Youtube Link from Firebase !
  Future<String?> fetchYoutubeLink() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('VideoPanel').get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          link = data['Url'];
        });

        print("Linkdo=${link}");
      } else {
        print("No documents found in the 'VideoPanel' collection.");
      }
    } catch (e) {
      print("Error fetching data: $e");
      return null;
    }
  }
// InitState

  void initState() {
    super.initState();
    getAllIsReadStatus();
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
  }

  bool isLoading = true;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<String> icon = [
    "assets/Images/Invoseg.jpg",
    "assets/Images/Invoseg.jpg",
    "assets/Images/Invoseg.jpg",
    "assets/Images/Invoseg.jpg",
    "assets/Images/Invoseg.jpg",
    "assets/Images/Invoseg.jpg",
  ];
  List<String> title = [
    "Indigo",
    "Hafsaz",
    "RIC",
    "Indigo",
    "Hafsaz",
    "RIC",
  ];
  List<String> description = [
    "IndiGoReach partnered with renowned eye care centers such as the Centre for Sight, Dr. Agarwals Eye Hospital, The Eye Foundation, ASG Eye Hospital, Vasan Eye Care, and others.",
    "Hafsaz is a clothing brand defined by allure and grace.It is led by creative director, Beenish Azhar, a housewife who has finest sense of style and a passion for creating breathtaking designs.Every outfit is made with great attention to detail, exactness and delicateness.",
    "Riphah International University, Lahore Thokar is a private University, chartered by the Federal Government of Pakistan.The University was established with a view to producing professionals with Islamic moral and ethical values. It is sponsored by a not-for-profit trust; namely Islamic International Medical College Trust (IIMCT)",
    "IndiGoReach partnered with renowned eye care centers such as the Centre for Sight, Dr. Agarwals Eye Hospital, The Eye Foundation, ASG Eye Hospital, Vasan Eye Care, and others.",
    "Hafsaz is a clothing brand defined by allure and grace.It is led by creative director, Beenish Azhar, a housewife who has finest sense of style and a passion for creating breathtaking designs.Every outfit is made with great attention to detail, exactness and delicateness.",
    "Riphah International University, Lahore Thokar is a private University, chartered by the Federal Government of Pakistan.The University was established with a view to producing professionals with Islamic moral and ethical values. It is sponsored by a not-for-profit trust; namely Islamic International Medical College Trust (IIMCT)",
  ];
  List<bool> fav = [false, false, false, false, false, false];
  bool favo = false;
  List<String> image = [
    "assets/Images/d2.jpg",
    "assets/Images/d1.jpg",
    "assets/Images/ripha.jpg",
    "assets/Images/d2.jpg",
    "assets/Images/d1.jpg",
    "assets/Images/ripha.jpg",
  ];

  Widget build(BuildContext context) {
    int num = 0;
    return Scaffold(
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
            'Feeds',
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
                  if (notification_count > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: Text(
                          "${notification_count}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () async {
                // resetNotificationCount();

                setState(() {
                  notification_count = 0;
                });
                updateAllIsReadStatus(true);
                // Handle tapping on the notifications icon
                await Navigator.push(
                  context,
                  PageTransition(
                    duration: Duration(milliseconds: 700),
                    type: PageTransitionType.rightToLeftWithFade,
                    child: Notifications(),
                  ),
                );
                // No need to manually reset the count here
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
        // body: FutureBuilder(
        //   future: FirebaseFirestore.instance.collection("feed").get(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasError) {
        //       print("Error");
        //       return Text("Error");
        //     } else if(snapshot.hasData) {
        //       var data=snapshot.data!.docs;
        //       var title="Abrar";
        //       var image=data[''];
        //       var descripiton;
        //       return Container(
        //         width: MediaQuery.of(context).size.width,
        //         height: MediaQuery.of(context).size.height / 3,
        //         child: Card(
        //           child: Padding(
        //             padding: const EdgeInsets.all(5.0),
        //             child: Column(
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.all(5.0),
        //                   child: Row(
        //                     children: [Text("data")],
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       );
        //     }
        //   },
        // )
        body: ListView.builder(
          itemCount: image.length, // Number of posts
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                // User info and post content
                ListTile(
                  leading: CircleAvatar(
                    // User profile picture
                    radius: 15,
                    backgroundImage: AssetImage('assets/Images/Invoseg.jpg'),
                  ),
                  title: Text(title[index]), // Username
                  // subtitle: Text('Location'), // Location or caption
                  trailing: Icon(Icons.more_vert), // Options button
                ),
                // Post image
                Image.asset(image[index]),
                // Like, comment, and send buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        setState(() {
                          favo = !favo;
                        });
                        print(favo);
                        if (favo == true) {
                          setState(() {
                            num = num + 1;
                          });
                        }
                        if (favo == false) {
                          setState(() {
                            num = num - 1;
                          });
                        }
                      },
                      icon: favo == false
                          ? Container(
                              height: 20,
                              width: 20,
                              child: Image.asset("assets/Images/heart.png"),
                            )
                          : Icon(
                              Icons.favorite,
                              size: 25,
                              color: Colors.red,
                            ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                          icon: Image.asset("assets/Images/chat.png"),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200, // Set the height as needed
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Test"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera),
                                        title: Text('Take a Photo'),
                                        onTap: () {
                                          // Handle taking a photo
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo),
                                        title: Text('Choose from Gallery'),
                                        onTap: () {
                                          // Handle choosing from the gallery
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),
                // Like count and comments
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('1234'), // Like count
                      Text('View all 10 comments'), // View all comments
                      Row(
                        children: <Widget>[
                          Text('username: '), // Comment user
                          Text('This is a comment.'), // Comment text
                        ],
                      ),
                      // Additional comments go here
                    ],
                  ),
                ),
                // Post time
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('2 hours ago'),
                    ),
                  ),
                ),
              ],
            ); // Custom widget for displaying posts
          },
        ));
  }
}


// class InstagramPost extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
            /*Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        color: Colors.white,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Card(
                                  elevation: 1,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 180, 180, 180),
                                  height: 2,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.9,
                                width: MediaQuery.of(context).size.width,
                                // color: Colors.red,
                                child: ListView.builder(
                                  itemCount: image.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      color: Colors.transparent,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Container(
                                              // color: Colors.yellow,
                                              height: 70,
                                              width: 70,
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: Container(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    child: Image.asset(
                                                        icon[index]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: 4,
                                            // ),
                                            Text(
                                              title[index],
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ]),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              child: Image.asset(image[index]),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                description[index],
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Container(
                                                    child: IconButton(
                                                  icon: fav[index]
                                                      ? Icon(Icons.favorite,
                                                          color: Colors
                                                              .red) // Change this to your desired icon
                                                      : Icon(
                                                          Icons.favorite_border,
                                                        ), // Initial icon
                                                  onPressed: () {
                                                    setState(() {
                                                      fav[index] = !fav[index];
                                                    });
                                                  },
                                                )),
                                              ),
                                              Container(
                                                  child: IconButton(
                                                icon: Icon(
                                                    Icons.comment_outlined),
                                                onPressed: () {
                                                  _showBottomSheet(context);
                                                },
                                              ))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ]))))));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(child: Complainform());
      },
    );
  }
}
*/
