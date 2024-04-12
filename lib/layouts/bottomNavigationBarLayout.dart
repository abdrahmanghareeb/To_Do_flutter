import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/done.dart';
import 'package:todo/modules/archive.dart';
import 'package:todo/modules/tasks.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

class bottomNavigationBarLayout extends StatefulWidget {
  // start
  @override
  State<bottomNavigationBarLayout> createState() =>
      _BottomNavigationBarLayoutState();
}

class _BottomNavigationBarLayoutState extends State<bottomNavigationBarLayout> {
  String modulesTitle = "app";
  int currentIndex = 0;
  List<String> title = ["Tasks",  "Done Tasks", "Archive"];
  List<StatefulWidget> modules = [tasks(), done(), archive()];
  bool isTasks = true;
  late Database database;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController timeController;
  late TextEditingController dateController;

  void showTheBottomSheet(
      {required BuildContext context, required WidgetBuilder builder}) {
    showModalBottomSheet(context: context, builder: builder);
  }

  @override
  void initState() {
    super.initState();
    createDatabase();
    nameController = TextEditingController();
    timeController = TextEditingController();
    dateController = TextEditingController();
  }

  //                        UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        // Ensure this is set to true
        key: scaffoldKey,
        appBar: AppBar(
            title: Text(
              title[currentIndex],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue),
        body: tasksList.length == 0  ? Center(child: CircularProgressIndicator()) :modules[currentIndex],
        floatingActionButton: isTasks
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
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      todoFormField(
                                          controller: nameController,
                                          label: 'What is your task?',
                                          icon: Icon(Icons.task_outlined),
                                          ontap: () {},
                                          validator: (value) {
                                            if (value.toString().isEmpty) {
                                              return "required!!";
                                            }
                                          }),
                                      todoFormField(
                                          controller: timeController,
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
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString();
                                              print(timeController.text);
                                            });
                                          },
                                          TextInputType: TextInputType.none),
                                      todoFormField(
                                          controller: dateController,
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
                                                dateController.text =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(value);
                                                print(dateController.text);
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
                                                  if (formKey.currentState!.validate()) {
                                                    insertRow(
                                                        nameController.text,
                                                        timeController.text,
                                                        dateController.text);
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
              setState(() {
                currentIndex = index;
                if (currentIndex == 0)
                  isTasks = true;
                else
                  isTasks = false;
              });
            },
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
              BottomNavigationBarItem(icon: Icon(Icons.done), label: "Done"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: "Archive"),
            ]));
  }

  // database manipulation....
  // create database
  // create table
  // open db
  // insert, get, update, delete

  void createDatabase() async {
    database = await openDatabase(
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

  Future insertRow(var title, var time, var date) async {
    database
        .rawInsert('INSERT INTO tasks (name , time , date , state) VALUES ("$title", "$time", "$date" , "not Finished")')
        .then((value) {print("row $value insterted successfully...");});

  }

  Future<void> getRows(db) async {
    tasksList = await db.rawQuery('SELECT * FROM tasks');
  }
}
