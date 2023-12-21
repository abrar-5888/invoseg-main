import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.invoseg.innovation/global.dart'; // Import your NotificationCounterProvider
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Visitors extends StatefulWidget {
  const Visitors({super.key});

  @override
  _VisitorsState createState() => _VisitorsState();
}

class _VisitorsState extends State<Visitors> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      notification_count = 0;
    });
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
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        var data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          notiImage = data['photo'];
          notiName = data['firstName'];
          notiPurpose = data['purpose'];
          notiVehicle = data['vehicleNo'];
        });
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
          'Visitors',
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
            .where('description', whereIn: [
              "You Have approved your freinds / relative identity",
              "You Have rejected a Person",
            ])
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('pressedTime', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('No Visitors available'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Visitor available'),
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
                          (des.toString().contains("Person"))) {
                        await fetchNotiInfo(ids);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 3.1,
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
                              ),
                            );
                          },
                        );
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
          );
        },
      ),
    );
  }
}
