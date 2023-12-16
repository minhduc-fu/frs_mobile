import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frs_mobile/services/authprovider.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
}

class FirebaseApi {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('code: $FCMToken');

    // Register the onBackgroundMessage handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


    final url = Uri.parse('http://fashionrental.online:8080/notification/register');

    int? accountID = AuthProvider.userModel?.accountID;
    print('accountid: $accountID'); // Updated this line

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accountID': accountID,
          'fcm': FCMToken,
        }),
      );
      print('Response: ${response.body}');
    } catch (e) {
      print(e);
      print('error: $e');
    }
  }
}
