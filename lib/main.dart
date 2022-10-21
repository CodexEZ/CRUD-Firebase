import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudbase/Widgets/UserInfo.dart';
import 'package:crudbase/Widgets/updateInfo.dart';
import 'package:crudbase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Model/user_model.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MainPage(),
    );
  }
}



class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: CircleAvatar(
        child: IconButton(
          icon: Icon(Icons.add,color: Colors.white,),
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserInfo(),
              ),
            );
          },
          color: Colors.blue,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('new').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasData){
            return ListView.builder(itemCount: snapshot.data!.docs.length,

              itemBuilder: (context,index)=>Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    color: Colors.white12
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity: VisualDensity(horizontal: 0,vertical: 4),
                        leading: CircleAvatar(child: Text('${snapshot.data!.docs[index]['age']}'),),
                        title: Text(
                            '${snapshot.data!.docs[index]['name']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Text(
                          '${snapshot.data!.docs[index]['birthday'].toDate()}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete,color: Colors.red,),
                            onPressed: (){
                              FirebaseFirestore.instance.collection('new').doc(snapshot.data!.docs[index].id).delete();
                            },
                          ),
                          SizedBox(width: 50,),
                          IconButton(
                            icon: Icon(Icons.edit,color: Colors.blue,),
                            onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateInfo(
                                    id: snapshot.data!.docs[index].id,
                                    name: snapshot.data!.docs[index]['name'],
                                    age:snapshot.data!.docs[index]['age'] ,
                                    birthday: snapshot.data!.docs[index]['birthday'].toDate(),
                                  ),
                                ),
                              );
                            },
                          ),

                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          else{
            return Center();
          }
        },
      )

      );

  }
  Widget buildUser(User user)=>ListTile(
    leading: CircleAvatar(child: Text('${user.age}'),),
    title: Text(user.name,style: TextStyle(color:Colors.white),),
    subtitle: Text(user.birthday.toIso8601String()),
  );
Stream<List<User>> readUsers() => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((snapshot)=>
    snapshot.docs.map((doc)=>User.fromJson(doc.data())).toList()
);


}


