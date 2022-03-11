import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/fcm/v1.dart';
import 'package:sasta_todo_app/screens/add_task.dart';
import 'package:intl/intl.dart';

import 'try.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userId = '';
  @override
  void initState() {
    getUserid();
    super.initState();
  }

  getUserid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    setState(() {
      userId = user!.uid;
    });
  }

  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My ToDos',
        ),
        actions: [
          IconButton(
            onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>  trial()));
        }, 
            icon: Icon(Icons.access_alarm)
            ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Logging out'),
                        content: Text('Pakka Logout Kardu ?'),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(ctx).pop(true);
                              },
                              child: Text('YES',
                                  style: TextStyle(color: Colors.amber[800]))),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(true);
                              },
                              child: Text(
                                'NO',
                                style: TextStyle(color: Colors.amber[800]),
                              ))
                        ],
                      ));
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(userId)
              .collection('mytasks')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final taskData = snapshot.data!.docs;
              return ListView.builder(
                itemCount: taskData.length,
                itemBuilder: (context, index) {
                  var time =
                      (taskData[index]['timestamp'] as Timestamp).toDate();

                  return InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              title: Text(
                                taskData[index]['title'],
                              ),
                              scrollable: true,
                              content: Text(
                                taskData[index]['description'],
                              )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            )
                          ]),
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    taskData[index]['title'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                    //taskData[index]['time'],
                                    DateFormat.MMMEd().add_jm().format(time)),
                              )
                            ],
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(userId)
                                      .collection('mytasks')
                                      .doc(taskData[index]['time'])
                                      .delete();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          size: 35,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
      ),
    );
  }
}
