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
                duration: const Duration(milliseconds: 300),
                child: medicalProvider.showMedBox == true
                    ? AlertDialog.adaptive(
                        content: const Center(child: Text("OKA")),
                        actions: [
                          TextButton(
                              onPressed: () {
                                medicalProvider.changeShowMedBox(false);
                              },
                              child: const Text("oka"))
                        ],
                      )
                    : const SizedBox.shrink())));
  }
}
