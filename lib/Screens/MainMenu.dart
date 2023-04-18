
import 'package:flutter/material.dart';




import 'package:animations/animations.dart';


import 'package:hci_project/Screens/Calendar.dart';
import 'package:hci_project/Screens/Fit.dart';
import 'package:hci_project/Screens/Notes.dart';
import 'package:hci_project/Screens/Pomodoro.dart';
import 'package:hci_project/constants.dart';


class MainMenu extends StatefulWidget {
    MainMenu({this.pageIndex1});
  int? pageIndex1;
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int pageIndex = 1;
  List<Widget> pagelist = <Widget>[
    //Home(),
    //dashboard(),
    MyHomePage(title: '',),
    Notes(),
    Calendar(),
    Pomodoro(),
  ];

  

  // TODO: Add _isBannerAdReady
  //bool _isBannerAdReady = false;

  @override
  void initState() {
    // TODO: Initialize _bannerAd
    
    

    
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
        child: pagelist[pageIndex],
      ),//pagelist[pageIndex],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          //unselectedFontSize: 10,
          //selectedFontSize: 12,
          fixedColor: kActiveNavbarIconColour,
          backgroundColor: kBottomNavBarColour,
          currentIndex: pageIndex,
          onTap: (value){
            setState(() {
              pageIndex = value;
            });

          },
          type: BottomNavigationBarType.fixed,
          items: [
            //BottomNavigationBarItem(icon: Icon(mainmenu.icon,), label: 'Main Menu'),
            BottomNavigationBarItem(icon: Icon(Icons.heat_pump_rounded),label: 'Fit'),
            BottomNavigationBarItem(icon: Icon(notesmenu.icon,), label: 'Notes'),
            BottomNavigationBarItem(icon: Icon(calendar.icon,), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(pomodoro.icon,), label: 'Pomodoro'),
            
          ],
        ),
      ),
    );
  }

}


