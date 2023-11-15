import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Screens/Discounts/discountDetails.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  final List<String> listPics = [
    'assets/Images/d2.jpg',
    'assets/Images/d1.jpg',
    'assets/Images/ripha.jpg',
    'assets/Images/gym.jpg',
    'assets/Images/d3.jpg',
    'assets/Images/amessa.jpg',
  ];
  final List<String> listlogo = [
    'assets/Images/l1.jpg',
    'assets/Images/l2.jpg',
    'assets/Images/l3.jpg',
    'assets/Images/l1.jpg',
    'assets/Images/l1.jpg',
    'assets/Images/l1.jpg',
  ];
  final List<String> destext = [
    'outlet open',
    'outlet open',
    'Thokar Campus',
    'outlet open',
    'outlet open',
    'outlet open'
  ];
  final List<String> titletext = [
    'Indigo Rooms',
    'Hafsaz',
    'Riphah International College',
    'Indigo Gym',
    'The Skye',
    'La Messa',
  ];
  final List<String> discount = [
    '20%',
    '20%',
    '50% ',
    '20%',
    '20%',
    '20%',
  ];

  @override
  Widget build(BuildContext context) {
    bool iconChange = false;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  // color: Colors.amber,
                  child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
              )),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 1.36,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("discounts")
                        .get(),
                    builder: (context, discountSnapshot) {
                      if (discountSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        );
                      } else if (discountSnapshot.hasError) {
                        return Text("Error: ${discountSnapshot.error}");
                      } else {
                        final discounts = discountSnapshot.data!.docs;
                        print("Data=$discounts");
                        // var data=discounts;

                        // Check if 'title' field exists and is not null before accessing it

                        return ListView.builder(
                            itemCount: discounts.length,
                            itemBuilder: (context, index) {
                              final data = discounts[index].data()
                                  as Map<String, dynamic>;
                              final mediaUrls =
                                  data['mediaUrls'] as List<dynamic>;
                              print("Media = ${mediaUrls[0]}");
                              final logo = data['logo'] as List<dynamic>;
                              print(logo[0]);
                              print(data);
                              return Flex(
                                direction: Axis.vertical,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  duration: Duration(
                                                      milliseconds: 700),
                                                  type: PageTransitionType
                                                      .rightToLeftWithFade,
                                                  child: DiscountDetails()));
                                        },
                                        child: Container(
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height /
                                            //     2.5,
                                            child: Card(
                                                elevation: 10,
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    15))),
                                                child: Column(children: [
                                                  Container(
                                                    width: 400,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              listPics[0]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20))),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          width: 40,
                                                          child: Image.network(
                                                            logo[0],
                                                            // "blob:http://localhost:3000/7daf2f8d-50bc-48d8-973a-2f851b201501"
                                                          ),
                                                          //     ??
                                                          // "https://upload.wikimedia.org/wikipedia/commons/3/33/Vanamo_Logo.png"), // Image(
                                                          //     // image: AssetImage(
                                                          //     //     listlogo[0])
                                                          //     image: NetworkImage(
                                                          //         "https://firebasestorage.googleapis.com/v0/b/usman-a51d1.appspot.com/o/Logos%2FWhatsApp%20Image%202023-10-31%20at%2016.31.40_2c2e9a63.jpg?alt=media&token=031cda9c-dc7f-4bf3-9217-356ccd00955a")),
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      228,
                                                                      211,
                                                                      211,
                                                                      211),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),

                                                    // child: ClipRect(
                                                    //     child: Image.asset(
                                                    //         "assets/Images/Invoseg.jpg"))
                                                  ),
                                                  Container(
                                                    // height: 80,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        15),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        15))),

                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ListTile(
                                                        title: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      data[
                                                                          'Name'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    // width: ,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Text(
                                                                        data[
                                                                            'address'],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        color: Color.fromRGBO(15, 39, 127, 1),

                                                                        // color: Colors.red[600],
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        trailing: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              "${data['discount']}%",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17),
                                                            ),
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      15,
                                                                      39,
                                                                      127,
                                                                      1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]))),
                                      ))
                                ],
                              );
                            });
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
