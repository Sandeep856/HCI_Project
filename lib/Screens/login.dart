// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:hci_project/Screens/LandingPage.dart';
import 'package:hci_project/Screens/register.dart';

class LoginPage extends StatefulWidget {
  //final VoidCallback showRegisterPage;
  const LoginPage({Key? key,}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text conterollers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String?> LoginState() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword( 
      email: _emailController.text.trim().toLowerCase(),
      password: _passwordController.text.trim(),);
      return null;
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that Email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong Password';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
  void _Login() async {

    String? _userLoggedIn = await LoginState();
    if (_userLoggedIn != null) {
      _alertDialogBuilder(_userLoggedIn);
    } else {
      LandingPage();
    }
  }
  //sign in function
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
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Close Dialog Box'),
              ),
            ],
          );
        });
  }


  //memory management
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/Images/background.jpg",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Center(
            child: Column(
              //bu wrap yazı yazmak istedğimizde klavye çıakrken ekran bozulmasınd iye
              children: [
                SizedBox(height: 20,),
                Text('TASK.LY',
                  style: TextStyle(
                      fontFamily: "Bebas",
                      fontSize: 30,
                      letterSpacing: 5,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,)),

              // LOGIN - email

              SizedBox(height: 380),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(17)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // LOGIN - Password

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(17)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // LOGIN - SIGNIN

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: _Login,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 18, bottom: 18, right: 40, left: 55),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 33, 71, 102),
                          borderRadius: BorderRadius.circular(17)),
                      child: Center(
                          child: Text('Sign In',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15))),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Account()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 18, bottom: 18, right: 40, left: 55),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 33, 71, 102),
                          borderRadius: BorderRadius.circular(17)),
                      child: Center(
                          child: Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15))),
                    ),
                  ),
                  
                ],
              ),]
            ),
          ))),
    );
  }
}
