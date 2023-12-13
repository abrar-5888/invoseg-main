import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testapp/Screens/main/Complaint.dart';
import 'package:testapp/Screens/main/E-Reciept.dart';
import 'package:testapp/Screens/main/Prescription.dart';
import 'package:testapp/global.dart'; // Import your NotificationCounterProvider

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
    }); // Call the function to fetch notifications and update the count
    resetNotificationCount();
    updateAllIsReadStatus(true);
  }

  String notiImage = "";
  String notiName = "";
  String notiPurpose = "";
  String notiVehicle = "";
  Future<void> fetchNotiInfo(String ids) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('entryUser')
          .where('id', isEqualTo: ids)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document in the query result
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Extract and print the data from the document
        var data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          notiImage = data['photo'];
          notiName = data['firstName'];
          notiPurpose = data['purpose'];
          notiVehicle = data['vehicleNo'];
        });

        print(notiImage);

        print('Document Data: $data');
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
            // .where('description',arrayContains: "identity")
            // .limit(30)
            // .where("uid", isEqualTo: id)
            .where('uid', isEqualTo: id)
            // .orderBy('timestamp', descending: true)
            .get(),
        builder: (context, snapshot) {
          print(id);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('No notifications available'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No notifications available'),
            );
          }

          // Extract the data from the snapshot
          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

          List<QueryDocumentSnapshot> newNotifications =
              getNewNotifications(documents);
          List<QueryDocumentSnapshot> earlierNotifications =
              getEarlierNotifications(documents);

          return ListView(
            children: [
              if (newNotifications.isNotEmpty)
                _buildSection('NEW', newNotifications),
              if (earlierNotifications.isNotEmpty)
                _buildSection('EARLIER', earlierNotifications),
            ],
          );
        },
      ),
    );
  }

  List<QueryDocumentSnapshot> getNewNotifications(
    List<QueryDocumentSnapshot> documents,
  ) {
    DateTime currentDate = DateTime.now();
    return documents.where((document) {
      String dateString = document['date'];
      String timeString = document['time'];
      DateTime documentDate = _parseTime(dateString, timeString);
      return documentDate
          .isAfter(currentDate.subtract(const Duration(days: 1)));
    }).toList();
  }

  List<QueryDocumentSnapshot> getEarlierNotifications(
    List<QueryDocumentSnapshot> documents,
  ) {
    DateTime currentDate = DateTime.now();
    return documents.where((document) {
      String dateString = document['date'];
      String timeString = document['time'];
      DateTime documentDate = _parseTime(dateString, timeString);
      return documentDate
          .isBefore(currentDate.subtract(const Duration(days: 1)));
    }).toList();
  }

  DateTime _parseTime(String dateString, String timeString) {
    try {
      String dateTimeString = '$dateString $timeString';
      DateFormat format = DateFormat('MM/dd/yyyy h:mm:ss a');
      return format.parse(dateTimeString);
    } catch (e) {
      // Handle the exception, e.g., return the current time
      print('Error parsing time: $e');
      return DateTime.now();
    }
  }

  Widget _buildSection(
    String date,
    List<QueryDocumentSnapshot> notifications,
  ) {
    print("notification_count=$notification_count");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var document = notifications[index];
            var title = document['title'];
            var des = document['description'];
            var image = document['image'];
            var ids = document['id'];
            var docid = document.id;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
                      if (des.toString().contains("approved") ||
                          des.toString().contains("rejected")) {
                        await fetchNotiInfo(ids);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3.1,
                                // child: DrawerHeader(
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
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(notiImage),
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
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
                                        // ${userinfo["email"]}'

                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                // ),
                              ),
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3.1,
                                // child: DrawerHeader(
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
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(notiImage),
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
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
                                        // ${userinfo["email"]}'

                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
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
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                // ),
                              ),
                              content: const Text(
                                'Please confirm identity of your visitor',
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  onPressed: () async {
                                    DateTime dateTime = DateTime.now();
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(dateTime);
                                    print(formattedDate);

                                    // Format time as "h:mm:ss a"
                                    String formattedTime =
                                        DateFormat('h:mm:ss a')
                                            .format(dateTime);
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
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  onPressed: () async {
                                    DateTime dateTime = DateTime.now();
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(dateTime);
                                    print(formattedDate);

                                    // Format time as "h:mm:ss a"
                                    String formattedTime =
                                        DateFormat('h:mm:ss a')
                                            .format(dateTime);
                                    print(formattedTime);
                                    String description =
                                        "You Have rejected a Person";

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
                                    // Close the confirmation dialog
                                  },
                                  child: const Text('reject',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                    if (des.isNotEmpty &&
                        des.toString().contains("Prescription")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Prescription(
                                    id: ids,
                                  )));
                    }

                    if (des.isNotEmpty && des.toString().contains("Order")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewEReciept(
                                    value: false,
                                    status: "",
                                    id: ids,
                                  )));
                    }
                    if (des.isNotEmpty &&
                        des.toString().contains("Complaint")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Complainform(),
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
                    child: const Icon(
                      Icons.image,
                      color: Color(0xff2824e5),
                    ),
                  ),
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
        ),
      ],
    );
  }
}
