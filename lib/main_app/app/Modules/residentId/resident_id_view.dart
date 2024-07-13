import 'package:com.invoseg.innovation/main_app/app/Modules/residentId/residentId_controller.dart';
import 'package:com.invoseg.innovation/main_app/config/themes/themes%20color/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResidentId extends StatefulWidget {
  const ResidentId({super.key});

  @override
  State<ResidentId> createState() => _ResidentIdState();
}

class _ResidentIdState extends State<ResidentId> {
  ResidentIdController controller = Get.put(ResidentIdController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            }),
        foregroundColor: const Color(0xff212121),
        title: const Text(
          'Resident Id',
          style: TextStyle(color: Color(0xff212121), fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: ThemeColor.blue),
          onPressed: () {
            controller.fetchResidentId();
            Get.dialog(AlertDialog(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: const Text("Resident ID"),
              content: SizedBox(
                  height: 50,
                  child: Obx(
                    () => Text(
                      controller.residentId.value,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  )),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      "ok",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ))
              ],
            ));
          },
          child: const Text(
            'Generate my resident Id',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
