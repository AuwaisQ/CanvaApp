import 'package:canvas_365/others/BottomBar.dart';
import 'package:canvas_365/pages/LanguageSelect.dart';
import 'package:canvas_365/pages/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? isLogin;
final configuration = PurchasesConfiguration('appl_LKGzIkEmvuKfcvXIGYgeuerIxNg');

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: "it is description", // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await Purchases.configure(configuration);
  final prefs = await SharedPreferences.getInstance();
  isLogin = prefs.getBool("isLogin");
  prefs.setBool("isFirstTime", true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
      MaterialApp(
        home:isLogin == true ? BottomBar() : Login(),
        debugShowCheckedModeBanner: false,
      )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LanguageSelect(
          from: "account",
        ) //Login(),
        );
  }
}
