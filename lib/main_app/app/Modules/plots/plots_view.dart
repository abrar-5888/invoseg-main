// ignore_for_file: avoid_print

import 'package:com.invoseg.innovation/main_app/app/Modules/plotDetails/plot_details_view.dart';
import 'package:com.invoseg.innovation/main_app/app/Modules/plots/plots_controller.dart';
import 'package:com.invoseg.innovation/main_app/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Plots extends StatefulWidget {
  const Plots({super.key});

  @override
  State<Plots> createState() => _PlotsState();
}

class _PlotsState extends State<Plots> {
  PlotsController controller = Get.put<PlotsController>(PlotsController());
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: controller.plots.length,
      itemBuilder: (BuildContext context, int index) {
        var plot = controller.plots[index];
        String time = getTimeAgo(plot.timestamp);
        return Padding(
          padding: const EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 8),
          child: InkWell(
            onTap: () {
              Get.to(() => PlotsDetail(
                    plot: plot,
                  ));
            },
            child: Flex(direction: Axis.vertical, children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color.fromRGBO(236, 238, 240, 1),
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 3.1,
                            width: MediaQuery.of(context).size.height / 5.5,
                            child: Stack(children: [
                              Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(plot.mediaUrls[0]),
                                height: MediaQuery.of(context).size.width / 3,
                                width: MediaQuery.of(context).size.height / 5.5,
                              ),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, right: 8, left: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.local_fire_department_rounded, size: 14, color: Colors.red),
                                    Icon(Icons.verified_user, size: 14, color: Colors.green),
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ), // Text(
                                //   listName[index],
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold),
                                // ),
                                Row(
                                  children: [
                                    Text(
                                      'PKR ${plot.price}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(color: const Color(0xffd9d9d9), borderRadius: BorderRadius.circular(2)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          plot.type,
                                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  plot.address.split(' ').take(3).join(' '),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.bed,
                                        size: 13,
                                      ),

                                      // SizedBox(
                                      //   width: 1,
                                      // ),

                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        plot.room,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.bathtub,
                                        size: 13,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        plot.bath,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),

                                      const Icon(
                                        Icons.tire_repair,
                                        size: 13,
                                      ),
                                      Text(
                                        plot.area,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Added: $time',
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final Uri smsUri = Uri.parse('smsto:${plot.phone}');
                                        try {
                                          await launchUrl(smsUri);
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: const Color.fromRGBO(15, 39, 127, 1)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.chat,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'SMS',
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final Uri smsUri = Uri.parse('tel:${plot.phone}');
                                        try {
                                          await launchUrl(smsUri);
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: const Color.fromRGBO(15, 39, 127, 1),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'CALL',
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
