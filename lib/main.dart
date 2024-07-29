import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentations/intro_screen/splash_screen.dart';
import 'package:sportsapp/data/config/firebase_api.dart';
// import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
// ignore: import_of_legacy_library_into_null_safe

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await FirebaseAPI().initializeNotification();

  // MpesaFlutterPlugin.setConsumerKey(dotenv.env['consumer_key']!);
  // MpesaFlutterPlugin.setConsumerSecret(dotenv.env['consumer_secret']!);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
