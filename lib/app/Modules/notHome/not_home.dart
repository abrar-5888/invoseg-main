import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/app/Components/confirmDialog.dart';
import 'package:com.invoseg.innovation/app/Modules/notHome/not_Home_controller.dart';

class NotHome extends StatefulWidget {
  const NotHome({super.key});

  @override
  State<NotHome> createState() => _NotHomeState();
}

class _NotHomeState extends State<NotHome> {
  NotHomeController controller = Get.put<NotHomeController>(NotHomeController());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Not Home'),
      content: SizedBox(
        height: Get.height / 2.8,
        child: Column(
          children: [
            const Text('Select the date when you will be at home'),
            const SizedBox(height: 10),
            TextFormField(
              controller: controller.currentDate,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'From',
              ),
            ),
            const SizedBox(height: 25),
            TextFormField(
              controller: controller.dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'To',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    controller.selectDate(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            controller.sendData();
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}

class NotHomeCancelRequest extends StatelessWidget {
  const NotHomeCancelRequest({super.key});

  @override
  Widget build(BuildContext context) {
    NotHomeController controller = Get.put<NotHomeController>(NotHomeController(), permanent: true);
    return Center(
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: AlertDialog(
            title: const Text('Not Home'),
            content: Column(
              children: [
                Obx(
                  () => Text('Security will look after your house for the next ${controller.days.value} days. From ${controller.from.value} to ${controller.to.value}'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 18,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(15, 39, 127, 1),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(1, 4),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: InkWell(
                        onTap: () async {
                          Get.dialog(Confirm(
                            name: 'Not Home',
                            onPressed: () {
                              Get.back();
                              controller.cancelRequest();
                            },
                          ));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Cancel my request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("back"),
              ),
            ],
          )),
    );
  }
}
