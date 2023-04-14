// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hci_project/Screens/MainMenu.dart';

import 'constants.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:page_transition/page_transition.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


//void main() => runApp(MyApp());
Future<void> main() async {
  //NOTIFICATIONS
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS= IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async{});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if(payload!=null){
          debugPrint('notification payload: '+ payload);
        }
      });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            backgroundColor: kBackgroundColour,
            splash: Image.asset('assets/Images/task-ly.png'),
            nextScreen: taskManager(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.topToBottom,
        )
    );
  }
}

class taskManager extends StatelessWidget {

 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kBackgroundColour,
        scaffoldBackgroundColor: kBackgroundColour,
        platform: TargetPlatform.iOS,
      ),
      home: MainMenu(),
    );
  }
}


class Hello extends StatefulWidget {
  const Hello({Key key}) : super(key: key);

  @override
  State<Hello> createState() => _HelloState();
}

class _HelloState extends State<Hello> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Hii",style: TextStyle(color: Colors.white),)),);
  }
}