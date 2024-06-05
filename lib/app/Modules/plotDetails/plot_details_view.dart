// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/config/themes/themes%20color/colors.dart';
import 'package:com.invoseg.innovation/app/data/Models/plotsModel.dart';
import 'package:url_launcher/url_launcher.dart';

class PlotsDetail extends StatefulWidget {
  final PlotsModel plot;
  const PlotsDetail({super.key, required this.plot});

  @override
  State<PlotsDetail> createState() => _PlotsDetailState();
}

class _PlotsDetailState extends State<PlotsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PlotsDetails'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: Get.width / 1,
                  height: Get.height / 3,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.plot.mediaUrls.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.red,
                            ),
                            child: Image.network(
                              widget.plot.mediaUrls[index],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'PKR ${widget.plot.title}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.plot.address,
                          style: const TextStyle(),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.ac_unit_rounded),
                            Text(
                              widget.plot.area,
                              style: const TextStyle(),
                            ),
                            const Icon(Icons.bed_outlined),
                            Text(
                              '${widget.plot.room} rooms',
                              style: const TextStyle(),
                            ),
                            const Icon(Icons.bathtub_outlined),
                            Text(
                              maxLines: 1,
                              '${widget.plot.bath} Baths',
                              style: const TextStyle(),
                            ),
                          ],
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Type',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.plot.paymentType)
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Type',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.plot.type),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: ThemeColor.blue),
                          onPressed: () async {
                            final Uri smsUri = Uri.parse('smsto:${widget.plot.phone}');
                            try {
                              await launchUrl(smsUri);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.message_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                'SMS',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: ThemeColor.blue),
                          onPressed: () async {
                            final Uri smsUri = Uri.parse('tel:${widget.plot.phone}');
                            try {
                              await launchUrl(smsUri);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: const Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                'CALL',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        'Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 27), child: Text(widget.plot.description)),
                ],
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
