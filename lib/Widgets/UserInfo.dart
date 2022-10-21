import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../Model/user_model.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  DateTime bday = DateTime.now() ;
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
                labelText: 'Enter Name',
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
                  labelText: 'Enter Age',
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
                    setState((){bday=date;});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
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
                createUser(name: controllerName.text, age: int.parse(controllerAge.text), birthday: bday);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
  Future createUser({required String name, required int age, required DateTime birthday}) async{
    final docUser = FirebaseFirestore.instance.collection('new').doc();
    final user = User(
        id: docUser.id,
        name: name,
        age: age,
        birthday: birthday
    );
    final json = user.toJson();
    await docUser.set(json);
  }
}
