import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/data/Models/discountsModel.dart';
import 'package:com.invoseg.innovation/app/Components/discountCard.dart';
// ignore_for_file: file_names

class DiscountTab extends StatefulWidget {
  final String name;
  final List<DiscountsModel> discount;
  const DiscountTab({super.key, required this.name, required this.discount});

  @override
  State<DiscountTab> createState() => DiscountTabState();
}

class DiscountTabState extends State<DiscountTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => widget.discount.isEmpty
            ? Center(
                child: Text("No ${widget.name} discounts available"),
              )
            : Column(children: [
                SizedBox(
                    // color: Colors.amber,
                    height: MediaQuery.of(context).size.height / 1.3,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: widget.discount.length,
                        itemBuilder: (context, index) {
                          DiscountsModel discount = widget.discount[index];
                          return DiscountCard(discount: discount, details: false);
                        }))
              ])));
  }
}
