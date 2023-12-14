import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testapp/global.dart';

class DiscountDetails extends StatefulWidget {
  String ids;
  DiscountDetails({super.key, required this.ids});

  @override
  State<DiscountDetails> createState() => _DiscountDetailsState();
}

class _DiscountDetailsState extends State<DiscountDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Discount Details",
            style: TextStyle(
                color: Color(0xff212121),
                fontWeight: FontWeight.w700,
                fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              )),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instanceFor(app: secondApp)
                .collection("discounts")
                .doc(widget.ids)
                .get(),
            builder: (context, discountSnapshot) {
              if (discountSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                );
              } else if (discountSnapshot.hasError) {
                return Text("Error: ${discountSnapshot.error}");
              } else {
                var discounts = discountSnapshot.data!;
                print("Data=$discounts");
                var data = discounts.data() as Map<String, dynamic>;
                var mediaUrls = data['mediaUrls'] as List<dynamic>;
                print("Media = ${mediaUrls[0]}");
                final logo = data['logo'] as Map<String, dynamic>;
                var name = data['Name'];
                var address = data['address'];
                var discount = data['discount'];
                var description = data['description'];

                // var data=discounts;

                // Check if 'title' field exists and is not null before accessing it

                return Flex(
                  direction: Axis.vertical,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            // height: MediaQuery.of(context)
                            //         .size
                            //         .height /
                            //     2.5,
                            child: Card(
                                // elevation: 10,
                                color: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Column(children: [
                                  Container(
                                    width: 400,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          // image: AssetImage(
                                          //     "assets/Images/d2.jpg"),
                                          image: NetworkImage(mediaUrls[0]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 40,
                                          //     ??
                                          // "https://upload.wikimedia.org/wikipedia/commons/3/33/Vanamo_Logo.png"), // Image(
                                          //     // image: AssetImage(
                                          //     //     listlogo[0])
                                          //     image: NetworkImage(
                                          //         "https://firebasestorage.googleapis.com/v0/b/usman-a51d1.appspot.com/o/Logos%2FWhatsApp%20Image%202023-10-31%20at%2016.31.40_2c2e9a63.jpg?alt=media&token=031cda9c-dc7f-4bf3-9217-356ccd00955a")),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  228, 211, 211, 211),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Image.network(
                                            logo['logoUrl'],
                                            // "blob:http://localhost:3000/7daf2f8d-50bc-48d8-973a-2f851b201501"
                                          ),
                                        ),
                                      ),
                                    ),

                                    // child: ClipRect(
                                    //     child: Image.asset(
                                    //         "assets/Images/Invoseg.jpg"))
                                  ),
                                  Container(
                                    // height: 80,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15))),

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      name,
                                                      style: const TextStyle(
                                                          fontSize: 18,
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
                                                    decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromRGBO(
                                                            15, 39, 127, 1),

                                                        // color: Colors.red[600],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    // width: ,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        address,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  15, 39, 127, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "$discount%",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ])))),
                    Expanded(
                        // height: MediaQuery.of(context).size.height,
                        child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 6),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Our Offer",
                                style: TextStyle(
                                    fontSize: 20,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            // decoration:
                            //     BoxDecoration(borderRadius: BorderRadius.circular(100)),
                            // height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              // color: Colors.red,
                              // elevation: 10,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "UP TO $discount % OFF AT $name",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //         color: const Color.fromRGBO(
                                      //             15, 39, 127, 1),
                                      //         borderRadius:
                                      //             BorderRadius.circular(10)),
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Text(
                                      //         "$discount%",
                                      //         style: const TextStyle(
                                      //             color: Colors.white,
                                      //             fontSize: 20),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            description,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
                  ],
                );
              }
            }));
  }
}
