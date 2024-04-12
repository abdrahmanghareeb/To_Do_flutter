
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/tasks.dart';
import 'package:todo/shared/Cubit/cubit.dart';
import 'package:todo/shared/Cubit/states.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

class bottomNavigationBarLayout extends StatelessWidget {

  // createDatabase();
  late Database database;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>appCubit(),

      child: BlocConsumer<appCubit , cubitStates>(
        listener: (context, state) {},
        builder:(context, state) {
          createDatabase();
          appCubit cubit = appCubit.get(context);
          return Scaffold(
              resizeToAvoidBottomInset: true,
              // Ensure this is set to true
              key: cubit.scaffoldKey,
              appBar: AppBar(
                  title: Text(
                    cubit.title[cubit.currentIndex],
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue),
              body: cubit.modules[cubit.currentIndex],
              floatingActionButton: cubit.isTasks
                  ? FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    // scaffoldKey.currentState?.showBottomSheet((context) {});
                    showTheBottomSheet(
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          reverse: true,
                          // This ensures the content scrolls up when the keyboard appears
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              // height: 900,
                              child: Form(
                                key: cubit.formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    todoFormField(
                                        controller: cubit.nameController,
                                        label: 'What is your task?',
                                        icon: Icon(Icons.task_outlined),
                                        ontap: () {},
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return "required!!";
                                          }
                                        }),
                                    todoFormField(
                                        controller: cubit.timeController,
                                        label: 'Enter Time',
                                        icon: Icon(Icons.timer_outlined),
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return "required!!";
                                          }
                                        },
                                        ontap: () {
                                          showTimePicker(
                                              context: context,
                                              initialTime:
                                              TimeOfDay.now())
                                              .then((value) {
                                            cubit.timeController.text = value!
                                                .format(context)
                                                .toString();
                                            print(cubit.timeController.text);
                                          });
                                        },
                                        TextInputType: TextInputType.none),
                                    todoFormField(
                                        controller: cubit.dateController,
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return "required!!";
                                          }
                                        },
                                        ontap: () {
                                          showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.parse(
                                                  "2030-01-01"))
                                              .then((value) {
                                            if (value != null) {
                                              cubit.dateController.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(value);
                                              print(cubit.dateController.text);
                                            }
                                          });
                                        },
                                        label: 'Enter due date',
                                        TextInputType: TextInputType.none,
                                        icon: Icon(
                                            Icons.calendar_month_outlined)),
                                    Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Container(
                                          color: Colors.blue,
                                          child: TextButton(
                                              onPressed: () {
                                                if (cubit.formKey.currentState!
                                                    .validate()) {
                                                  insertRow(
                                                      cubit.nameController.text,
                                                      cubit.timeController.text,
                                                      cubit.dateController.text);
                                                  // //added line (test)
                                                  getRows(database);
                                                  // cubit.addToList();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text(
                                                "summit task",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ))
                  : null,
              bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    cubit.changeIndex(index);
                    if (cubit.currentIndex == 0)
                      cubit.isTasks = true;
                    else
                      cubit.isTasks = false;
                  },
                  currentIndex: cubit.currentIndex,
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                    BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive_outlined), label: "Archive"),
                  ]));
        }
      ),
    );
  }

  // database manipulation....
  // create database
  // create table
  // open db
  // insert, get, update, delete

  void createDatabase() async {
    database
    = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print("DB created successfully.");
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT, time TIME, date DATE, state REAL)')
            .then((value) {
          print("Table created successfully");
        }).catchError((error) {
          print("failed to excute the table ${error.toString()}");
        });
      },
      onOpen: (db) {
        getRows(db);
        print("DB opened successfully.");
      },
    );
  }

  Future insertRow(var title, var time, var date ) async {
    database
        .rawInsert(
            'INSERT INTO tasks (name , time , date , state) VALUES ("$title", "$time", "$date" , "not Finished")')
        .then((value) {
      print("row $value insterted successfully...");
    });
  }

  Future<void> getRows(db) async {
    tasksList = await db.rawQuery('SELECT * FROM tasks');
  }
}
