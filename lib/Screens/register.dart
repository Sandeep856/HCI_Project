import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/Screens/LandingPage.dart';
import 'package:hci_project/Screens/MainMenu.dart';
import 'package:hci_project/Screens/Onboarding.dart';
import 'package:hci_project/Widgets/button.dart';
import 'package:hci_project/Widgets/custom_input.dart';

import '../constants.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool _registerFormLoading = false;
  final CollectionReference users=FirebaseFirestore.instance.collection("Users");
 
  void _submit() async {
    String? _createAccountFeedback = await createAccount();
    setState(() {
      _registerFormLoading = true;
    });
    if (_createAccountFeedback != null) {
      _alertDialogBuilder(_createAccountFeedback);

      setState(() {
        _registerFormLoading = false;
      });
    } else {
      
      Future<int> result=LandingPage.checkUser();
      if(result==0)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MainMenu()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OnboardingScreen()));
      }
    }
  }

  Future<String?> createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close Dialog Box'),
              ),
            ],
          );
        });
  }

  String _registerEmail = '';
  String _registerPassword = '';

  late FocusNode _passwordFocusNode;
  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Images/Register.jpg"),
          fit: BoxFit.fill
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Set Up your Account"),
          backgroundColor:Color.fromARGB(255, 214, 170, 255),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 120),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.end,
            children: [
         
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Input(
                    hinttext: 'Email',
                    onChanged: (value) {
                      _registerEmail = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    isPasswordField: false,
                  ),
                  Input(
                    hinttext: 'Password ',
                    onChanged: (value) {
                      _registerPassword = value;
                    },
                    onSubmitted: (value) {
                      _submit();
                    },
                    textInputAction: TextInputAction.done,
                    isPasswordField: true,
                  ),
                  SizedBox(height: 120,),
                  GestureDetector(
                    onTap: () {
                      _submit();
                      
                    },
                    child: Button(
                      loadingState: _registerFormLoading,
                      text: 'Create Account',
                      outline: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Button(
                    loadingState: false,
                    text: 'Back to Login',
                    outline: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
