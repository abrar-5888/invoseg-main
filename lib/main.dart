import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:com.invoseg.innovation/Models/firebase_api.dart';
import 'package:com.invoseg.innovation/Screens/main/AddFamilyMembers.dart';
import 'package:com.invoseg.innovation/Screens/main/Complaint.dart';
import 'package:com.invoseg.innovation/Screens/main/Dashboard.dart';
import 'package:com.invoseg.innovation/Screens/main/E-Reciept.dart';
import 'package:com.invoseg.innovation/Screens/main/History.dart';
import 'package:com.invoseg.innovation/Screens/main/LoginPage.dart';
import 'package:com.invoseg.innovation/Screens/main/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/main/Prescription.dart';
import 'package:com.invoseg.innovation/Screens/main/Profile.dart';
import 'package:com.invoseg.innovation/Screens/main/RequestLogin.dart';
import 'package:com.invoseg.innovation/Screens/main/Tab.dart';
import 'package:com.invoseg.innovation/global.dart';

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
      print("1");
      await Firebase.initializeApp(
          name: 'CMS-All',
          options: const FirebaseOptions(
              appId: '1:338409219512:android:5000fb6deab76f80ac9b4d',
              apiKey: 'AIzaSyD23Kr8eJoeJIPMGGnsDNuoahHuRBNyQMs',
              messagingSenderId: '338409219512',
              projectId: 'cms-all'));
      print("Success +++++++++++++2");
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
    getLogo();
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
              return snapshot.data.containsKey("token")
                  ? snapshot.data.getBool("token")
                      ? TabsScreen(
                          index: 0,
                        )
                      : const LoginScreen()
                  : const LoginScreen();
              // return const LoginScreen();
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
