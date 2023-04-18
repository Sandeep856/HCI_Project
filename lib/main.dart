import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hci_project/Screens/redirectpage.dart';
import 'package:hci_project/constants.dart';


// import 'package:provider/provider.dart';
// import 'package:flutter_foreground_service/flutter_foreground_service.dart';

// import 'ZEYNEP/GoogleSign.dart';
// import 'ZEYNEP/RedirectPage.dart'; // Firebase import

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Firebase starting
  await Firebase.initializeApp(); //Firebase starting
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
 Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kBackgroundColour,
        scaffoldBackgroundColor: kBackgroundColour,
        platform: TargetPlatform.iOS,
      ),
      home: MainPage() ,
    );
  }
}

// void startForegroundService() async {
//   ForegroundService().start();
// }






