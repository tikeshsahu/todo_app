import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = await auth.currentUser;
    FocusScope.of(context).unfocus();

    String userId = user!.uid;

    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(userId)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Task Added');
    Navigator.of(context).pop();
  }
  // TimeOfDay selectedTime = TimeOfDay.now();

  //  void selectTime(BuildContext context) async {
  //     final TimeOfDay? timeOfDay = await showTimePicker(
  //       context: context,
  //       initialTime: selectedTime,
  //       initialEntryMode: TimePickerEntryMode.dial,

  //     );
  //     if(timeOfDay != null && timeOfDay != selectedTime)
  //       {
  //         setState(() {
  //           selectedTime = timeOfDay;
  //         });
  //       }
  // }
  // DateTime selectedDate = DateTime.now();
  // void presenDatePicker(){
  //   showDatePicker(
  //     context: context, 
  //     initialDate: DateTime.now(), 
  //     firstDate: DateTime(2020), 
  //     lastDate: DateTime.now()
  //     ).then((pickedDate) {
  //       if(pickedDate == null){
  //         return;
  //       }
  //       setState(() {
  //         selectedDate = pickedDate;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                autocorrect: true,
                toolbarOptions: ToolbarOptions(paste: true),
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 8,),

            //ElevatedButton(onPressed: selectTime , child: Text('mmm')),

            SizedBox(
              height: 20,
            ),
            Container(
              width: 180,
              height: 50,
              child: ElevatedButton(
                child: Text('Add Task'),
                onPressed: addTaskToFirebase,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
