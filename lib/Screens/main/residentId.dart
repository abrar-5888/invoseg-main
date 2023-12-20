import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:com.invoseg.innovation/Screens/main/Tab.dart';

class ResidentID extends StatefulWidget {
  const ResidentID({super.key});

  @override
  State<ResidentID> createState() => _ResidentIDState();
}

class _ResidentIDState extends State<ResidentID> {
  String resident_id = "";
  Future<void> getResidentId() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TabsScreen(index: 0)));
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        foregroundColor: const Color(0xff212121),
        title: const Text(
          'Resident Id',
          style: TextStyle(
            color: Color(0xff212121),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
          child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(15, 39, 127, 1),
        ),
        child: const Text(
          "Generate my resident Id",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('UserRequest')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get();
          var doc = querySnapshot.docs.first;
          var data = doc.data() as Map<String, dynamic>;
          setState(() {
            resident_id = data['residentID'];
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add your custom content here
                    const Text(
                      'Resident id',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      resident_id,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Add more widgets as needed
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(15, 39, 127, 1)),
                      onPressed: () {
                        // Add functionality for the button inside the alert box
                        Navigator.of(context).pop(); // Close the alert box
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      )),
    );
  }
}
