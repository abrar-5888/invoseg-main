import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/Screens/Complaint.dart';
import 'package:com.invoseg.innovation/Screens/E-Reciept.dart';
import 'package:com.invoseg.innovation/Screens/Prescription.dart';
import 'package:com.invoseg.innovation/Screens/Tab.dart';
import 'package:com.invoseg.innovation/global.dart'; // Import your NotificationCounterProvider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      notification_count = 0;
    });
    updateNoti();
    resetNotificationCount();
    updateAllIsReadStatus(true);
  }

  String notiImage = "";
  String notiName = "";
  String notiPurpose = "";
  String notiVehicle = "";
  Future<void> fetchNotiInfo(String ids) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('entryUser')
          .doc(ids)
          // .where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.data() != null) {
        // DocumentSnapshot documentSnapshot = querySnapshot.data
        var data = querySnapshot.data() as Map<String, dynamic>;

        notiImage = data['photo'];
        notiName = data['firstName'];
        notiPurpose = data['purpose'];
        notiVehicle = data['vehicleNo'];
      } else {
        print('No documents found for the specified ID.');
      }
    } catch (e) {
      print('Error fetching notification info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xff212121),
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _firestore
            .collection('notifications')
            .where('uid', isEqualTo: id)
            .orderBy('pressedTime', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('No notifications available ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No notification available'),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var document = documents[index];
              var title = document['title'];
              var des = document['description'];
              var image = document['image'];
              var ids = document['id'];
              var docid = document.id;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () async {
                      if (des.isNotEmpty &&
                          (des.toString().contains("Person") ||
                              des.toString().contains('identity'))) {
                        await fetchNotiInfo(ids);
                        if (des.toString().contains("approved") ||
                            des.toString().contains("rejected")) {
                          detailsShowDialog();
                        } else {
                          aceeptRjectDialog(ids, docid);
                        }
                      } else if (des.isNotEmpty &&
                          des.toString().contains("Prescription")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Prescription(
                                      id: ids,
                                    )));
                      } else if (des.isNotEmpty &&
                          des.toString().contains("Order")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewEReciept(
                                      value: false,
                                      status: "",
                                      id: ids,
                                    )));
                      } else if (des.isNotEmpty &&
                          des.toString().contains("Complaint")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Complainform(),
                            ));
                      } else if (des.isNotEmpty &&
                          des.toString().contains("Meet ID")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabsScreen(
                                index: 2,
                              ),
                            ));
                      } else if (des.isNotEmpty &&
                          des.toString().contains("Home")) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TabsScreen(
                                index: 0,
                              ),
                            ));
                      }
                    },
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: Container(
                        height: 100,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:
                            Image.asset('assets/Images/TransparentLogo.png')),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title),
                        Text(
                          "${document['date'].toString()} at ${document['time'].toString()}",
                          style: const TextStyle(fontSize: 8),
                        )
                      ],
                    ),
                    subtitle: Text(des, maxLines: 2),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void detailsShowDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                          blurRadius: 3, color: Colors.grey, spreadRadius: 1)
                    ],
                  ),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(notiImage),
                    radius: 52,
                    backgroundColor: Colors.white,
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  top: 10,
                )),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Name : $notiName',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  top: 5,
                )),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Purpose : $notiPurpose',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  top: 5,
                )),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Vehicle No & Type : $notiVehicle',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void aceeptRjectDialog(ids, String docid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                          blurRadius: 3, color: Colors.grey, spreadRadius: 1)
                    ],
                  ),
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(notiImage),
                    radius: 52,
                    backgroundColor: Colors.white,
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  top: 10,
                )),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Name : $notiName',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  top: 5,
                )),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Purpose : $notiPurpose ',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.only(
                  top: 5,
                )),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Vehicle No & type : $notiVehicle',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          content: const Text(
            'Please confirm identity of your visitor',
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    DateTime dateTime = DateTime.now();
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(dateTime);
                    print(formattedDate);

                    String formattedTime =
                        DateFormat('h:mm:ss a').format(dateTime);
                    print(formattedTime);
                    String description =
                        "You Have approved your freinds / relative identity";

                    await FirebaseFirestore.instance
                        .collection('entryUser')
                        .doc(ids)
                        .update({
                      'status': 'Approved',
                      'date': formattedDate,
                      'time': formattedTime
                    });
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(docid)
                        .update({'description': description});

                    Navigator.pop(context);
                  },
                  child: const Text('confirm',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () async {
                    DateTime dateTime = DateTime.now();
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(dateTime);
                    print(formattedDate);

                    String formattedTime =
                        DateFormat('h:mm:ss a').format(dateTime);
                    print(formattedTime);
                    String description = "You Have rejected a Person";

                    await FirebaseFirestore.instance
                        .collection('entryUser')
                        .doc(ids)
                        .update({
                      'status': 'Rejected',
                      'date': formattedDate,
                      'time': formattedTime
                    });
                    await FirebaseFirestore.instance
                        .collection('notifications')
                        .doc(docid)
                        .update({'description': description});

                    Navigator.pop(context);
                  },
                  child: const Text('reject',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
