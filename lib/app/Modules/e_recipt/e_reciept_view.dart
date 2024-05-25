import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/data/Models/groceryModel.dart';

class Receipt extends StatefulWidget {
  final GroceryModel grocery;
  const Receipt({super.key, required this.grocery});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {
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
                Get.back();
              }),
          foregroundColor: const Color(0xff212121),
          title: const Text(
            'E-Reciept',
            style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Card(
                  elevation: 5,
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Customer Name',
                                style: TextStyle(color: Color(0xff616161), fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.grocery.customerName,
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Address',
                                style: TextStyle(color: Color(0xff616161), fontWeight: FontWeight.w500),
                              ),
                              Text(widget.grocery.customerAddress, style: const TextStyle(fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Phone',
                                style: TextStyle(color: Color(0xff616161), fontWeight: FontWeight.w500),
                              ),
                              Text(widget.grocery.customerPhone, style: const TextStyle(fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(6.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Order Date',
                        //         style: TextStyle(
                        //             color: Color(0xff616161),
                        //             fontWeight: FontWeight.w500),
                        //       ),
                        //       Text('5/8/2024',
                        //           style: TextStyle(fontWeight: FontWeight.w700))
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Hours',
                                style: TextStyle(color: Color(0xff616161), fontWeight: FontWeight.w500),
                              ),
                              Text(widget.grocery.time, style: const TextStyle(fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      for (var item in widget.grocery.items)
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.itemName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  item.price.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  item.total.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery Charges',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '150 Rs',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          )),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          thickness: 1,
                          color: Color(0xffEEEEEE),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: Color(0xff616161),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.grocery.allTotal.toString(), // Display the total amount
                              style: const TextStyle(
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
