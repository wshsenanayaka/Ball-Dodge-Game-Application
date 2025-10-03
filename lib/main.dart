import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'utils/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Connectivity().onConnectivityChanged.listen((status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (status != ConnectivityResult.none && user != null) {
      await FirebaseHelper.syncScore(user.uid);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ball Dodge Game',
      theme: ThemeData.dark(),
      home: const LoginPage(),
    );
  }
}
