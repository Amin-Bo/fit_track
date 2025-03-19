import 'package:firebase_core/firebase_core.dart';
import 'package:fit_track/authScreens/LoginScreen.dart';
import 'package:fit_track/authScreens/RegisterScreen.dart';
import 'package:fit_track/firebase_options.dart';
import 'package:fit_track/provider/FavoritesProvide.dart';
import 'package:fit_track/provider/FilterProvider.dart';
import 'package:fit_track/provider/UserProvider.dart';
import 'package:fit_track/userScreens/ExerciseDetailScreen.dart';
import 'package:fit_track/userScreens/HomeScreen.dart';
import 'package:fit_track/userScreens/NavigatorScreen.dart';
import 'package:fit_track/userScreens/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseSearchProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/profile': (context) => UserProfile(),
          '/MainHomeScreen': (context) => NavigatorScreen(),
        },
      ),
    );
  }
}
