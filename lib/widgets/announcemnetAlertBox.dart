import 'package:com.invoseg.innovation/Providers/announcementProvider.dart';
import 'package:flutter/material.dart';

class AnnouncementAlertBox extends StatelessWidget {
  const AnnouncementAlertBox({Key? key, required this.announceMentProvider})
      : super(key: key);
  final AnnouncementProvider announceMentProvider;
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: announceMentProvider.showAnnouncementDialog == true
            ? AlertDialog(
                title: SizedBox(
                  height: MediaQuery.of(context).size.height / 3.1,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          announceMentProvider.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${announceMentProvider.description} ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
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
                          // Navigator.pop(context);
                        },
                        child: const Text('Ok',
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
