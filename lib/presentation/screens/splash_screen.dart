
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:megaholod_client/presentation/auth/login_screen.dart';
import 'package:megaholod_client/presentation/auth/name_screen.dart';
import 'package:megaholod_client/presentation/main/main_screen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      initStart();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{ return false; },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void initStart() {
    Firebase.initializeApp().then((value){
      if(FirebaseAuth.instance.currentUser==null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }else{
        toStart();
      }
    });
  }
  void toStart() {
    if (FirebaseAuth.instance.currentUser?.displayName == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NameScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }
}