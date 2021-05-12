import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'update.dart';

String counterInfoName;

class UpdateCounter extends StatefulWidget {
  final String counterName;
  final String counterNameFromUpdate;

  // In the constructor, require a Todo.
  UpdateCounter({this.counterName, this.counterNameFromUpdate});
  @override
  _UpdateCounterState createState() => _UpdateCounterState();
}

class _UpdateCounterState extends State<UpdateCounter> {
  int _counter = 0;
  Map<String, dynamic> mapSend;
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.counterNameFromUpdate != null &&
          widget.counterNameFromUpdate != "") {
        counterInfoName = widget.counterNameFromUpdate;
      } else {
        counterInfoName = widget.counterName;
      }
      var map = json.decode(prefs.get(counterInfoName));
      _counter = int.parse(map['countNumber']);
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
      mapSend = {
        'countNumber': _counter.toString(),
        'startdate':
            DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now()).toString(),
      };
      //prefs.setStringList(textToSend,["0", DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now()).toString()]);
      prefs.setString(counterInfoName, json.encode(mapSend));
      //prefs.setStringList(widget.counterName, [_counter.toString(), widget.counters.startDate, widget.counters.updatedDate]);
    });
  }

  _decrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_counter <= 0) {
        _counter = 0;
      } else {
        _counter--;
      }
      mapSend = {
        'countNumber': _counter.toString(),
        'startdate':
            DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now()).toString(),
      };
      //prefs.setStringList(textToSend,["0", DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now()).toString()]);
      prefs.setString(counterInfoName, json.encode(mapSend));
      //prefs.setStringList(widget.counterName, [_counter.toString(), widget.counters.startDate, widget.counters.updatedDate]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Update the Counter'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[200],
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, mapSend);
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(310.0, 0.0, 0.0, 0.0),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings_applications_sharp),
                        iconSize: 30.0,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Update(counterInfoName: counterInfoName)),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 30.0, 10.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 350.0,
                        child: Text(
                          counterInfoName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 200, height: 120),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _incrementCounter();
                        },
                        label: Text('Add'),
                        icon: Icon(
                          Icons.add_circle_outline_sharp,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink[900],
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        //width: 120.0,
                        child: Text(
                          _counter.toString(),
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 70.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Entry Numbers',
                        style: TextStyle(
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 300, height: 120),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _decrementCounter();
                        },
                        label: Text('Remove'),
                        icon: Icon(
                          Icons.remove_circle_outline_sharp,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink[900],
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
