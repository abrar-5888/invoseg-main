import 'package:com.invoseg.innovation/Providers/medicalProvider.dart';
import 'package:flutter/material.dart';

class MedicalAlertBox extends StatelessWidget {
  final MedicalProvider medicalProvider;
  const MedicalAlertBox({super.key, required this.medicalProvider});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Center(
            child: AnimatedContainer(
                height: MediaQuery.of(context).size.height / 2,
                duration: const Duration(milliseconds: 300),
                //
                child: medicalProvider.showMedBox == true
                    ? AlertDialog.adaptive(
                        content: const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 12),
                              child: Text('Link Generated',style: TextStyle(fontSize: 20),),
                            ),

                          ],
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                onPressed: () {},
                                child: const Text(
                                  'Start Meeting',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                onPressed: () {
                                  medicalProvider.changeShowMedBox(false);
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink())));
  }
}
