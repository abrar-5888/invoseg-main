import 'package:com.invoseg.innovation/app/Modules/history/history_controller.dart';
import 'package:com.invoseg.innovation/app/data/Models/historyModel.dart';
import 'package:com.invoseg.innovation/config/themes/themes%20color/colors.dart';
import 'package:com.invoseg.innovation/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryController controller = Get.put<HistoryController>(HistoryController());
  var button1 = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   toolbarHeight: 70,
        //   leading: IconButton(
        //       icon: const Icon(
        //         Icons.arrow_back_ios_new,
        //         color: Colors.black,
        //       ),
        //       onPressed: () {
        //         Get.back();
        //       }),
        //   foregroundColor: const Color(0xff212121),
        //   title: const Text(
        //     'History',
        //     style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 23),
        //   ),
        // ),
        body: Obx(
          () => controller.histories.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.histories.length,
                  itemBuilder: (context, index) {
                    HistoryModel history = controller.histories[index];
                    String time = formatTime(history.pressedTime);
                    String date = formatDate(history.pressedTime);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          tileColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xffd9d9d9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: history.type == 'button-one'
                                  ? const Icon(
                                      Icons.security,
                                      color: ThemeColor.blue,
                                    )
                                  : const Icon(
                                      Icons.shopping_bag_rounded,
                                      color: ThemeColor.blue,
                                    )),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(history.type == 'button-one' ? 'SECURITY' : 'GROCERY'),
                            ],
                          ),
                          subtitle: Column(
                            children: [
                              Text(history.type == 'button-one' ? 'You send security request on $date at $time' : 'You sent grocery request on $date at $time', maxLines: 2),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text(
                                        date,
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        time,
                                        style: const TextStyle(fontSize: 11),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No Recents available"),
                ),
        ));
  }
}
