import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/main_app/app/Components/confirmDialog.dart';
import 'package:com.invoseg.innovation/main_app/app/Modules/home/home_controller.dart';
import 'package:com.invoseg.innovation/main_app/config/themes/themes%20color/colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonType;
  final IconData iconData;
  final String title;
  const CustomButton({super.key, required this.iconData, required this.title, required this.buttonType});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put<HomeController>(HomeController());
    return SizedBox(
      width: Get.width / 2.2,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shadowColor: Colors.black, elevation: 10, padding: const EdgeInsets.all(12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: ThemeColor.blue),
          onPressed: () {
            if (buttonType == 'button-one') {
              Get.dialog(
                Confirm(
                  onPressed: () {
                    controller.alertMe(buttonType);
                  },
                  name: 'security',
                ),
              );
            } else if (buttonType == 'button-two') {
              Get.dialog(
                Confirm(
                  onPressed: () {
                    controller.alertMe(buttonType);
                  },
                  name: 'medical',
                ),
              );
            } else if (buttonType == 'button-three') {
              Get.dialog(
                Confirm(
                  onPressed: () {
                    controller.alertMe(buttonType);
                  },
                  name: 'grocery',
                ),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: Colors.white,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
