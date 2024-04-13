import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/Cubit/observer.dart';

import 'layouts/bottomNavigationBarLayout.dart';


// Master Branch
// Bloc created now.
// edit 2

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: bottomNavigationBarLayout(),
    );
  }
}

