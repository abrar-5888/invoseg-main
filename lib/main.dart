import 'package:com.invoseg.innovation/Models/firebase_api.dart';
import 'package:com.invoseg.innovation/Providers/NotificationCounterProvider.dart';
import 'package:com.invoseg.innovation/Providers/announcementProvider.dart';
import 'package:com.invoseg.innovation/Providers/visitorProvider.dart';
import 'package:com.invoseg.innovation/Screens/AddFamilyMembers.dart';
import 'package:com.invoseg.innovation/Screens/Complaint.dart';
import 'package:com.invoseg.innovation/Screens/E-Reciept.dart';
import 'package:com.invoseg.innovation/Screens/History.dart';
import 'package:com.invoseg.innovation/Screens/LoginPage.dart';
import 'package:com.invoseg.innovation/Screens/Notifications.dart';
import 'package:com.invoseg.innovation/Screens/Prescription.dart';
import 'package:com.invoseg.innovation/Screens/Profile.dart';
import 'package:com.invoseg.innovation/Screens/RequestLogin.dart';
import 'package:com.invoseg.innovation/Screens/Tab.dart';
import 'package:com.invoseg.innovation/Screens/splashscreen.dart';
import 'package:com.invoseg.innovation/global.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      await FirebaseApi().inNotify();
      // await NamedFirebaseMessaging(secondApp).main1();

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

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: $message");
    // Handle the background message here
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<NotificationCounter>(
            create: (_) => NotificationCounter(),
          ),
          ChangeNotifierProvider<VisitorProvider>(
            create: (_) => VisitorProvider(),
          ),
          ChangeNotifierProvider<AnnouncementProvider>(
            create: (_) => AnnouncementProvider(),
          ),
        ],
        child: MaterialApp(
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
        ));
  }
}
