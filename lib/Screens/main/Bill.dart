import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerPage extends StatelessWidget {
  final String pdfPath; // Provide the path to your PDF file

  const PDFViewerPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'Bill Payment',
              style: TextStyle(color: Colors.black),
            )),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: pdfPath,
            enableSwipe: true, // Allow swiping between pages
            swipeHorizontal: true, // Enable horizontal swiping
            autoSpacing: false, // Automatically adjust spacing between pages
            pageSnap: true, // Snap to page boundaries
          ),
          // Add a button at the bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Workingg")));
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side:
                              const BorderSide(color: Colors.black, width: 2.0),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 20))),
                    child: const Text("Pay Bill",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
