import 'package:flutter/material.dart';

final String tableTask = 'tasks';

class TaskField{
  static final List<String> values = [
    id, taskDate, category, taskName, description, colour, startTime,startTimeMin, goals, priority
  ];

  static final String id = '_id';
  static final String taskDate = 'taskDate';
  static final String category = 'category';
  static final String taskName = 'taskName';
  static final String description = 'description';
  static final String colour = 'color';
  static final String startTime = 'startTime';
  static final String startTimeMin = 'startTimeMin';
  //static final String endTime = 'endTime';
  //static final String endTimeMin = 'endTimeMin';
  static final String goals = 'goals';
  static final String priority='priority';

}

class Task {
  final int? id;
  final String taskDate;
  final String Category;
  final String TaskName;
  final String Description;
  final Color colour;
  final TimeOfDay startTime;
  final String goals;
  final String priority;
  //final TimeOfDay endTime;
  const Task({
    this.id,
    required this.taskDate,
    required this.Category,
    required this.TaskName,
    required this.Description,
    required this.colour,
    required this.startTime,
  
    required this.goals,
    required this.priority
      //required this.endTime,
  });

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json["_id"] as int?,
    taskDate: json["taskDate"] as String,
    Category: json["category"] as String,
    TaskName: json["taskName"] as String,
    Description:json["description"] as String,
    colour: Color(json["color"] as int),
    startTime:  TimeOfDay(hour: json["startTime"] as int, minute: json["startTimeMin"] as int),
    goals: json["goals"] as String, 
    priority: json["priority"] as String,
     //endTime:  TimeOfDay(hour: json["endTime"] as int, minute: json["endTimeMin"] as int),
  );


  Map<String, Object?> toJson() => {
    "_id":  id,
    "taskDate": taskDate,
    "category": Category,
    "taskName": TaskName,
    "description": Description,
    "color": colour.value,
    "startTime": startTime.hour,
    "startTimeMin": startTime.minute,
    "goals": goals,
    "priority":priority,
    //"endTime": endTime.hour,
    //"endTimeMin": endTime.minute,
   
  };

  Task copy({
    int? id,
    String? taskDate,
    String? Category,
    String? TaskName,
    String? Description,
    Color? colour,
    TimeOfDay? startDate,
    String? goals,
    String? priority,
    //TimeOfDay? endDate,

  }) =>
    Task(
      id: id ?? this.id,
      taskDate: taskDate ?? this.taskDate,
      Category: Category ?? this.Category ,
      TaskName: TaskName ?? this.TaskName,
      Description: Description ?? this.Description,
      colour: colour ?? this.colour,
      startTime: startDate ?? this.startTime,
      goals: goals ?? this.goals,
      priority: priority ?? this.priority,
      //endTime: endDate ?? this.endTime,
      
    );
}