import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/Cubit/cubit.dart';
import 'package:todo/shared/Cubit/states.dart';
import 'package:todo/shared/components/components.dart';

class done extends StatefulWidget{
  @override
  State<done> createState() => _doneState();
}

class _doneState extends State<done> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit, appCubitStates>(
      listener: (context, state) {
        // if(state is getDataBasetate) appCubit().changeTasksState();
      },
      builder: (context, state) {
        List<Map> taskslist = appCubit.get(context).doneTasksList;
        return Container(
          color: Colors.grey[100],
          child: ListView.separated(
              itemBuilder: (context, index) =>  taskCard(tasksItem: taskslist[index] , context: context),
              separatorBuilder: (context, index) => Container(
                color: Colors.grey,
                width: double.infinity,
                height: 1,
              ),
              itemCount: taskslist.length),
        );
      },
    );

  }
}
