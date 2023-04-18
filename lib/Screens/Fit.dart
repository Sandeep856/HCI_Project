import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
Random rand = Random();


List<double> secondsToHoursAndMinutes(double convert) {
  List<double> values = [];
  double hours = (convert / 60.0).floor() * 1.0;
  double minutes = convert - hours * 60;
  values.add(hours);
  values.add(minutes);

  return values;
}

final GlobalKey<_MyHomePageState> _homePageKey = GlobalKey<_MyHomePageState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey _statsKey = GlobalKey();

class MyHomePage extends StatefulWidget {
   MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  late Pedometer _pedometer;
  double calories = 1;
  double activeTimeInSeconds = 0;
  double _points=10;
  int stepCount = rand.nextInt(2500) + 5000;
  int _steps=100;
  int goalSteps = 100000;
  late StreamSubscription<int>? _subscription;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  double distance = 0;
  bool _isStoringData = false;
  bool _isResettingSteps = false;

  late Timer _timer;
  late DateTime _endOfDay;
  
  get error => null;
 
  @override
   void initState() {
    super.initState();
    initPlatformState();
    _startTimer();
  }

   void _startTimer() {
    DateTime now = DateTime.now();
    _endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    Duration duration = _endOfDay.difference(now);
    _timer = Timer(duration, _onTimerFinished);
  }

   void _onTimerFinished() {
    _resetSteps();
    _startTimer();
  }
  
  void _resetSteps() {
    if (!_isResettingSteps) {
      _isResettingSteps = true;
      //_pedometer.
      setState(() {
        //  _pedometerValue = 0;
      });
      _isResettingSteps = false;
    }
  }


  Future<void> _storeData() async {
    if (_endOfDay == null) {
      return;
    }
    DateTime now = DateTime.now();
    if (now.isAfter(_endOfDay)) {
      CollectionReference pedometerData =
          FirebaseFirestore.instance.collection('pedometerData');
      await pedometerData.add({
        'value': _steps,
        'timestamp': now,
      });
      _resetSteps();
    }
  }


  void onStepCount(StepCount event) async {
    /// Handle step count changed
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int newValue = event.steps.toInt();
    _steps = newValue;
     prefs.setInt('pedometerValue', newValue);
    setState(() {
      _steps = newValue;
      calories=_steps*0.05;
      distance =_steps/10000;
      _points=_steps/100;
      DateTime timeStamp = event.timeStamp;
    });
   
  }
  final String uid=FirebaseAuth.instance.currentUser!.uid;


  void _loadSavedValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _steps = prefs.getInt('pedometerValue') ?? 0;
    });
  }
   
    void _resetValueAtMidnight() {
    Timer.periodic(Duration(days: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.hour == 0 && now.minute == 0 && now.second == 0) {
        SharedPreferences.getInstance().then((prefs) {
          prefs.setInt('pedometerValue', 0);
          setState(() {
            _steps = 0;
          });
        });
      }
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available' as int;
    });
  }


  void change(){
    setState(() {
      _pedometer = new Pedometer();
      _steps = '?'as int;
    },);
  }


 Future<void> initPlatformState() async {
    /// Init streams
    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    _stepCountStream = await Pedometer.stepCountStream;

    /// Listen to streams and handle errors
    _stepCountStream.listen(onStepCount,onDone:_onDone, ).onError(onStepCountError);
  }
  

   void _onDone() async {
    // Get the current date in the user's timezone
    final now = tz.TZDateTime.now(tz.local);
    final today = tz.TZDateTime(tz.local, now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    // Save step count to Firestore at midnight
    await Future.delayed(tomorrow.difference(now));
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('steps count').add({
      'count': _steps,
      'points': _points,
      'calories': calories,
      'distance':distance,
      'date': Timestamp.now(),
    });
    setState(() {
      _steps= 0;
      _points=0;
      distance=0;
      calories=0;
    });
    initPlatformState();
  }

  
  
 @override
  Widget build(BuildContext context) {
    double circularThingySize = min(MediaQuery.of(context).size.width, 320);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
          leading: Container(
            width: 200,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu_outlined,
                      color: Colors.grey,
                    )),
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            Center(
              child: FittedBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    StatsDisplay(
                        key: _statsKey,
                        topText: "Calories",
                        bottomText: "{0}",
                        values: [calories],
                        color: Colors.orangeAccent,
                        delay: const Duration(milliseconds: 700), decimalDigits: 1,),
                    StatsDisplay(
                      topText: "Points",
                      bottomText: "{0}",
                      values: [_points],
                      color: Colors.blue,
                      delay: const Duration(milliseconds: 1100), decimalDigits: 1,
                    ),
                    StatsDisplay(
                      topText: "Distance",
                      bottomText: "{0} km",
                      values: [distance],
                      color: Colors.green,
                      decimalDigits: 1,
                      delay: const Duration(milliseconds: 1500),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),

            StepCounterRadial(
                stepCount: _steps,
                maxSteps: goalSteps,
                circularThingySize: circularThingySize,
                delay: const Duration(milliseconds: 4000),
                strokeSize: 20),

            SizedBox(height: 20,),
            Row(
              children: [Padding(
                padding: EdgeInsets.fromLTRB(300,40,0,0,),
                child: FloatingActionButton(
                  child:Icon(Icons.add,size: 40,),

                  onPressed:(){
                    
                  },)
              ),
              ]
            )
          ],
        ),

        
      ),
   
    );
  }
}


class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 72,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.black12),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              "Step Counter",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.refresh),
                title: Text("Randomize Values"),
                onTap: () {
                  _homePageKey.currentState?.setState(() {
                    _homePageKey.currentState?.calories =
                        rand.nextInt(1000) * 1.0;
                    _homePageKey.currentState?.activeTimeInSeconds =
                        rand.nextInt(1000) * 1.0;
                    _homePageKey.currentState?.distance =
                        rand.nextInt(100) * 1.0;
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Concept App by Robi @ github.com/RobiFox",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall)),
            ),
          ),
        ],
      ),
    );
  }
}

class StatsDisplay extends StatefulWidget {
  final String topText;
  final String bottomText;
  final List<double> values;
  final Color color;
  final int decimalDigits;
  final Duration delay;

   StatsDisplay({Key? key, required this.topText, required this.bottomText, required this.values, required this.color, required this.decimalDigits, required this.delay}) : super(key: key);
  @override
  State<StatsDisplay> createState() => _StatsDisplayState();
}

class _StatsDisplayState extends State<StatsDisplay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _slideController;

  List<Animation> _animation = [];
  late Animation<Offset> _slideAnimation;

  bool displayIncreasingValue = true;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    for (int i = 0; i < widget.values.length; i++) {
      //var tempAnimation = Tween(begin: 0.0, end: widget.values[i]).animate(_controller);
      var tempAnimation = Tween<double>(begin: 0.0, end: widget.values[i])
          .animate(
          CurvedAnimation(parent: _controller, curve: Curves.decelerate));
      _controller.addListener(() {
        setState(() {});
      });
      _animation.add(tempAnimation);
    }

    _slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.4), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.ease));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        displayIncreasingValue = false;
      }
    });

    Timer(widget.delay, () {
      setState(() {
        _controller.forward();
        _slideController.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController.dispose();
    super.dispose();
  }

  String convertText(String text, List<double> values) {
    for (int i = 0; i < values.length; i++) {
      text = text.replaceAll(
          "{$i}", values[i].toStringAsFixed(widget.decimalDigits));
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    List<double> animationValues = [];

    if (displayIncreasingValue) {
      for (Animation animation in _animation) {
        animationValues.add(animation.value);
      }
    }

    return Container(
      width: 148,
      child: Column(
        children: [
          Text(widget.topText,
              style: Theme.of(context).textTheme.headlineSmall),
          SlideTransition(
            position: _slideAnimation,
            child: FadingWidget(
              duration: const Duration(milliseconds: 250),
              delay: widget.delay,
              child: Text(
                  convertText(widget.bottomText,
                      displayIncreasingValue ? animationValues : widget.values),
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: widget.color)),
            ),
          )
        ],
      ),
    );
  }
}

class StepCounterRadial extends StatefulWidget {
  final int stepCount;
  final int maxSteps;
  final double circularThingySize;
  final Duration delay;
  final double strokeSize;

  const StepCounterRadial({Key? key,
    required this.stepCount,
    required this.maxSteps,
    required this.circularThingySize,
    required this.strokeSize,
    this.delay = const Duration()})
      : super(key: key);

  @override
  State<StepCounterRadial> createState() => _StepCounterRadialState();
}

class _StepCounterRadialState extends State<StepCounterRadial>
    with TickerProviderStateMixin {
  late AnimationController _appearController;
  late AnimationController _fillController;

  late Animation<double> _strokeSize;
  late Animation<double> _fillAnimation;

  bool canShow = false;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fillController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _strokeSize = Tween<double>(begin: 0, end: widget.strokeSize).animate(CurvedAnimation(parent: _appearController, curve: Curves.easeOut));
    _fillAnimation = Tween<double>(begin: 0, end: widget.stepCount / widget.maxSteps).animate(CurvedAnimation(parent: _fillController, curve: Curves.easeOutExpo));

    _appearController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        _fillController.forward();
      }
    });

    _fillController.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        finished = true;
      }
    });

    _appearController.addListener(() {setState(() {});});
    _fillController.addListener(() {setState(() {});});

    Timer(widget.delay, () {
      setState(() {
        _appearController.forward();
        canShow = true;
      });
    });
  }

  @override
  void dispose() {
    _appearController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.circularThingySize,
      height: widget.circularThingySize,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(fit: StackFit.passthrough, children: [
          Container(
              child: canShow ? CircularProgressIndicator(
                backgroundColor: Colors.black12,
                color: Colors.redAccent,
                value: finished ? widget.stepCount / widget.maxSteps :_fillAnimation.value,
                strokeWidth: _strokeSize.value,
              ) : Container()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadingWidget(
                  duration: const Duration(milliseconds: 500),
                  delay: widget.delay,
                  child: Column(
                    children: [
                      Text(
                        "${widget.stepCount} / ${widget.maxSteps}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium,
                      ),
                      Text("Steps", style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge),
                      Text("of goal",
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelLarge),
                    ],
                  )
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class FadingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool beginByDefault;
  final Duration delay;
  const FadingWidget({Key? key, required this.child, required this.duration, this.delay = const Duration(), this.beginByDefault = true}) : super(key: key);

  @override
  State<FadingWidget> createState() => _FadingWidgetState();
}

class _FadingWidgetState extends State<FadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tween;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _tween = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    Timer(widget.delay, () {
      setState(() {
        _controller.forward();
      });
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(opacity: _tween.value, duration: widget.duration, child: widget.child);
  }
}

