import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testapp/Screens/main/Notifications.dart';
import 'package:testapp/Screens/main/drawer.dart';
import 'package:testapp/Screens/main/feed/feedsLikes.dart';
import 'package:testapp/global.dart';
import 'package:video_player/video_player.dart';

class Newsandfeeds extends StatefulWidget {
  static const routeName = "Menu2";

  static List<IconData> navigatorsIcon = [
    Icons.desktop_mac_rounded,
  ];

  const Newsandfeeds({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Newsandfeeds> {
  bool isProcessing = false;
  Timer? debounceTimer;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // List<String> icon = [
  //   "assets/Images/Invoseg.jpg",
  //   "assets/Images/Invoseg.jpg",
  //   "assets/Images/Invoseg.jpg",
  //   "assets/Images/Invoseg.jpg",
  //   "assets/Images/Invoseg.jpg",
  //   "assets/Images/Invoseg.jpg",
  // ];

  // List<String> title = [
  //   "Indigo",
  //   "Hafsaz",
  //   "RIC",
  //   "Indigo",
  //   "Hafsaz",
  //   "RIC",
  // ];
  // List<String> description = [
  //   "IndiGoReach partnered with renowned eye care centers such as the Centre for Sight, Dr. Agarwals Eye Hospital, The Eye Foundation, ASG Eye Hospital, Vasan Eye Care, and others.",
  //   "Hafsaz is a clothing brand defined by allure and grace.It is led by creative director, Beenish Azhar, a housewife who has finest sense of style and a passion for creating breathtaking designs.Every outfit is made with great attention to detail, exactness and delicateness.",
  //   "Riphah International University, Lahore Thokar is a private University, chartered by the Federal Government of Pakistan.The University was established with a view to producing professionals with Islamic moral and ethical values. It is sponsored by a not-for-profit trust; namely Islamic International Medical College Trust (IIMCT)",
  //   "IndiGoReach partnered with renowned eye care centers such as the Centre for Sight, Dr. Agarwals Eye Hospital, The Eye Foundation, ASG Eye Hospital, Vasan Eye Care, and others.",
  //   "Hafsaz is a clothing brand defined by allure and grace.It is led by creative director, Beenish Azhar, a housewife who has finest sense of style and a passion for creating breathtaking designs.Every outfit is made with great attention to detail, exactness and delicateness.",
  //   "Riphah International University, Lahore Thokar is a private University, chartered by the Federal Government of Pakistan.The University was established with a view to producing professionals with Islamic moral and ethical values. It is sponsored by a not-for-profit trust; namely Islamic International Medical College Trust (IIMCT)",
  // ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: const DrawerWidg(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Image(
              image: NetworkImage(logo),
              height: 40,
              width: 40,
            ),
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
                const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                if (notification_count > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        "$notification_count",
                        style: const TextStyle(
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
                  duration: const Duration(milliseconds: 700),
                  type: PageTransitionType.rightToLeftWithFade,
                  child: const Notifications(),
                ),
              );
              // No need to manually reset the count here
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instanceFor(app: secondApp)
              .collection('feed')
              .snapshots(),
          builder: (context, snapshot) {
            // EasyLoading.show();
            if (snapshot.connectionState == ConnectionState.waiting) {
              // EasyLoading.dismiss();
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              );
            } else if (snapshot.hasError) {
              // EasyLoading.dismiss();
              return Text("Error: ${snapshot.error}");
            } else {
              // EasyLoading.dismiss();
              final feeds = snapshot.data!.docs;
              print("Data=$feeds");
              return ListView.builder(
                itemCount: feeds.length, // Number of posts
                itemBuilder: (context, index) {
                  // EasyLoading.show();
                  final documentId = feeds[index].id;
                  final data = feeds[index].data() as Map<String, dynamic>;

                  final mediaUrls = data['mediaUrls'] as List<dynamic>;
                  for (int i = 0; i < mediaUrls.length; i++) {
                    if (mediaUrls[i].toString().contains('mp4')) {
                      print("Video Url at document $index at Media Urls $i");
                    } else {
                      print("Image Url at document $index at Media Urls $i");
                    }
                  }
                  // int currentIndex=0;
                  String logo = data['logo'];
                  String titles = data['title'];
                  int likes = data['likes'];
                  String des = data['description'];
                  bool favor = data['fav'];
                  // EasyLoading.dismiss();
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => LikesPage(),
                              //       ));
                              // },
                              child: Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      height: 40,
                                      width: 40,
                                      child: Image.network(logo)),
                                  Text(
                                    titles,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            // const Icon(Icons.more_vert_sharp)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            viewportFraction: 1.0, // Set to 1.0 for full width
                            initialPage: 0,
                            enableInfiniteScroll: mediaUrls.length > 1,
                            reverse: false,
                            enlargeFactor: 0.3,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              // setState(() {
                              //   currentIndex = index;
                              // });
                            },
                          ),
                          items: mediaUrls.map((url) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: getUrlWidget(url),
                                );
                              },
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 10),
                        // Text(
                        //   '${currentIndex + 1}/${mediaUrls.length}', // Displaying 1-indexed count
                        //   style: const TextStyle(fontSize: 18),
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              splashColor: Colors.transparent,

                              onPressed: () async {
                                if (isProcessing) {
                                  return; // Do nothing if the button is already processing
                                }

                                // Disable the button
                                isProcessing = true;

                                try {
                                  // Your Firestore logic here
                                  if (data['fav'] == true) {
                                    await FirebaseFirestore.instanceFor(
                                            app: secondApp)
                                        .collection('feed')
                                        .doc(documentId)
                                        .update({
                                      'fav': false,
                                      'likes': likes - 1,
                                    }).then((liks) => () async {
                                              if (likes < 0) {
                                                await FirebaseFirestore
                                                        .instanceFor(
                                                            app: secondApp)
                                                    .collection('feed')
                                                    .doc(documentId)
                                                    .update({
                                                  'fav': false,
                                                  'likes': 0,
                                                });
                                              }
                                            });

                                    print("IF $documentId");
                                  } else if (data['fav'] == false) {
                                    await FirebaseFirestore.instanceFor(
                                            app: secondApp)
                                        .collection('feed')
                                        .doc(documentId)
                                        .update({'fav': true});
                                    if (likes >= 0) {
                                      await FirebaseFirestore.instanceFor(
                                              app: secondApp)
                                          .collection('feed')
                                          .doc(documentId)
                                          .update({
                                        'likes': likes + 1,
                                        'post_likes_uid': FirebaseAuth
                                            .instance.currentUser!.uid
                                      }).then((value) => () async {
                                                await FirebaseFirestore
                                                        .instanceFor(
                                                            app: secondApp)
                                                    .collection('likesUsers')
                                                    .add({
                                                  'postId': documentId,
                                                  'likesUserId': [
                                                    {
                                                      'uid': FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid
                                                    }
                                                  ]
                                                });
                                              });
                                    } else {
                                      await FirebaseFirestore.instanceFor(
                                              app: secondApp)
                                          .collection('feed')
                                          .doc(documentId)
                                          .update({'likes': 0});
                                    }
                                    print("ELSE $documentId");
                                  }
                                } catch (error) {
                                  print("Error: $error");
                                  // Handle errors if needed
                                } finally {
                                  // Set a debounce timer to enable the button after a delay (e.g., 1 second)
                                  debounceTimer = Timer(
                                      const Duration(milliseconds: 100), () {
                                    isProcessing = false;
                                    debounceTimer?.cancel();
                                  });
                                }
                              },

                              icon: data['fav'] == false
                                  ? const Icon(
                                      Icons.favorite_border,
                                    )
                                  : const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),

                              // IconButton(
                              //   splashColor: Colors.transparent,
                              //   onPressed: () {
                              //     showModalBottomSheet(
                              //       context: context,
                              //       isScrollControlled: true,
                              //       builder: (context) => const CommentSheet(),
                              //     );
                              //   },
                              //   icon: const Icon(Icons.mode_comment_outlined),
                              // ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: InkWell(
                              child: Text(
                                "$likes Likes",
                                style: const TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LikesPage(
                                        documentId: documentId,
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              des,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "2 days ago",
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black54),
                            ))
                      ]),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

Widget getUrlWidget(String url) {
  if (url.contains('.mp4')) {
    // Display video player for URLs ending with '.mp4'
    return VideoPlayerWidget(videoUrl: url);
  } else if (url.contains('.jpg') ||
      url.contains('.jpeg') ||
      url.contains('.png')) {
    // Display Image for URLs ending with '.jpg', '.jpeg', or '.png'
    return Image(
      image: NetworkImage(url),
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  } else {
    // Handle other types of URLs
    return Container(
      color: Colors.grey,
      child: const Center(
        child: Text('Unsupported media type'),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
