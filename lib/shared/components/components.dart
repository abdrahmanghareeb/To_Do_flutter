import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/Cubit/cubit.dart';

Widget todoFormField(
    {required TextEditingController controller,
     TextInputType = TextInputType.text,
    required String label,
    required Icon icon,
      required FormFieldValidator validator,
      required GestureTapCallback ontap}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    keyboardType: TextInputType,
    onTap: ontap,
    decoration: InputDecoration(
      prefixIcon: icon,
      labelText: label,
    ),
  );
}

Widget taskCard({@required tasksItem , @required context}){
  bool isDone =false;
  bool isArchive =false;
  if(tasksItem["status"] == "done"){
    isDone = true;
  }
  if(tasksItem["status"] == "archive"){
    isArchive = true;
  }

  return  Container(
    color: Colors.grey[50],
    child: Padding(
      padding:  EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(backgroundColor: Colors.blue, radius: 40,child:
          Text("${tasksItem["time"]}" , style:TextStyle(color: Colors.white),),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${tasksItem["name"]}" ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text("Due to " , style: TextStyle(fontWeight: FontWeight.w500)),
                      Text("${tasksItem["date"]}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(onPressed: (){
            if(isDone == false){
              isDone = !isDone;
              print(isDone);
              appCubit.get(context).updateDatabase(status:  'done',id:  tasksItem["id"]);
            }else{
              isDone = !isDone;
              print(isDone);
              if(isArchive == false) {
                appCubit.get(context).updateDatabase(status:  'new',id:  tasksItem["id"]);
              }
            }
            },
              icon: isDone ? Icon(Icons.check_box) : Icon(Icons.check_box_outlined) ),
          IconButton(onPressed: (){
            if(isArchive == false){
              isArchive = !isArchive;
              print(isArchive);
              appCubit.get(context).updateDatabase(status:  'archive',id:  tasksItem["id"]);
            }else{
              isArchive = !isArchive;
              print(isArchive);
              if(isDone == false) {
                appCubit.get(context).updateDatabase(status:  'new',id:  tasksItem["id"]);
              }
            }
            },
              icon: isArchive ? Icon(Icons.archive) : Icon(Icons.archive_outlined) ),
        ],
      ),
    ),
  );
}

void showTheBottomSheet(
    {required BuildContext context, required WidgetBuilder builder}) {
  showModalBottomSheet(context: context, builder: builder);
}
