// import 'dart:js';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:todo/layouts/bottomNavigationBarLayout.dart';
// import 'package:todo/shared/components/components.dart';
//
// void showTheBottomSheet(
//     {required BuildContext context, required WidgetBuilder builder}) {
//   showModalBottomSheet(context: context, builder: builder);
// }
//
// void showTheBottomSheetFunction(context , formKey , nameController , timeController , dateController){
//    showTheBottomSheet(
//       context: context,
//       builder: (context) => SingleChildScrollView(
//         reverse: true,
// // This ensures the content scrolls up when the keyboard appears
//         scrollDirection: Axis.vertical,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             width: double.infinity,
// // height: 900,
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   todoFormField(
//                       controller: nameController,
//                       label: 'What is your task?',
//                       icon: Icon(Icons.task_outlined),
//                       ontap: () {},
//                       validator: (value) {
//                         if (value.toString().isEmpty) {
//                           return "required!!";
//                         }
//                       }),
//                   todoFormField(
//                       controller: timeController,
//                       label: 'Enter Time',
//                       icon: Icon(Icons.timer_outlined),
//                       validator: (value) {
//                         if (value.toString().isEmpty) {
//                           return "required!!";
//                         }
//                       },
//                       ontap: () {
//                         showTimePicker(
//                             context: context,
//                             initialTime:
//                             TimeOfDay.now())
//                             .then((value) {
//                           timeController.text = value!
//                               .format(context)
//                               .toString();
//                           print(timeController.text);
//                         });
//                       },
//                       TextInputType: TextInputType.none),
//                   todoFormField(
//                       controller: dateController,
//                       validator: (value) {
//                         if (value.toString().isEmpty) {
//                           return "required!!";
//                         }
//                       },
//                       ontap: () {
//                         showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime.now(),
//                             lastDate: DateTime.parse(
//                                 "2030-01-01"))
//                             .then((value) {
//                           if (value != null) {
//                             dateController.text =
//                                 DateFormat('yyyy-MM-dd')
//                                     .format(value);
//                             print(dateController.text);
//                           }
//                         });
//                       },
//                       label: 'Enter due date',
//                       TextInputType: TextInputType.none,
//                       icon: Icon(
//                           Icons.calendar_month_outlined)),
//                   Padding(
//                     padding: const EdgeInsets.all(25.0),
//                     child: Container(
//                         color: Colors.blue,
//                         child: TextButton(
//                             onPressed: () {
//                               if (formKey.currentState!
//                                   .validate()) {
//                                 insertRow(
//                                     nameController.text,
//                                     timeController.text,
//                                     dateController.text);
//                                 Navigator.pop(context);
//                               }
//                             },
//                             child: Text(
//                               "summit task",
//                               style: TextStyle(
//                                   color: Colors.white),
//                             ))),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ));
// }
//
