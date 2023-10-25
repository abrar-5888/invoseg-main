import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Health extends StatefulWidget {
  const Health({super.key});

  @override
  State<Health> createState() => _HealthState();
}

class _HealthState extends State<Health> {
   final List<String> listPics = [
    'assets/Images/d2.jpg','assets/Images/d1.jpg',
    
    'assets/Images/ripha.jpg',
    'assets/Images/gym.jpg',
    'assets/Images/d3.jpg',
    'assets/Images/amessa.jpg',
  ]; final List<String> listlogo = [
    'assets/Images/l1.jpg',
    'assets/Images/l2.jpg',
    
    'assets/Images/l3.jpg',
    'assets/Images/l1.jpg',
    'assets/Images/l1.jpg','assets/Images/l1.jpg',

  ];
     final List<String> destext = [
      'outlet open','outlet open','Thokar Campus','outlet open','outlet open','outlet open'
      ];
  final List<String> titletext = [
    'Indigo Rooms','Hafsaz',
    
    'Riphah International College',
    'Indigo Gym',
    'The Skye',
    'La Messa',
  ];
  final List<String> discount = [
    '20%',
    '20%',
    '50% ',
    '20%',
    '20%',
    '20%',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.25,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: listPics.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, Index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 250,
                      child: Card(
                        elevation: 10,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15))),
                        child: Column(
                          children: [
                            Container(
                              width: 400,
                              height: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage(listPics[Index]),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    
                                    width: 40,
                                    child: Image(image: AssetImage(listlogo[Index])),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(228, 211, 211, 211),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),

                              // child: ClipRect(
                              //     child: Image.asset(
                              //         "assets/Images/Invoseg.jpg"))
                            ),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15))),
                              child: ListTile(
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(titletext[Index]),
                                          ),
                                        ],
                                      ),Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            
                                          Container(
                                          // width: ,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(destext[Index],style: TextStyle(fontSize: 10,color: destext[Index] == "outlet closed" ?  
                                                                    Colors.black
                                               : Colors.white,),),),
                                    decoration: BoxDecoration(color: destext[Index] == "outlet closed" ? Colors.grey
                                             : Color
                                                                  .fromRGBO(
                                                                  15, 39, 127, 1),
                                
                                            // color: Colors.red[600],
                                            borderRadius: BorderRadius.circular(10)),
                                 ),
                                        ],
                                      ),
                                
                                    ],
                                  ),
                                ),
                                trailing: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(discount[Index],style: TextStyle(color: Colors.white),),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color
                                                            .fromRGBO(
                                                            15, 39, 127, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
