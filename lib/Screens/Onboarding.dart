import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hci_project/Screens/MainMenu.dart';

class Hostel {
  late String name;

  Hostel({required this.name});
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  int _age = 0;
  Hostel? _selectedHostel;
  DateTime? _meal1Timing;
  DateTime? _meal2Timing;
  DateTime? _meal3Timing;
  DateTime? _exerciseTiming;
  String _exercise="Yes";
  bool _exercise_status=true;
  final List<Hostel> _hostels = [    Hostel(name: 'Hostel A'),    Hostel(name: 'Hostel B'),    Hostel(name: 'Hostel C'),    Hostel(name: 'Hostel D'),    Hostel(name: 'Hostel E'),  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image:DecorationImage(image: AssetImage("assets/Images/onb.jpg"),
            fit: BoxFit.cover,
            opacity: 0.3
            ),
          ),
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to Task.ly',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  'OnboardingScreen',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: Text("Provide basic detais!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your first name',
                    labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                    labelText: 'First Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value!;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your last name',
                    labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                    labelText: 'Last Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value!;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your age',
                    labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                    labelText: 'Age',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.parse(value!);
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<Hostel>(
                  decoration: InputDecoration(
                    hintText: 'Select your hostel',
                    labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                    labelText: 'Hostel',
                  ),
                  items: _hostels.map((hostel) {
                    return DropdownMenuItem<Hostel>(
                      value: hostel,
                      child: Text(hostel.name),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your hostel';
                    }
                    return null;
                  },
                  onChanged:(value) {
                setState(() {
                  _selectedHostel = value;
                });
              },
              onSaved: (value) {
                _selectedHostel = value;
              },
              value: _selectedHostel,
            ),
            SizedBox(height: 10.0),
            Text(
              'Meal Timings',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Select breakfast timing',
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                labelText: _meal1Timing==null?"Breakfast":_meal1Timing!.hour.toString()+":"+_meal1Timing!.minute.toString(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {

                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if(selectedTime!=null)
                setState(() {
                  _meal1Timing = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              },
              validator: (value) {
                if (_meal1Timing == null) {
                  return 'Please select Breakfast timing';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Select Lunch timing',
                labelText: _meal2Timing==null?"Lunch":_meal2Timing!.hour.toString()+":"+_meal2Timing!.minute.toString(),
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if(selectedTime!=null)
                setState(() {
                  _meal2Timing = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              },
              validator: (value) {
                if (_meal2Timing == null) {
                  return 'Please select Lunch timing';
                }
                return null;
              },
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Select meal Dinner timing',
                labelText: _meal3Timing==null?"Dinner":_meal3Timing!.hour.toString()+":"+_meal3Timing!.minute.toString(),
                labelStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                TimeOfDay? selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

               if(selectedTime!=null)
                setState(() {
                  _meal3Timing = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              },
              validator: (value) {
                if (_meal3Timing == null) {
                  return 'Please select meal Dinner timing';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
           
            Align(
              alignment: Alignment.center,
              child: Text("Do you exercise?",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ), 
              ),
            ),
            RadioListTile(
              title: Text("Yes"),
              value: "Yes", 
              groupValue: _exercise, 
              onChanged:(value){
                  setState(() {
                    _exercise=value as String;
                    _exercise_status=true;
                  });
              }),
              RadioListTile(
                title: Text("No"),
                value: "No", 
                groupValue: _exercise, 
                onChanged: (value)
                {
                    setState(() {
                      _exercise=value as String;
                      _exercise_status=false;
                    });
                }),
            SizedBox(height: 10.0),
            Visibility(
              visible: _exercise_status,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Select exercise timing',
                  labelText: _exerciseTiming==null?'Exercise':_exerciseTiming!.hour.toString()+":"+_exerciseTiming!.minute.toString(),
                  suffixIcon: Icon(Icons.calendar_today),
                  
                ),
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                print(selectedTime!.hour);
                if(selectedTime!=null)
                setState(() {
                  print(selectedTime.hour.toString()+"Sandee");
                  _exerciseTiming = DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
                print(_exerciseTiming!.hour.toString());
                },
                validator: (value) {
                  if (_exerciseTiming == null) {
                    return 'Please select exercise timing';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Navigate to the home screen
                  final String uid=FirebaseAuth.instance.currentUser!.uid;
                  final CollectionReference users=FirebaseFirestore.instance.collection("Users");
                  Map<String,Object> info={
                    "FirstName":_firstName,
                    "LastName":_lastName,
                    "Age":_age,
                    "Hostel":_selectedHostel==null?"NULL":_selectedHostel!.name,
                    "Exercise_status": _exercise_status.toString(),
                    "Exercisetimings": _exerciseTiming!.hour.toString()+_exerciseTiming!.minute.toString(),
                  };
                  users.doc(uid).set(info);
                  print("Hurray");
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>MainMenu()));
                }
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    ),
  ),
);
}
}

