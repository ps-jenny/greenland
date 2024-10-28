import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import the Firebase Core package
import 'package:greenland/HomePage.dart';
import 'WelcomePage.dart';
import './firebase_options.dart';


void main() async {
  // Initialize Firebase before runApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: WelcomePage(),
    );
  }
}
