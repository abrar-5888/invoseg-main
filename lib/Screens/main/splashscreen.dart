import 'package:com.invoseg.innovation/Screens/main/LoginPage.dart';
import 'package:com.invoseg.innovation/Screens/main/Tab.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      checkUser().then((isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                isLoggedIn ? TabsScreen(index: 0) : const LoginScreen(),
          ),
        );
      });
    });
  }

  Future<bool> checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey("token") ? prefs.getBool("token") ?? false : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 270,
                width: 270,
                child: Image.asset("assets/Images/izmir.jpg"),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Powered By",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset("assets/Images/TransparentLogo.png"),
          ),
          const Text(
            "INVOSEG",
            style: TextStyle(shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                color: Colors.black,
              ),
            ], fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          )
        ],
      ),
    );
  }
}
