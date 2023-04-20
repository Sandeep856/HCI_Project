import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage{
    static Future<int>  checkUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final CollectionReference users =
        FirebaseFirestore.instance.collection('Users');

    final snapshot = users.doc(uid).get();
    await snapshot.then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        return 0;
      } else {
        print('Document doesn\'t exist');

        return 1;
        // return OnboardingScreen(auth: widget.auth);
      }
    });

    return -1;
  }
}