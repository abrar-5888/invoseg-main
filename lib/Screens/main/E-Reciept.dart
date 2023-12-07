import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewEReciept extends StatefulWidget {
  static const routename = 'ViewEReciept';

  const ViewEReciept(
      {super.key, required this.value, required this.id, required this.status});
  final bool value;
  final String id;
  final String status;
  @override
  State<ViewEReciept> createState() => _ViewERecieptState();
}

class _ViewERecieptState extends State<ViewEReciept> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String manuallySpecifiedUID = "";
  String Status = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    manuallySpecifiedUID = widget.id;
    Status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    // print("IDd =  ${manuallySpecifiedUID}");

    final bool isButtonEnabled = widget.value;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              // Status="";
              manuallySpecifiedUID = "";
              Navigator.pop(context);
            });
          },
        ),
        foregroundColor: const Color(0xff212121),
        title: const Text(
          'E-Reciept',
          style: TextStyle(
              color: Color(0xff212121),
              fontWeight: FontWeight.w700,
              fontSize: 20),
        ),
      ),
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot snapshot) {
            var userinfo =
                json.decode(snapshot.data.getString('userinfo') as String);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                  height: MediaQuery.of(context).size.height / 1.1,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.white,
                          shadowColor: const Color(0xffBDBDBD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Customer Name',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["name"] ?? "OKA",
                                        style: const TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Address',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["address"] ?? "OKA",
                                        style: const TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Phone',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        userinfo["phoneNo"] ?? "OKA",
                                        style: const TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order Date',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'December 23, 2024',
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order Hours',
                                        style: TextStyle(
                                            color: Color(0xff616161),
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '10:00 AM',
                                        style: TextStyle(
                                            color: Color(0xff212121),
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: Colors.white,
                          shadowColor: const Color(0xffBDBDBD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: FutureBuilder<DocumentSnapshot>(
                                future: _firestore
                                    .collection("grocery")
                                    .doc(manuallySpecifiedUID)
                                    // limit(30)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  } else if (!snapshot.hasData ||
                                      snapshot.data == null) {
                                    return const Text("No data available.");
                                  } else {
                                    Map<String, dynamic>? userData =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>?;

                                    if (userData == null ||
                                        !userData.containsKey('items')) {
                                      print("Item = $userData");
                                      return const Text(
                                          "Grocery data not available.");
                                    }

                                    List<dynamic> items =
                                        userData['items'] ?? [];

                                    double totalAmount = 0;

                                    for (var item in items) {
                                      if (item is Map<String, dynamic>) {
                                        // totalAmount += (item['price'] ?? 0) *
                                        //     (item['quantity'] ?? 0);
                                        totalAmount =
                                            totalAmount + item['total'];

                                        // (int.parse(item['price']) *
                                        //     int.parse(item['quantity']));
                                      }
                                    }

                                    return Column(
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'ItemName',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Text(
                                                  'Quantity',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Text(
                                                  'Per Price',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Text(
                                                  'Total',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        for (var item in items)
                                          if (item is Map<String, dynamic>)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 45,
                                                    child: Text(
                                                      item['itemName'],
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff616161),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item['quantity']} ${item['currency']}',
                                                    style: const TextStyle(
                                                      color: Color(0xff616161),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item['price']} Rs',
                                                    style: const TextStyle(
                                                      color: Color(0xff212121),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${item['total']} Rs',
                                                    style: const TextStyle(
                                                      color: Color(0xff212121),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Delivery Charges',
                                                style: TextStyle(
                                                  color: Color(0xff212121),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                '150 Rs',
                                                style: TextStyle(
                                                  color: Color(0xff212121),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Divider(
                                            thickness: 1,
                                            color: Color(0xffEEEEEE),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Total',
                                                style: TextStyle(
                                                  color: Color(0xff616161),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                '${totalAmount + 150} Rs', // Display the total amount
                                                style: const TextStyle(
                                                  color: Color(0xff212121),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 50,
                            child: Visibility(
                              visible: Status == "Processing",
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    print(Status);
                                    if (isButtonEnabled == true) {
                                      alertme("edit-button");
                                    } else {
                                      ScaffoldMessenger.of(context)
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
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        const Color.fromRGBO(15, 39, 127, 1),
                                      ),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20))),
                                  child: const Text('Edit Order',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                    ],
                  )),
            );
          }),
    );
  }

  void alertme(String collect) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to send a request?',
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final userinfo =
                  json.decode(prefs.getString('userinfo') as String);
              await FirebaseFirestore.instance.collection(collect).add({
                "name": userinfo["name"],
                "phoneNo": userinfo["phoneNo"],
                "pressedTime": FieldValue.serverTimestamp(),
                "type": collect,
                "uid": userinfo["uid"],
                "email": userinfo["email"]
              });
              Navigator.of(ctx).pop(true);
              FirebaseFirestore.instance.collection("EditButtonRequest").add({
                "type": collect,
                "uid": userinfo["uid"],
                "pressedTime": FieldValue.serverTimestamp(),
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Your Request is sent",
                    style: TextStyle(color: Colors.black),
                  ),
                  action: SnackBarAction(
                      label: 'OK', textColor: Colors.black, onPressed: () {}),
                  backgroundColor: Colors.grey[400],
                ),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
