
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archive.dart';
import 'package:todo/modules/done.dart';
import 'package:todo/modules/tasks.dart';
import 'package:todo/shared/Cubit/states.dart';
import 'package:todo/shared/components/constants.dart';



class appCubit extends Cubit<appCubitStates>{

  appCubit() : super(appIntialState());

  static appCubit get(context) => BlocProvider.of(context);

  // database variable
  late Database database;
  List<Map> newTasksList = [];
  List<Map> doneTasksList = [];
  List<Map> archiveTasksList = [];
  // list to carry the Database records
  // attributes
  String modulesTitle = "app";
  List<String> title = ["Tasks", "Done Tasks", "Archive"];
  List<Widget> modules = [tasks(), done(), archive()];
  //index of the bottom navigation bar
  int currentIndex = 0;
  // to show the floating action button only in the Tasks screen
  bool isTasks = true;
  // useless right now , but can be used for creating bottom sheet.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // used for the validation of the TextFormFields in the bottom sheet/Tasks
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //Text editing controllers to carry the values of the TextFormFields in the bottom sheet/Tasks
   TextEditingController nameController = TextEditingController();
   TextEditingController timeController = TextEditingController();
   TextEditingController dateController = TextEditingController();

  //  to change index of the bottom sheet
  void changeIndex(int index){
    currentIndex = index;
    emit(bottomAppBarState());
  }

  // database manipulation....
  // create database
  // create table
  // open db
  // insert, get, update, delete

  void createDatabase()  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print("DB created successfully.");
        db
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT, time TIME, date DATE, status TEXT)')
            .then((value) {
          print("Table created successfully");
          emit(createDataBaseState());
        }).catchError((error) {
          print("failed to excute the table ${error.toString()}");
        });
      },
      onOpen: (db) {
        print("DB opened successfully.");
        getRows(db);
      },
    ).then((value) { database = value ; emit(openDataBaseState());});
  }

  insertRow(var title, var time, var date ) async {
    database
        .rawInsert(
        'INSERT INTO tasks (name , time , date , status) VALUES ("$title", "$time", "$date" , "new")')
        .then((value) {
      print("row $value insterted successfully...");
      emit(insertIntoDataBasetate());
      getRows(database);
    });
  }

  void getRows(db)  {
    newTasksList = [];
    doneTasksList = [];
    archiveTasksList = [];
    db.rawQuery('SELECT * FROM tasks order by id').then((value) {
      value.forEach((value){
        if(value['status'] == "new") {
          newTasksList.add(value);
          // new tasksList
          print(newTasksList);
        }
        else if (value['status'] == "done") {
          doneTasksList.add(value);
          // done tasksList
          print(doneTasksList);
        }
        else if (value['status'] == "archive") {
          archiveTasksList.add(value);
          // archive tasksList
          print(archiveTasksList);
        }
      });
      emit(getDataBasetate());
      // emit tasksState  and clear all the TextFormFields in the Bottom Sheet
      changeTasksState();
    });
  }

  // bottom sheet state when clicking on the floating action button
  void changeBottomSheetState(){
    emit(bottomSheetState());
  }

  // bottom sheet state
  void changeTasksState(){
    //important : clear the TextFormFields again in the bottom sheet
    nameController = TextEditingController();
    timeController = TextEditingController();
    dateController = TextEditingController();
    emit(onTasksState());
  }

  void updateDatabase({@required status ,@required id}) async {
    // Update some record
     await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status' , '$id']).then((value) {
          emit(updateIntoDataBasetate());
       getRows(database);
     });
  }

}