import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'home.dart';

class Save extends StatefulWidget {
  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  TextEditingController textFieldController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add New Counter'),
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
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          String textToSend = textFieldController.text;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          Map<String, dynamic> map = {
                            'countNumber': "0",
                            'startdate': DateFormat('yyyy-MM-dd – hh:mm')
                                .format(DateTime.now())
                                .toString(),
                            'interval': "0",
                          };
                          if (prefs.containsKey(textToSend)) {
                            showAlertDialog(context);
                          } else {
                            prefs.setString(textToSend, json.encode(map));
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          }
                        },
                        label: Text('Save the Counter'),
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
      title: Text("Save Counter"),
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
