import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

Widget taskCard({@required tasksList }){
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
          Text("${tasksList["time"]}" , style:TextStyle(color: Colors.white),),),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${tasksList["name"]}" ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text("Due to " , style: TextStyle(fontWeight: FontWeight.w500)),
                    Text("${tasksList["date"]}"),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

void showTheBottomSheet(
    {required BuildContext context, required WidgetBuilder builder}) {
  showModalBottomSheet(context: context, builder: builder);
}
