import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Update extends StatefulWidget {
  final String counterInfoName;

  // In the constructor, require a Todo.
  Update({this.counterInfoName});
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController textFieldController = TextEditingController();
  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    textFieldController.text = widget.counterInfoName;
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
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name the Counter',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: textFieldController,
                    decoration: InputDecoration(
                        labelText: ''
                    ),
                    maxLength: 50,
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children:  [
                      ElevatedButton.icon(onPressed: () async{
                        String textToSend = textFieldController.text;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        if(prefs.containsKey(textToSend))
                        {
                          showAlertDialog(context);
                        }
                        else {
                          var map = json.decode(prefs.get(widget.counterInfoName));
                          prefs.remove(widget.counterInfoName);
                          prefs.setString(textToSend, json.encode(map));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),

                          );
                        }
                      },label: Text('Update the Counter'),icon: Icon(
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
      onPressed: () {  Navigator.of(context).pop(); // dismiss dialog
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




