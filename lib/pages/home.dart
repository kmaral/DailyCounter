import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_counter/pages/UpdateCounter.dart';
import 'package:my_counter/pages/remainder/interval.dart';
import 'package:my_counter/pages/save.dart';
import 'CounterInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<counterInfo> counters = [];
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (String key in prefs.getKeys()) {
        var map = json.decode(prefs.get(key));
        // print(key);
        // print(prefs.get(key));
        counters.add(counterInfo(
            counterName: key,
            count: map['countNumber'],
            startDate: map['startdate'],
            interval: map['interval'],
            updatedDate: map['startdate']));
      }
    });
  }

  _removeCounter(int index, counterInfo counter) async {
    final prefs = await SharedPreferences.getInstance();
    counters.removeAt(index);
    prefs.remove(counter.counterName);
  }

  saveCounters(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Save()),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new ElevatedButton(
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
              SizedBox(height: 16),
              new ElevatedButton(
                  child: Text("YES"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    Future.delayed(const Duration(milliseconds: 1), () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    });
                  }),
            ],
          ),
        ) ??
        false;
  }

  // List<counterInfo> counterstest = [
  //   counterInfo(count:  '20',counterName: "Test12",startDate:DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(),
  //       updatedDate:DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now().subtract(Duration(days: 2))).toString()),
  //   counterInfo(count: '30',counterName:'Computers',startDate:DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(),
  //       updatedDate: DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now().subtract(Duration(days: 2))).toString()),
  //   counterInfo(count: '47',counterName:'Mobiles',startDate: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(),
  //       updatedDate: DateFormat('yyyy-MM-dd – hh:mm').format(DateTime.now().subtract(Duration(days: 10)))),
  //
  // ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Center(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Daily Counter List'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                saveCounters(context);
              },
              child: Icon(Icons.add_box),
              backgroundColor: Colors.grey[800],
            ),
            body: Stack(children: [
              ListView.builder(
                itemCount: counters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 4.0),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateCounter(
                                    counterName: counters[index].counterName)),
                          );
                          setState(() {
                            if (result != null) {
                              counters[index].updatedDate = result["startdate"];
                              counters[index].count = result["countNumber"];
                              counters[index].interval = result["countNumber"];
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  title: Text(
                                    counters[index].counterName,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.pink[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Count: ' + counters[index].count,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.pink[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Icon(Icons.fast_forward_sharp),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 0.0, 0.0, 0.0),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Start Date : ',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            Text(
                                              counters[index].startDate,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 5.0, 0.0, 5.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Last Updated Date : ',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text(
                                                counters[index].updatedDate,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 5.0, 0.0, 5.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Interval : ',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text(
                                                counters[index]
                                                        .interval
                                                        .toString() +
                                                    ' hours',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 0.0, 12.0, 0.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _removeCounter(index, counters[index]);
                                      });
                                    },
                                    icon: Icon(Icons.delete_sweep_sharp),
                                    label: Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.pink[900],
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ])),
      ),
    );
  }
}
