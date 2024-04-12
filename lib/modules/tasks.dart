import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

class tasks extends StatefulWidget {
  @override
  State<tasks> createState() => _tasksState();
}

class _tasksState extends State<tasks> {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.grey[100],
      child: ListView.separated(
          itemBuilder: (context, index) =>  taskCard(tasksList: tasksList[index]),
          separatorBuilder: (context, index) => Container(
                color: Colors.grey,
                width: double.infinity,
                height: 1,
              ),
          itemCount: tasksList.length),
    );
  }
}
