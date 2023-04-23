import 'package:flutter/material.dart';

import 'package:hci_project/Models/Task.dart';
import 'package:hci_project/Screens/SubPages/TaskInputScreen.dart';
import 'package:hci_project/Screens/SubPages/task_detail_page.dart';
import 'package:hci_project/Services/Task_Database.dart';
import 'package:hci_project/Widgets/reusable_card_calendar.dart';
import 'package:hci_project/constants.dart';


import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Calendar extends StatefulWidget {
  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  late DateFormat dateFormat;
  late DateFormat timeFormat;
  DateTime _selectedDate = DateTime.now().add(Duration(days: 5));
  List<Task> tasks = [];


  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMMd('cs');
    timeFormat = new DateFormat.Hms('cs');

    _resetSelectedDate();
    refreshTask();
  }

  Future refreshTask() async{
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(_selectedDate);
    List<Task>?tasks2 = (await TaskDatabase.instance.readDateTask(formatted)).cast<Task>();
    print("Tasks length is "+ tasks.length.toString());
    setState(() {
      if(tasks.isNotEmpty || tasks.length > 0){
        tasks.clear();
      }
      if(tasks2.isNotEmpty)
        print(tasks2[0]);
      tasks = tasks2;
    });
  }

  void _resetSelectedDate() {
    setState(() {
      _selectedDate = DateTime.now();
    });

  }

  @override
  Widget build(BuildContext context) {
    void _showDeleteOrNavigateDialog(int index) {
    showDialog(context: context, builder:(BuildContext context){
          return AlertDialog(
            title: Text("Tap to list your goals or delete the task"),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async{
                  await TaskDatabase.instance.delete(tasks[index].id?? 0);
                  refreshTask();
                  Navigator.pop(context);
                },

              ),

              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
    });
  }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 231, 192, 255),
        title: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'Calendar',
                      style: kTitleTextStyle,
                    ),
                  ),
                ),
          automaticallyImplyLeading: false,
      ),

      backgroundColor: Colors.teal[100],
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        mouseCursor: MaterialStateMouseCursor.clickable,
        child:Icon(Icons.add),
        onPressed: (){
          Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => TaskInputScreen(),
                      ),
                    );
    },
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               

                SizedBox(height: 20,),
                CalendarTimeline(
                  showYears: true,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2020).add(Duration(days: 11322)),
                  onDateSelected: (date){
                    setState(() {
                      _selectedDate = date;
                    });
                    refreshTask();
                    print(_selectedDate);
                    print(TimeOfDay.now().toString());
                  },
                  leftMargin: 20,
                  monthColor: kMonthColour,
                  dayColor: kDayColour,
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: kSelectedDayColour,
                  dotsColor: kSelectedDayColour,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'My Task',
                          style: kTitleTextStyle,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.redoAlt,
                        size: 20,
                        color: Color.fromRGBO(16, 16, 16, 1.0),
                      ),
                      onPressed: (){
                        refreshTask();
                      },
                    ),
                    
                  ],
                ),
                if(tasks.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RawScrollbar(
                        thumbColor: kScrollBarColour,
                        radius: Radius.circular(20),
                        thickness: 5,
                        interactive: true,
                        thumbVisibility: false,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: tasks.length,
                          itemBuilder: (context, index){
                            return ReusableCardCalendar(
                               onlongpress:() async {
                                  _showDeleteOrNavigateDialog(index);
                                  
                               } ,
                                onPress: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskDetailPage(
                                        task: tasks[index],
                                      ),
                                    ),
                                  );
                                  print(tasks[index].taskDate);
                                },
                                TaskName: tasks[index].TaskName,
                                Category: tasks[index].Category,
                                startTime: tasks[index].startTime ,
                                colour: tasks[index].colour,
                                priority: tasks[index].priority,
                                id:tasks[index].id,
                            );
                          },
                        ),
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
