import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class trial extends StatefulWidget {
   trial({ Key? key }) : super(key: key);

  @override
  State<trial> createState() => _trialState();
}

class _trialState extends State<trial> {
    TimeOfDay selectedTime = TimeOfDay.now();
  
  
     selectTime(BuildContext context) async {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if(timeOfDay != null && timeOfDay != selectedTime)
        {
          setState(() {
            selectedTime = timeOfDay;
          });
        }
  }
  
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: selectTime(context)),
        
      ),
    );
  }
}