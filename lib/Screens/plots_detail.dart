import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/drawer.dart';
import 'package:testapp/global.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlotsDetail extends StatefulWidget {
  const PlotsDetail({super.key});

  @override
  State<PlotsDetail> createState() => _PlotsDetailState();
}

class _PlotsDetailState extends State<PlotsDetail> {
  final List<String> listPics = [
    'assets/Images/plot1.jpg',
    'assets/Images/plot2.jpg',
    'assets/Images/dd.jpg',
    'assets/Images/ss.jpg',
    'assets/Images/home.jpg',
  ];
  final List<String> listName = [
    ' Swiss Mall Gulberg',
    ' PIA Housing Scheme',
    ' Johar Town Shop',
    ' Liberty Plot',
    ' Chungi Amar Sidhu',
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidg(),
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton( icon: Icon(Icons.arrow_back_ios_new,color: Colors.black,),onPressed: (){Navigator.pop(context);}),
        title: const Text(
          'PlotsDetail',
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
                if (notification_count >
                    0) // Show the badge only if there are unread notifications
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red, // You can customize the badge color
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Text(
                        notification_count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12, // You can customize the font size
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
                  duration: const Duration(milliseconds: 700),
                  type: PageTransitionType.rightToLeftWithFade,
                  child: Notifications(),
                ),
              );
              setState(() {
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
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
      
                viewportFraction: 0.8,
                initialPage: 0,
                // enableInfiniteScroll: true,
                reverse: false,
                //autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                //enlargeCenterPage: true,
                enlargeFactor: 0.3,
      
                /// onPageChanged: callbackFunction,
                scrollDirection: Axis.horizontal,
              ),
              //   options: CarouselOptions(height: 400.0),
              items: [
                'assets/Images/plot1.jpg',
                'assets/Images/ss.jpg',
                'assets/Images/home.jpg',
                'assets/Images/plot2.jpg',
                'assets/Images/dd.jpg',
              ].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        //  decoration: BoxDecoration(color: Colors.amber),
                        child: Image(
                          image: AssetImage(i),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        )
                        //  Text(
                        //   'text $i',
                        //   style: TextStyle(fontSize: 16.0),
                        // )
                        );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PKR 2.1 Crore',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffd9d9d9),
      
                            //    color: Color.fromARGB(255, 189, 183, 183),
                            border: Border.all(
                                width: 1, color: const Color(0xffd9d9d9))),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.favorite_outline,
                            size: 19,
                            color: Color(0xff2824e5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffd9d9d9),
      
                            //    color: Color.fromARGB(255, 189, 183, 183),
                            border: Border.all(
                                width: 1, color: const Color(0xffd9d9d9))),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.share,
                            size: 19,
                            color: Color(0xff2824e5),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: Text(
                  'Bahria Town - Jinnah Block, Bahria Town - Sector E, Bahria Town Lahore, Punjab'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.tire_repair),
                  SizedBox(
                    width: 5,
                  ),
                  Text('5 MArla'),
                  SizedBox(
                    width: 25,
                  ),
                  Icon(Icons.bed),
                  SizedBox(
                    width: 5,
                  ),
                  Text('3 Baths'),
                  SizedBox(
                    width: 25,
                  ),
                  Icon(Icons.bathtub),
                  SizedBox(
                    width: 5,
                  ),
                  Text('5 Baths'),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(15, 39, 127, 1)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.5, horizontal: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(15, 39, 127, 1)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Call',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(15, 39, 127, 1)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.5, horizontal: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.sms,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'SMS',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(5),
                //       color: const Color.fromRGBO(15, 39, 127, 1)),
                //   child: const Padding(
                //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                //     child: Row(
                //       children: [
                //         Icon(
                //           FontAwesomeIcons.whatsapp,
                //           color: Colors.white,
                //         ),
                //         SizedBox(
                //           width: 5,
                //         ),
                //         Text(
                //           'Whatsapp',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 13, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Elevate your lifestyle at Shapes Community Club, a modern haven designed to nurture your holistic well-being. Whether you’re seeking an energetic workout, a tranquil space to unwind, or a vibrant community to connect with, this club offers it all.')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
