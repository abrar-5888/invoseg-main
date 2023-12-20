import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:com.invoseg.innovation/Screens/main/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/main/drawer.dart';
import 'package:com.invoseg.innovation/Screens/main/feed/feedsLikes.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  late String userUid; // Add this variable to store the current user UID

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<FeedData> feedDataList = [];

  int _currentIndex = 0;
  int _currentIndexs = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    fetchData();
    userUid = FirebaseAuth.instance.currentUser!.uid; // Initialize userUid
  }

  Future<void> fetchLikesAndUpdateList(
      String documentId, FeedData feedData) async {
    try {
      final DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instanceFor(app: secondApp)
              .collection('feed')
              .doc(documentId)
              .get();

      int updatedLikes = docSnapshot['likes'];

      // Update local state with the latest data
      setState(() {
        feedData.likes = updatedLikes;
      });

      print("Likes updated for documentId $documentId: $updatedLikes");
    } catch (error) {
      print("Error fetching likes: $error");
    }
  }

  Future<void> fetchData() async {
    try {
      final snapshot = await FirebaseFirestore.instanceFor(app: secondApp)
          .collection('feed')
          .orderBy('timestamp', descending: true)
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          feedDataList.clear();
          feedDataList = snapshot.docs.map((doc) {
            final data = doc.data();
            return FeedData.fromMap(doc.id, data);
          }).toList();
        });
        print(feedDataList);
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      drawer: const DrawerWidg(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Image(
              image: AssetImage("assets/Images/izmir.jpg"),
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
              setState(() {
                notification_count = 0;
              });
              await Navigator.push(
                context,
                PageTransition(
                  duration: const Duration(milliseconds: 700),
                  type: PageTransitionType.rightToLeftWithFade,
                  child: const Notifications(),
                ),
              );
              setState(() {
                updateAllIsReadStatus(true);
                notification_count = 0;
              });
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
      body: ListView.builder(
        itemCount: feedDataList.length,
        itemBuilder: (context, index) {
          return _buildFeedItem(feedDataList[index]);
        },
      ),
    );
  }

  Widget _buildFeedItem(FeedData feedData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 40,
                          width: 40,
                          child: Image.network(feedData.logo),
                        ),
                        Text(
                          feedData.title,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              items: feedData.mediaUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: getUrlWidget(url, feedData.mediaUrls.length),
                    );
                  },
                );
              }).toList(),
              carouselController: _carouselController,
              options: CarouselOptions(
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: feedData.mediaUrls.length > 1,
                reverse: false,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndexs = index;
                    _currentIndex = index;
                    print(_currentIndexs);
                  });

                  // Additional logic based on page change if needed
                  print("Page changed to index: $index, reason: $reason");
                },
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                autoPlay: false,
                autoPlayInterval: const Duration(days: 365),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // DotsIndicator(
            //   dotsCount: feedData.mediaUrls.length,
            //   position: _currentIndex != 1 ? _currentIndexs : _currentIndex,
            //   decorator: DotsDecorator(
            //     size: const Size.square(8.0),
            //     activeSize: const Size(20.0, 8.0),
            //     activeShape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(5.0),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      if (isProcessing) {
                        return;
                      }

                      isProcessing = true;

                      try {
                        DocumentSnapshot docSnapshot =
                            await FirebaseFirestore.instanceFor(app: secondApp)
                                .collection('feed')
                                .doc(feedData.documentId)
                                .get();

                        int updatedLikes = docSnapshot['likes'];
                        List<String>? updatedLikesuids =
                            List<String>.from(docSnapshot['Likesuids'] ?? []);

                        if (updatedLikesuids.contains(userUid)) {
                          await FirebaseFirestore.instanceFor(app: secondApp)
                              .collection('feed')
                              .doc(feedData.documentId)
                              .update({
                            'likes': updatedLikes - 1,
                            'Likesuids': FieldValue.arrayRemove([userUid]),
                          });

                          updatedLikesuids.remove(userUid);
                          fetchLikesAndUpdateList(
                              feedData.documentId, feedData);
                        } else {
                          await FirebaseFirestore.instanceFor(app: secondApp)
                              .collection('feed')
                              .doc(feedData.documentId)
                              .update({
                            'likes': updatedLikes + 1,
                            'Likesuids': FieldValue.arrayUnion([userUid]),
                          });

                          updatedLikesuids.add(userUid);
                          fetchLikesAndUpdateList(
                              feedData.documentId, feedData);
                        }

                        // Update local state with the latest data
                        setState(() {
                          feedData.likes = updatedLikes;
                          feedData.Likesuids = updatedLikesuids;
                        });

                        print("Likes and fav data updated: $feedDataList");
                      } catch (error) {
                        print("Error: $error");
                      } finally {
                        debounceTimer =
                            Timer(const Duration(milliseconds: 100), () {
                          isProcessing = false;
                          debounceTimer?.cancel();
                        });
                      }
                    },
                    icon: feedData.Likesuids != null &&
                            feedData.Likesuids!.contains(userUid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  child: Text(
                    "${feedData.likes} Likes",
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LikesPage(documentId: feedData.documentId),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  feedData.description,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "2 days ago",
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getUrlWidget(String url, count) {
    // return
    // child: count != 1 ? Text(count.toString()) : const Text("one"));
    if (url.contains('.mp4')) {
      return VideoPlayerWidget(videoUrl: url);
    } else if (url.contains('.jpg') ||
        url.contains('.jpeg') ||
        url.contains('.png')) {
      return Image(
        image: NetworkImage(url),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    } else if (url.contains('youtube.com') || url.contains('youtu.be')) {
      return YoutubePlayerWidget(videoUrl: url);
    } else {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Text('Unsupported media type'),
        ),
      );
    }
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

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
      allowFullScreen: false,
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

class YoutubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const YoutubePlayerWidget({Key? key, required this.videoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';
    return YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            showLiveFullscreenButton: false,
          ),
        ),
        bottomActions: [
          const SizedBox(width: 8.0),
          CurrentPosition(),
          const SizedBox(width: 175.0),
          RemainingDuration(),
          const SizedBox(width: 10.0),
          const PlaybackSpeedButton(),
        ]);
  }
}

class FeedData {
  final String documentId;
  final String logo;
  final String title;
  final List<String> mediaUrls;
  int likes;
  final String description;
  List<String>? Likesuids;

  FeedData({
    required this.documentId,
    required this.logo,
    required this.title,
    required this.mediaUrls,
    required this.likes,
    required this.description,
    this.Likesuids,
  });

  factory FeedData.fromMap(String documentId, Map<String, dynamic> data) {
    return FeedData(
      documentId: documentId,
      logo: data['logo'],
      title: data['title'],
      mediaUrls: List<String>.from(data['mediaUrls']),
      likes: data['likes'],
      description: data['description'],
      Likesuids: List<String>.from(data['Likesuids'] ?? []),
    );
  }
}
