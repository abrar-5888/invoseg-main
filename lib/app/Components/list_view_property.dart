import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Modules/plotDetails/plot_details_view.dart';
import 'package:com.invoseg.innovation/config/themes/themes%20color/colors.dart';
import 'package:com.invoseg.innovation/app/data/Models/plotsModel.dart';

class ListViewProperty extends StatelessWidget {
  final List<PlotsModel> list;
  const ListViewProperty({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            PlotsModel listIndex = list[index];
            return InkWell(
              onTap: () {
                Get.to(() => PlotsDetail(plot: listIndex));
              },
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                        height: Get.height,
                        width: Get.width / 1.14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ThemeColor.grey,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(25)),
                                child: Image.network(
                                  listIndex.mediaUrls[0],
                                  height: 125,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listIndex.title,
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      listIndex.area,
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      maxLines: 3,
                                      listIndex.description,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 9),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    const SizedBox(
                      width: 17,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
