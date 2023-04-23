import 'package:flutter/material.dart';
import 'package:hci_project/Widgets/reusable_card_task_display.dart';
import 'package:hci_project/constants.dart';




class Home extends StatefulWidget {

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

 
  // TODO: Add _isBannerAdReady
  //bool _isBannerAdReady = false;

  int work = 25;
  int shortBreak = 5;
  int longBreak = 15;
  int rounds = 4;



  @override
  void initState() {
    // TODO: Initialize _bannerAd
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 212, 143, 255),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Main Menu',
          style: kTitleTextStyle,
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCardTaskDisplay(
                        colour: kActiveCardColour2,
                        cardChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('data'),
                        ),
                        onPress: () {}),
                  ),
                  Expanded(
                    child: ReusableCardTaskDisplay(
                        colour: kActiveCardColour2,
                        cardChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('data'),
                        ),
                        onPress: () {}),
                  ),
                ],
              ),
              ReusableCardTaskDisplay(
                  colour: Color.fromRGBO(29, 132, 29, 1.0),
                  cardChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('data'),
                  ),
                  onPress: () {}),
              
            ],
          ),
        ),
      ),
    );
  }
}
