//Bu dosya sadece redirect içindir. Arayüzü yoktur.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/Screens/MainMenu.dart';
import 'package:hci_project/Screens/Onboarding.dart';
import 'package:hci_project/Screens/auth.dart';
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
           
            final uid = FirebaseAuth.instance.currentUser?.uid;

            final CollectionReference users =
              FirebaseFirestore.instance.collection('Users');

            final snapshot = users.doc(uid).get();
            snapshot.then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                print("Hello Sandeep");
                print('Document exists on the database');
                // CircularProgressIndicator(
                //   color: Colors.blue,
                //   strokeWidth: 2,
                //   valueColor:Colors.blue as Animation<Color>,
                // );
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MainMenu()));
              } else {
                print('Document doesn\'t exist');

                Navigator.push(context, MaterialPageRoute(builder: (context)=>OnboardingScreen()));
                // return OnboardingScreen(auth: widget.auth);
              }
              
            });

            return OnboardingScreen();
          } else {
            return AuthPage(); //giriş yapılı değilse logine at
          }
        },
      ),
    );
  }
}
