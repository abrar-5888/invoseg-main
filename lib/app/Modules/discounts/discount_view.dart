import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Components/discountTab.dart';
import 'package:com.invoseg.innovation/app/Modules/discounts/discount_controller.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  @override
  Widget build(BuildContext context) {
    DiscountsController controller = Get.put<DiscountsController>(DiscountsController(), permanent: true);
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
            title: const Text(
              'Discounts',
              style: TextStyle(
                color: Color(0xff212121),
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ),
          body: Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 50,
                          child: TabBar(
                            isScrollable: true,
                            indicator: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(186, 226, 228, 233),
                              border: Border.all(
                                color: const Color.fromRGBO(15, 39, 127, 1),
                                width: 1,
                              ),
                            ),
                            unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                            labelColor: const Color.fromARGB(255, 0, 0, 0),
                            tabs: [
                              for (int i = 0; i < 6; i++)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Tab(
                                    child: Text(
                                      i == 0
                                          ? "All"
                                          : i == 1
                                              ? "Health"
                                              : i == 2
                                                  ? "Fitness"
                                                  : i == 3
                                                      ? "Food"
                                                      : i == 4
                                                          ? "Education"
                                                          : "LifeStyle",
                                      style: const TextStyle(color: Color.fromARGB(255, 6, 6, 6)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            DiscountTab(
                              discount: controller.discount,
                              name: 'All',
                            ),
                            DiscountTab(
                              discount: controller.healthDiscount,
                              name: 'Health',
                            ),
                            DiscountTab(
                              discount: controller.fitnessDiscount,
                              name: 'Fitness',
                            ),
                            DiscountTab(
                              discount: controller.foodDiscount,
                              name: 'Food',
                            ),
                            DiscountTab(
                              discount: controller.educationDiscount,
                              name: 'Education',
                            ),
                            DiscountTab(
                              discount: controller.lifeStyleDiscount,
                              name: 'LifeStyle',
                            )

                            /*   All(),
                  Health(),
                  Fitness(),
                  Food(),
                  Education(),
                  LifeStyle(),*/
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
