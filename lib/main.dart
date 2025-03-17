import 'package:firebase_core/firebase_core.dart';
import 'package:fit_track/authScreens/LoginScreen.dart';
import 'package:fit_track/authScreens/RegisterScreen.dart';
import 'package:fit_track/authScreens/SplashScreen.dart';
import 'package:fit_track/firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
