import 'package:flutter/material.dart';
import "package:firebase_messaging/firebase_messaging.dart";

class FirebaseAPI {
  //// instance
  final _firebaseMessaging = FirebaseMessaging.instance;

  /// initialize notofications
  Future<void> initializeNotification() async {
    // request permission from user
    await _firebaseMessaging.requestPermission();

    //fetch device token
    final fCMToken = await _firebaseMessaging.getToken();

    //print token/ send to server
    debugPrint("Token: $fCMToken");
  }

  /// handle received messages

  /// innitialize foreground settings & background settings
}
