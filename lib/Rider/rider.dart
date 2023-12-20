import 'package:badges/badges.dart' as badge;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/Screens/main/E-Reciept.dart';

class Rider extends StatefulWidget {
  const Rider({super.key});

  @override
  State<Rider> createState() => _RiderState();
}

class _RiderState extends State<Rider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Riders'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 1.2,
            child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("grocery")
                    .orderBy("date", descending: true)
                    .get(),
                // .where('uid',isEqualTo:uid )
                builder: (context, grocerySnapshot) {
                  if (grocerySnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    );
                  } else if (grocerySnapshot.hasError) {
                    return Text("Error: ${grocerySnapshot.error}");
                  } else {
                    final groceryDocs = grocerySnapshot.data!.docs;
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: groceryDocs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final groceryData =
                              groceryDocs[index].data() as Map<String, dynamic>;

                          // Get the current document ID

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              color: Colors.white,
                              shadowColor: const Color(0xffBDBDBD),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${groceryData['date']} ",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        badge.Badge(
                                            toAnimate: false,
                                            shape: badge.BadgeShape.square,
                                            badgeColor: groceryData['Status'] ==
                                                    'Deliverd'
                                                ? const Color.fromRGBO(
                                                    15, 39, 127, 1)
                                                : const Color.fromRGBO(
                                                    15, 39, 127, 1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            badgeContent: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Text(
                                                groceryData['Status'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const ListTile(
                                    title: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      child: Text(
                                        'name',
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'address' ?? "OKA",
                                          style: TextStyle(
                                              color: Color(0xff757575),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (groceryData['Status'] ==
                                                'Processing' ||
                                            groceryData['Status'] ==
                                                'processing')
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.7,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (true == true) {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          25.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          25.0)),
                                                        ),
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            25.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            25.0))),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                2.4,
                                                            child: Column(
                                                              children: [
                                                                const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          20),
                                                                  child: Text(
                                                                    'Edit Order',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xffF75555),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            24),
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              16),
                                                                  child:
                                                                      Divider(
                                                                    thickness:
                                                                        1,
                                                                    color: Color(
                                                                        0xffEEEEEE),
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          10),
                                                                  child: Text(
                                                                    'Are you sure you want to send request for edit your order?',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff212121),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            24),
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          10),
                                                                  child: Text(
                                                                    'You can request for edit your order within 5 minutes after the E-Reciept generated.',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff424242),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 2.4,
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            style: ButtonStyle(
                                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(100),
                                                                                )),
                                                                                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 216, 225, 235)),
                                                                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20))),
                                                                            child:
                                                                                const Text('Cancel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 2.4,
                                                                          child:
                                                                              ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              // alertme("edit");
                                                                            },
                                                                            style: ButtonStyle(
                                                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(100),
                                                                                  side: const BorderSide(color: Colors.black, width: 2.0),
                                                                                )),
                                                                                backgroundColor: MaterialStateProperty.all(Colors.black),
                                                                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20))),
                                                                            child:
                                                                                const Text('Yes, Send Request', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                            "Sorry! You can't edit your order now!"),
                                                        action: SnackBarAction(
                                                          label: "OK",
                                                          onPressed: () {},
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      side: const BorderSide(
                                                          color: Colors.black,
                                                          width: 2.0),
                                                    )),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20))),
                                                child: const Text('Edit Order',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black)),
                                              ),
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                            width: groceryData['Status'] ==
                                                    'Deliverd'
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.7,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  // GroceryId =
                                                  //     groceryDocs[index]
                                                  //         .id;
                                                });
                                                // fetchStatus(groceryData['status']);
                                                // print(
                                                //     "ID =  ${groceryDocs[index].id}");
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewEReciept(
                                                        value: false,
                                                        id: groceryDocs[index]
                                                            .id,
                                                        status: groceryData[
                                                            'Status'],
                                                      ),
                                                    ));
                                              },
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    side: const BorderSide(
                                                        color: Color.fromRGBO(
                                                            15, 39, 127, 1),
                                                        width: 0.0),
                                                  )),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromRGBO(
                                                              15, 39, 127, 1)),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 20))),
                                              child: const Text(
                                                  'View E-Reciept',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                })));
  }
}
