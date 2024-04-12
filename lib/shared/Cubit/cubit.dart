
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

class appCubit extends Cubit<cubitStates>{
  appCubit() : super(intialState());

  static appCubit get(context) => BlocProvider.of(context);

  // attributes
  String modulesTitle = "app";
  List<String> title = ["Tasks", "Done Tasks", "Archive"];
  List<Widget> modules = [tasks(), done(), archive()];
  int currentIndex = 0;
  bool isTasks = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
   TextEditingController nameController = TextEditingController();
   TextEditingController timeController = TextEditingController();
   TextEditingController dateController = TextEditingController();

  //function to change index
  void changeIndex(int index){
    currentIndex = index;
    emit(bottomAppBarState());
  }

  //function to add the inserted task to the tasksList initialized in the constants file
  void refreshList(){
    emit(addToListState());
  }

}