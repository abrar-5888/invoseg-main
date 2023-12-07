import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Step 1
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Models/firebase_api.dart';
import 'package:testapp/Screens/main/AddFamilyMembers.dart';
import 'package:testapp/Screens/main/Complaint.dart';
import 'package:testapp/Screens/main/Dashboard.dart';
import 'package:testapp/Screens/main/E-Reciept.dart';
import 'package:testapp/Screens/main/History.dart';
import 'package:testapp/Screens/main/LoginPage.dart';
import 'package:testapp/Screens/main/Notifications.dart';
import 'package:testapp/Screens/main/Prescription.dart';
import 'package:testapp/Screens/main/Profile.dart';
import 'package:testapp/Screens/main/RequestLogin.dart';
import 'package:testapp/global.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // Step 2
  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  // runApp(MyApp());
}
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final FirebaseMessaging _fc = FirebaseMessaging.instance;
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      await FirebaseApi().inNotify();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    //  _fc.subscribeToTopic("Events");
    getAllIsReadStatus();
    print("====================================$notification_count");
  }

  @override
  Widget build(BuildContext context) {
    // print("Will Scope = ${_showExitConfirmationDialog(context)}");
    if (_error) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: AlertDialog(
            content: Text('Something went wrong. Please restart the app.'),
          ),
        ),
      );
    }
    if (!_initialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      title: 'Notify-App',
      theme: ThemeData(
        fontFamily: 'Urbanist',
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // return snapshot.data.containsKey("token")
              //     ? snapshot.data.getBool("token")
              //         ? TabsScreen1(
              //             index: 0,
              //           )
              //         : const LoginScreen()
              //     : const LoginScreen();
              return const LoginScreen();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
      routes: {
        LoginScreen.routename: (ctx) => const LoginScreen(),
        requestLoginPage.route: (ctx) => const requestLoginPage(),
        Home.routeName: (ctx) => const Home(),
        UserProfile.routename: (ctx) => const UserProfile(),
        ButtonsHistory.routename: (ctx) => const ButtonsHistory(),
        ViewEReciept.routename: (ctx) => const ViewEReciept(
              value: true,
              id: "",
              status: "",
            ),
        Prescription.routename: (ctx) => Prescription(
              id: "",
            ),
        FamilyMembers.routename: (ctx) => FamilyMembers(
              id: "",
              emailss: "",
              ownerss: "",
              addresss: "",
            ),
        Complainform.routename: (ctx) => const Complainform(),
        '/notification': (ctx) => const Notifications()
      },
    );
  }
}
