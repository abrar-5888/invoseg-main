import 'package:com.invoseg.innovation/main_app/app/Modules/e_recipt/e_reciept_view.dart';
import 'package:com.invoseg.innovation/main_app/app/Modules/grocery/grocery_controller.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/groceryModel.dart';
import 'package:com.invoseg.innovation/main_app/config/themes/themes%20color/colors.dart';
import 'package:com.invoseg.innovation/main_app/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore_for_file: sort_child_properties_last

class Grocery extends StatelessWidget {
  const Grocery({super.key});

  @override
  Widget build(BuildContext context) {
    GroceryController controller = Get.put<GroceryController>(GroceryController());

    return Container(
      color: Colors.white,
      height: Get.height,
      child: Obx(
        () => controller.groceries.isNotEmpty
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.groceries.length,
                itemBuilder: (BuildContext context, int index) {
                  GroceryModel grocery = controller.groceries[index];
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: Get.width,
                            child: Card(
                              color: Colors.white,
                              elevation: 5,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          formatTime(grocery.date.millisecondsSinceEpoch),
                                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 8,
                                          top: 7,
                                        ),
                                        decoration: BoxDecoration(color: ThemeColor.blue, borderRadius: BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          child: Text(
                                            grocery.status,
                                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Text(
                                        grocery.customerName,
                                        style: const TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          grocery.customerAddress,
                                          style: const TextStyle(color: Color(0xff757575), fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            if (grocery.status.toLowerCase() != 'delivered')
                                              ElevatedButton(
                                                onPressed: () {},
                                                child: const Text('Edit Order', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black)),
                                                style: ButtonStyle(
                                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(100),
                                                    side: const BorderSide(color: Colors.black, width: 2.0),
                                                  )),
                                                ),
                                              ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.to(() => Receipt(id: grocery.id));
                                              },
                                              style: ButtonStyle(
                                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(100),
                                                    side: const BorderSide(color: Color.fromRGBO(15, 39, 127, 1), width: 0.0),
                                                  )),
                                                  backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(15, 39, 127, 1)),
                                                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20))),
                                              child: const Text('View E-Reciept', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 17,
                        ),
                      ],
                    ),
                  );
                })
            : const Center(
                child: Text("No data available"),
              ),
      ),
    );
  }
}
