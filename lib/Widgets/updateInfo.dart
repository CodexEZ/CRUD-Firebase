import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
class UpdateInfo extends StatelessWidget {
  String id;
  String name;
  int age;
  DateTime birthday;
  UpdateInfo({
    required this.id,
    required this.name,
    required this.age,
    required this.birthday,
});
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: name,
                  hintStyle: TextStyle(color: Colors.white30),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  focusColor: Colors.green
              ),
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
            SizedBox(height: 24,),
            TextField(
              controller: controllerAge,

              decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: '$age',
                  hintStyle: TextStyle(color: Colors.white30),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  focusColor: Colors.green
              ),
              style: TextStyle(
                  color: Colors.grey
              ),
            ),
            SizedBox(height: 24,),
            TextButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1900, 1, 1),
                      maxTime: DateTime.now(),
                      onConfirm: (date) {
                    birthday=date;

                      }, currentTime: birthday, locale: LocaleType.en);
                },
                child: Text(
                  'Set Birth Date',
                  style: TextStyle(color: Colors.blue, fontSize: 24,),
                )),
            SizedBox(height: 50,),
            FlatButton(
              color: Colors.white,
              child: Text("Create",style: TextStyle(color: Colors.lightBlue),),
              onPressed: (){
                FirebaseFirestore.instance.collection('new').doc(id).update({
                  'name':controllerName.text,
                  'age' :int.parse(controllerAge.text),
                  'birthday':birthday
                });

              },
            )
          ],
        ),
      ),
    );
  }
}

