// import 'package:flutter/material.dart';
// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

// class Explore1 extends StatefulWidget {
//   const Explore1({super.key});

//   @override
//   State<Explore1> createState() => _Explore1State();
// }

// class _Explore1State extends State<Explore1> {
//   final jitsiMeet = JitsiMeet();
//   void join() {
//     var options = JitsiMeetConferenceOptions(
//         // serverURL: 'https://meet.jit.si',
//         room: 'JitsiIsAmazing',
//         configOverrides: {
//           "startWithAudioMuted": false,
//           "startWithVideoMuted": false,
//         },
//         featureFlags: {
//           "unsaferoomwarning.enabled": false
//         });
//     jitsiMeet.join(options);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.amber,
//           title: const Text("Testing JitsiMeet")),
//       body: Center(
//         child: TextButton(
//           child: const Text(
//             "Testing Jitsi Meet ",
//             style: TextStyle(color: Colors.black),
//           ),
//           onPressed: () {
//             join();
//           },
//         ),
//       ),
//     );
//   }
// }
