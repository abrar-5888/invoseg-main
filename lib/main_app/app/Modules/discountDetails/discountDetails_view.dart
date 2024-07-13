import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/discountsModel.dart';
import 'package:com.invoseg.innovation/main_app/app/Components/discountCard.dart';
// ignore_for_file: file_names

// ignore_for_file: must_be_immutable

class DiscountDetails extends StatefulWidget {
  DiscountsModel discount;
  DiscountDetails({super.key, required this.discount});

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
          style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 24),
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
      body: Column(
        children: [
          DiscountCard(discount: widget.discount, details: true),
          Expanded(
              // height: MediaQuery.of(context).size.height,
              child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // color: Colors.red,
                    // elevation: 10,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "UP TO ${widget.discount.discount}% OFF AT ${widget.discount.name}",
                                style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.discount.description,
                                  style: const TextStyle(fontSize: 15),
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
      ),
    );
  }
}
