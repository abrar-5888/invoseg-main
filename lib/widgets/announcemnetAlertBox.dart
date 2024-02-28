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
        // color: Colors.white,
        duration: const Duration(milliseconds: 300),
        child: announceMentProvider.showAnnouncementDialog == true
            ? AlertDialog(
                backgroundColor: Colors.white,
                title: Container(
                    // color: Colors.white,
                    // height: MediaQuery.of(context).size.height / 3.1,
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/Images/izmir.jpg')),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          announceMentProvider.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      announceMentProvider.description,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        announceMentProvider.date,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                )),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () async {
                          // Navigator.pop(context);
                          announceMentProvider
                              .updateAnnouncemnet(announceMentProvider.docIds);
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
