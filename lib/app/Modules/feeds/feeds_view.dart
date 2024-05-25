import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Modules/feeds/feeds_controller.dart';
import 'package:com.invoseg.innovation/data/Models/feedsModel.dart';
import 'package:com.invoseg.innovation/data/api/feedsApi.dart';
import 'package:com.invoseg.innovation/utils/formatter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// ignore_for_file: unnecessary_import

// ignore_for_file: non_constant_identifier_names

// ignore_for_file: avoid_print

// import 'package:chewie/chewie.dart';

class Feeds extends StatefulWidget {
  static List<IconData> navigatorsIcon = [
    Icons.desktop_mac_rounded,
  ];

  const Feeds({super.key});

  @override
  FeedsState createState() => FeedsState();
}

class FeedsState extends State<Feeds> {
  final CarouselController _carouselController = CarouselController();

  FeedsController controller = Get.put<FeedsController>(FeedsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Obx(
          () => ListView.builder(
            itemCount: controller.feeds.length,
            itemBuilder: (context, index) {
              FeedsModel feed = controller.feeds[index];
              return _buildFeedItem(feed);
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildFeedItem(FeedsModel feed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                        child: Image.network(feed.logo),
                      ),
                      Text(
                        feed.title,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              items: feed.mediaUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return SizedBox(
                      child: getUrlWidget(url, feed.mediaUrls.length, controller.currentIndex.value),
                    );
                  },
                );
              }).toList(),
              carouselController: _carouselController,
              options: CarouselOptions(
                height: 400,
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: feed.mediaUrls.length > 1,
                reverse: false,
                enlargeFactor: 0.5,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  controller.currentIndex.value = index;
                },
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                autoPlay: false,
                autoPlayInterval: const Duration(days: 365),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
            ),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: feed.mediaUrls.length != 1
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(feed.mediaUrls.length, (index) {
                            return Obx(
                              () => AnimatedContainer(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.decelerate,
                                width: controller.currentIndex.value == index ? 7.0 : 7.0,
                                height: 7.0,
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: controller.currentIndex.value == index ? const BorderRadius.all(Radius.circular(6.0)) : const BorderRadius.all(Radius.circular(8.0)),
                                  color: controller.currentIndex.value == index ? const Color.fromRGBO(15, 39, 127, 1) : const Color(0xffC0C0C0),
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    : const SizedBox()),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              splashColor: Colors.transparent,
              onPressed: () async {
                if (feed.likeUids.contains(controller.userUid)) {
                  Map<String, dynamic> updatedData = {
                    'likes': feed.likes - 1,
                    'Likesuids': FieldValue.arrayRemove([controller.userUid]),
                  };

                  FeedsApi.updateLikes(feed.id, updatedData);
                } else {
                  Map<String, dynamic> updatedData = {
                    'likes': feed.likes + 1,
                    'Likesuids': FieldValue.arrayUnion([controller.userUid]),
                  };
                  FeedsApi.updateLikes(feed.id, updatedData);
                }
              },
              icon: feed.likeUids.isNotEmpty && feed.likeUids.contains(controller.userUid)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                    ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: InkWell(
                child: Text(
                  feed.likes <= 1 ? "${feed.likes} Like" : "${feed.likes} Likes",
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () {
                  if (feed.likes >= 1) {}
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
                feed.description,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTimeAgo(feed.timestamp),
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getUrlWidget(String url, int count, int index) {
    if (url.contains('.jpg') || url.contains('.jpeg') || url.contains('.png')) {
      return Image(
        image: NetworkImage(url),
        fit: BoxFit.fill,
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

class YoutubePlayerWidget extends StatelessWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

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
