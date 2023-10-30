import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testapp/Models/firebase_api.dart';
import 'package:testapp/Screens/AddFamilyMembers.dart';
import 'package:testapp/Screens/Complaint.dart';
import 'package:testapp/Screens/Dashboard.dart';
import 'package:testapp/Screens/E-Reciept.dart';
import 'package:testapp/Screens/History.dart';
import 'package:testapp/Screens/LoginPage.dart';
import 'package:testapp/Screens/Notifications.dart';
import 'package:testapp/Screens/Prescription.dart';
import 'package:testapp/Screens/Profile.dart';
import 'package:testapp/Screens/RequestLogin.dart';
import 'package:testapp/Screens/Tab.dart';

// Step 1
import 'package:flutter/services.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // Step 2
  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  // runApp(MyApp());
}
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

class MyApp extends StatefulWidget {
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
  }

  @override
  Widget build(BuildContext context) {
    // print("Will Scope = ${_showExitConfirmationDialog(context)}");
    if (_error) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: AlertDialog(
            content: Text('Something went wrong. Please restart the app.'),
          ),
        ),
      );
    }
    if (!_initialized) {
      return MaterialApp(
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
              return snapshot.data.containsKey("token")
                  ? snapshot.data.getBool("token")
                      ? TabsScreen(
                          index: 0,
                        )
                      : LoginScreen()
                  : LoginScreen();
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
      routes: {
        LoginScreen.routename: (ctx) => LoginScreen(),
        requestLoginPage.route: (ctx) => requestLoginPage(),
        Home.routeName: (ctx) => Home(),
        UserProfile.routename: (ctx) => UserProfile(),
        ButtonsHistory.routename: (ctx) => ButtonsHistory(),
        ViewEReciept.routename: (ctx) => ViewEReciept(
              value: true,
              id: "",
              status: "",
            ),
        Prescription.routename: (ctx) => Prescription(
              id: "",
            ),
        FamilyMembers.routename: (ctx) => FamilyMembers(
              id: "",
            ),
        Complainform.routename: (ctx) => Complainform(),
        '/notification': (ctx) => Notifications()
      },
    );
  }
}
