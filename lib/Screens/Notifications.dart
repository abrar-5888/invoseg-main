import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/global.dart';
import 'Prescription.dart';
import 'Complaint.dart';
import 'Tab.dart';
import 'E-Reciept.dart';
import 'NotificationCounterProvider.dart'; // Import your NotificationCounterProvider

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      notification_count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xff212121),
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('notifications').limit(30).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error fetching data');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No notifications available'),
            );
          }

          // Use your NotificationCounterProvider to update the count
          Provider.of<NotificationCounterProvider>(context, listen: false)
              .getAllIsReadStatus();

          // Rest of your existing code...
          // ...

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

  Widget _buildSection(
    String date,
    List<QueryDocumentSnapshot> notifications,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Text(
            date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var document = notifications[index];
            var title = document['title'];
            var des = document['description'];
            var image = document['image'];
            var id = document['id'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  onTap: () {
                    if (des.toString().contains("Order")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewEReciept(
                                value: true, id: id, status: "Deliverd"),
                          ));
                    } else if (des.toString().contains("generated")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TabsScreen(index: 2),
                          ));
                    } else if (des.toString().contains("Prescription")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Prescription(id: id)));
                    } else if (des.toString().contains("complaint")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Complainform(),
                          ));
                    } else if (des.toString().contains("response")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Complainform(),
                          ));
                    } else if (des.toString().contains("home")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TabsScreen(
                              index: 0,
                            ),
                          ));
                    } else if (des.toString().contains("Updated")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TabsScreen(index: 1),
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
                    child: Icon(
                      Icons.image,
                      color: Color(0xff2824e5),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title),
                      Text(
                        "${document['date'].toString()} at ${document['time'].toString()}",
                        style: TextStyle(fontSize: 8),
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
