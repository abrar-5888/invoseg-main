// ignore_for_file: deprecated_member_use

import 'package:com.invoseg.innovation/main_app/app/Modules/medical/medical_controller.dart';
import 'package:com.invoseg.innovation/main_app/app/Modules/prescription/prescription.dart';
import 'package:com.invoseg.innovation/main_app/app/data/Models/medicalModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Medical extends StatefulWidget {
  const Medical({super.key});

  @override
  State<Medical> createState() => _MedicalState();
}

class _MedicalState extends State<Medical> {
  MedicalController controller = Get.put<MedicalController>(MedicalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => controller.medicals.isNotEmpty
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: controller.medicals.length,
              itemBuilder: (BuildContext context, int index) {
                MedicalModel medical = controller.medicals[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: Colors.white,
                    shadowColor: const Color(0xffBDBDBD),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    // consultationData['DateTime'],
                                    "Meetings",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    // consultationData['DateTime'],
                                    medical.date,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(color: const Color.fromRGBO(15, 39, 127, 1), borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    // consultationData['DateTime'],
                                    medical.meetingStatus,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              // You can display status here
                              // using consultationData['Status']
                            ],
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              medical.doctor.patientName,
                              style: const TextStyle(
                                color: Color(0xff212121),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                medical.doctor.patientAddress,
                                style: const TextStyle(
                                  color: Color(0xff757575),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (medical.meetingStatus.toLowerCase() == 'pending')
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (medical.doctor.meetingId.contains("meet")) {
                                          launch(medical.doctor.meetingId);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: const Text("Meeting link expired.Please request a new one"),
                                            action: SnackBarAction(label: 'ok', onPressed: () {}),
                                          ));
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100),
                                            side: const BorderSide(
                                              color: Colors.black,
                                              width: 0.0,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all(
                                          const Color.fromRGBO(15, 39, 127, 1),
                                        ),
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(horizontal: 20),
                                        ),
                                      ),
                                      child: const Text(
                                        'Start Meeting',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => Prescription(medical: medical));
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(100),
                                          side: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(
                                        const Color.fromRGBO(15, 39, 127, 1),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: 20),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Prescription',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No medical consultation available"),
            ),
    ));
  }
}
