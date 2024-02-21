import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/Providers/visitorProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class visitorAlertBox extends StatelessWidget {
  const visitorAlertBox({
    super.key,
    required this.visitorProvider,
  });

  final VisitorProvider visitorProvider;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: visitorProvider.showVisitorDialog == true
            ? AlertDialog(
                title: SizedBox(
                  height: MediaQuery.of(context).size.height / 3.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Colors.grey,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(visitorProvider.notiImage),
                          radius: 52,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Name : ${visitorProvider.notiName}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Purpose : ${visitorProvider.notiPurpose} ',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Vehicle No & type : ${visitorProvider.notiVehicle}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                content: const Text('Please confirm identity of your visitor'),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () async {
                          DateTime dateTime = DateTime.now();
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(dateTime);
                          print(visitorProvider.id);

                          String formattedTime =
                              DateFormat('h:mm:ss a').format(dateTime);
                          print(formattedTime);
                          String description =
                              "You Have approved your freinds / relative identity";

                          await FirebaseFirestore.instance
                              .collection('entryUser')
                              .doc(visitorProvider.id)
                              .update({
                            'status': 'Approved',
                            'date': formattedDate,
                            'time': formattedTime
                          });
                          await FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(visitorProvider.notiDocId)
                              .update({'description': description}).then(
                                  (value) {
                            visitorProvider.showVisitorDialogs(false);
                          });

                          // Navigator.pop(context);
                        },
                        child: const Text('confirm',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () async {
                          DateTime dateTime = DateTime.now();
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(dateTime);
                          print(visitorProvider.id);

                          String formattedTime =
                              DateFormat('h:mm:ss a').format(dateTime);
                          print(formattedTime);
                          String description = "You Have rejected a Person";

                          await FirebaseFirestore.instance
                              .collection('entryUser')
                              .doc(visitorProvider.id)
                              .update({
                            'status': 'Rejected',
                            'date': formattedDate,
                            'time': formattedTime
                          });
                          await FirebaseFirestore.instance
                              .collection('notifications')
                              .doc(visitorProvider.notiDocId)
                              .update({'description': description});

                          // Navigator.pop(context);
                          visitorProvider.showVisitorDialogs(false);
                        },
                        child: const Text('reject',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              )
            : null,
      ),
    ));
  }
}
