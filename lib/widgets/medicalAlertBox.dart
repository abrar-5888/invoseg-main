import 'package:com.invoseg.innovation/Providers/medicalProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                        surfaceTintColor: Colors.white,
                        title: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("MEDICAL",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        content: const SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  'Link Generated',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  'Your meeting link has been Generated',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Consumer(builder: (context, value, child) {
                                return ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                    const Color.fromRGBO(15, 39, 127, 1),
                                  )),
                                  onPressed: () {
                                    if (medicalProvider.meetId
                                        .contains("meet")) {
                                      launch(medicalProvider.meetId);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                            "Meeting link expired.Please request a new one"),
                                        action: SnackBarAction(
                                            label: 'ok', onPressed: () {}),
                                      ));
                                    }
                                    medicalProvider.changeShowMedBox(false);
                                  },
                                  child: const Text(
                                    'Start Meeting',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }),
                              SizedBox(
                                width: 120,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                    const Color.fromRGBO(15, 39, 127, 1),
                                  )),
                                  onPressed: () {
                                    medicalProvider.changeShowMedBox(false);
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink())));
  }
}
