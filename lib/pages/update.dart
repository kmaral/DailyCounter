import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_counter/pages/UpdateCounter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'home.dart';

var map;
var _selected = 0;

class Update extends StatefulWidget {
  final String counterInfoName;

  // In the constructor, require a Todo.
  Update({this.counterInfoName});
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController textFieldController = TextEditingController();
  var _intervals = [
    1,
    3,
    5,
    6,
    8,
    12,
    24,
  ];
  //map['interval'] != null ? int.parse(map['interval']) : 0;
  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  _loadCounter(String counterName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      map = json.decode(prefs.get(counterName));
      if (map['interval'] != null) _selected = int.parse(map['interval']);
    });
  }

  @override
  void initState() {
    super.initState();
    textFieldController.text = widget.counterInfoName;
    _loadCounter(textFieldController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Update Counter Name'),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent[200],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name the Counter',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: textFieldController,
                    decoration: InputDecoration(labelText: ''),
                    maxLength: 50,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Remind me every  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DropdownButton<int>(
                          iconEnabledColor: Color(0xFF3EB16F),
                          hint: _selected == 0
                              ? Text(
                                  "Select an Interval",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                )
                              : null,
                          elevation: 4,
                          value: _selected == 0 ? null : _selected,
                          items: _intervals.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                value.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _selected = newVal;
                            });
                          },
                        ),
                        Text(
                          _selected == 1 ? " hour" : " hours",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          String textToSend = textFieldController.text;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          // if (prefs.containsKey(textToSend)) {
                          //   showAlertDialog(context);
                          // } else {
                          var map =
                              json.decode(prefs.get(widget.counterInfoName));
                          prefs.remove(widget.counterInfoName);
                          map['interval'] = _selected.toString();
                          prefs.setString(textToSend, json.encode(map));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                          scheduleInterval();
                          //}
                        },
                        label: Text('Update the Counter'),
                        icon: Icon(
                          Icons.save_sharp,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink[900],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update Counter"),
      content: Text("The Counter Name already exists. Please create new one."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

void scheduleInterval() async {
  final prefs = await SharedPreferences.getInstance();
  var map = json.decode(prefs.get(counterInfoName));
  // print(map['interval']);
  var scheduledNotificationDateTime =
      DateTime.now().add(Duration(hours: int.parse(map['interval'])));
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'alarm_notif',
    'alarm_notif',
    'Channel for Alarm notification',
    icon: 'count_launcher',
    //sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    largeIcon: DrawableResourceAndroidBitmap('count_launcher'),
  );

  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      // sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(
      0,
      counterInfoName,
      'Time to update, ' + 'Current Count is : ' + map['countNumber'],
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}
