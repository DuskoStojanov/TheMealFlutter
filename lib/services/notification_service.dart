import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {

    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    debugPrint("FCM TOKEN: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground msg: ${message.notification?.title}");
    });
  }
}
