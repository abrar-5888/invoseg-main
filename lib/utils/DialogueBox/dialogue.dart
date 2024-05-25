import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.invoseg.innovation/config/themes/themes%20color/colors.dart';
import 'package:com.invoseg.innovation/generated/assets.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        content: SizedBox(
          width: Get.width / 3,
          child: Stack(
            children: [
              Positioned(
                  top: 4,
                  left: 2.5,
                  child: Image.asset(
                    Assets.imagesTransparentLogo,
                    width: 30,
                    height: 30,
                  )),
              const CircularProgressIndicator.adaptive(
                  backgroundColor: ThemeColor.blue,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              const SizedBox(
                width: 10,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 60, top: 8),
                  child: const Text(
                    'Please Wait...',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
