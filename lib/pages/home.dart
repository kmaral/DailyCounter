import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_counter/pages/UpdateCounter.dart';
import 'package:my_counter/pages/save.dart';
import 'CounterInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<counterInfo> counters=[];
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    //counters =  prefs.getStringList("Test").cast<counterInfo>();
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    setState(() {
      for (String key in prefs.getKeys()) {
        var map = json.decode(prefs.get(key));
        // print(key);
        // print(prefs.get(key));
        counters.add(counterInfo(counterName: key,
            count: map['countNumber'],
            startDate: map['startdate'],
            updatedDate: map['startdate']));
      }
    });
  }

  _removeCounter(int index, counterInfo counter) async
  {
    final prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    counters.removeAt(index);
    prefs.remove(counter.counterName);
  }

  saveCounters(BuildContext context) async{
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => Save()),
  );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () { Navigator.of(context).pop(false);
            Future.delayed(const Duration(milliseconds: 1), () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            });
            },
            child: Text("YES"),
          ),
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
            appBar: AppBar(title: Text('My Counter Lists'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              saveCounters(context);
            },
            child: Icon(Icons.add_box),
            backgroundColor: Colors.grey[800],
          ),
          body:
          Stack(
            children: [
              ListView.builder(
                itemCount: counters.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                    child: Card(
                      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () async {
                          //print('Card tapped.');
                          // start the SecondScreen and wait for it to finish with a result
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateCounter(counterName: counters[index].counterName)),
                          );
                          setState(() {
                            counters[index].updatedDate = result["startdate"];
                            counters[index].count = result["countNumber"];
                           // _loadCounter();
                          });
                        },
                        child:
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  // leading: FlutterLogo(size: 56.0),
                                  title: Text(counters[index].counterName,style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.pink[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                  subtitle: Text('Count: ' + counters[index].count),
                                  trailing: Icon(Icons.fast_forward_sharp),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(12.0,0.0,0.0,0.0),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Start Date : ',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            Text(counters[index].startDate,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0,5.0,0.0,5.0),
                                          child: Row(
                                            children: [
                                              Text('Last Updated Date : ',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              Text(counters[index].updatedDate,
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
                                  padding: const EdgeInsets.fromLTRB(12.0,0.0,12.0,0.0),
                                  child: ElevatedButton.icon(onPressed: (){
                                    setState(() {
                                      _removeCounter(index, counters[index]);
                                    });
                                  },icon: Icon(Icons.delete_sweep_sharp),label : Text('Delete'),
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
            ),]
          )
        ),
      ),
    );
  }
}



