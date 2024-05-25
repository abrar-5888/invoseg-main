import 'package:get/get.dart';
import 'package:flutter/material.dart';
// ignore_for_file: file_names


class Confirm extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  const Confirm({super.key, required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      content: SizedBox(
          width: Get.width / 1,
          height: Get.height / 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8),
                child: Text(
                  'Confirmation',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Are you sure? You want to send $name request.'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: onPressed,
                      child: const Text('Yes', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('No', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
