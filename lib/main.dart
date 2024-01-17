import 'package:com.invoseg.innovation/Models/firebase_api.dart';
import 'package:com.invoseg.innovation/Screens/main/AddFamilyMembers.dart';
import 'package:com.invoseg.innovation/Screens/main/Complaint.dart';
import 'package:com.invoseg.innovation/Screens/main/E-Reciept.dart';
import 'package:com.invoseg.innovation/Screens/main/History.dart';
import 'package:com.invoseg.innovation/Screens/main/LoginPage.dart';
import 'package:com.invoseg.innovation/Screens/main/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/main/Prescription.dart';
import 'package:com.invoseg.innovation/Screens/main/Profile.dart';
import 'package:com.invoseg.innovation/Screens/main/RequestLogin.dart';
import 'package:com.invoseg.innovation/Screens/main/Tab.dart';
import 'package:com.invoseg.innovation/Screens/main/splashscreen.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp(
          name: 'Usman',
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCiHb1GzSeC19Qz3kSuL1i6o7M9soXSxmk',
              appId: '1:301480140457:android:e7ddae384174ac69c613b8',
              messagingSenderId: '301480140457',
              projectId: 'usman-a51d1')); // Initialize the default app

      print('1');

      await Firebase.initializeApp(
        name: 'CMS-All',
        options: const FirebaseOptions(
          appId: '1:338409219512:android:5000fb6deab76f80ac9b4d',
          apiKey: 'AIzaSyD23Kr8eJoeJIPMGGnsDNuoahHuRBNyQMs',
          messagingSenderId: '338409219512',
          projectId: 'cms-all',
        ),
      );

      print("Firebase initialization successful");

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      await FirebaseApi().inNotify();
      await NamedFirebaseMessaging(secondApp).main1();

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print("ERROR: $e");
      setState(() {
        _error = true;
      });
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: $message");
    // Handle the background message here
  }

  @override
  void initState() {
    super.initState();

    initializeFlutterFire();
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
        home: Scaffold(
          body: AlertDialog(
            content:
                Text('Something went wrong. Please restart the app.$_error'),
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
      title: 'Invoseg Izmir',
      theme: ThemeData(
        fontFamily: 'Urbanist',
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
      routes: {
        LoginScreen.routename: (ctx) => const LoginScreen(),
        requestLoginPage.route: (ctx) => const requestLoginPage(),
        // Home.routeName: (ctx) => const Home(),
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
        // Complainform.routename: (ctx) => const Complainform(),
        '/notification': (ctx) => const Notifications(),
        '/complaint': (ctx) => const Complainform(),
        '/tabsScreen': (ctx) => TabsScreen(index: 0)
      },
    );
  }
}
