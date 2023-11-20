import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:testapp/Providers/NotificationCounterProvider.dart';
import 'package:testapp/global.dart'; // Import your NotificationCounterProvider

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
    }); // Call the function to fetch notifications and update the count
    resetNotificationCount();
    updateAllIsReadStatus(true);
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
        stream: _firestore
            .collection('notifications')
            .limit(30)
            .orderBy('time', descending: true)
            .snapshots(),
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
      return documentDate.isAfter(currentDate.subtract(Duration(days: 1)));
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
      return documentDate.isBefore(currentDate.subtract(Duration(days: 1)));
    }).toList();
  }

  // DateTime _parseTime(String timeString) {
  //   DateFormat format = DateFormat.jm();
  //   try {
  //     return format.parse(timeString);
  //   } catch (e) {
  //     // Handle the exception, e.g., return the current time
  //     print('Error parsing time: $e');
  //     return DateTime.now();
  //   }
  // }

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
    print("notification_count=${notification_count}");
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
                    // Your existing onTap logic...
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
