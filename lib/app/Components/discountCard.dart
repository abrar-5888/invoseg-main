import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:com.invoseg.innovation/data/Models/discountsModel.dart';
import 'package:com.invoseg.innovation/app/Modules/discountDetails/discountDetails_view.dart';
// ignore_for_file: file_names

class DiscountCard extends StatelessWidget {
  final DiscountsModel discount;
  final bool details;
  const DiscountCard({required this.discount, super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (!details) {
                  Navigator.push(context, PageTransition(duration: const Duration(milliseconds: 700), type: PageTransitionType.rightToLeftWithFade, child: DiscountDetails(discount: discount)));
                }
              },
              child: Card(
                  elevation: 10,
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                  child: Column(children: [
                    Container(
                      width: 400,
                      height: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(discount.mediaUrls[0]),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 40,
                            decoration: BoxDecoration(color: const Color.fromARGB(228, 211, 211, 211), borderRadius: BorderRadius.circular(10)),
                            child: Image.network(
                              discount.logo['logoUrl'],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // height: 80,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        discount.name,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: const Color.fromRGBO(15, 39, 127, 1), borderRadius: BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          discount.address,
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
                            decoration: BoxDecoration(color: const Color.fromRGBO(15, 39, 127, 1), borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${discount.discount}%",
                                style: const TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
            ))
      ],
    );
  }
}
