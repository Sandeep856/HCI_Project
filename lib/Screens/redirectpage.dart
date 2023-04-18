//Bu dosya sadece redirect içindir. Arayüzü yoktur.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/Screens/Fit.dart';
import 'package:hci_project/Screens/MainMenu.dart';
import 'package:hci_project/Screens/auth.dart';
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);//5.54

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainMenu(); //giriş yapılıysa main page e at
          } else {
            return AuthPage(); //giriş yapılı değilse logine at
          }
        },
      ),
    );
  }
}
