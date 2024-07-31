import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentations/intro_screen/splash_screen.dart';
import 'package:sportsapp/data/config/firebase_api.dart';
import 'presentations/users/clubs/controller/clubs_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await FirebaseAPI().initializeNotification();

  // MpesaFlutterPlugin.setConsumerKey(dotenv.env['consumer_key']!);
  // MpesaFlutterPlugin.setConsumerSecret(dotenv.env['consumer_secret']!);
  //Get.lazyPut(() => ClubController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sports App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(),
    );
  }
}
