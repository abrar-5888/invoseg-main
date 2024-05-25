import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/config/themes/themes%20color/colors.dart';

class ResidentId extends StatefulWidget {
  const ResidentId({super.key});

  @override
  State<ResidentId> createState() => _ResidentIdState();
}

class _ResidentIdState extends State<ResidentId> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          onPressed: () {},
          child: const Text(
            'Generate my resident Id',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
