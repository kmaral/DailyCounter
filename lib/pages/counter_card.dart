import 'package:flutter/material.dart';
import 'CounterInfo.dart';
import 'UpdateCounter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountersCard extends StatelessWidget {

  final counterInfo counter;
  final Function delete;

  CountersCard({this.counter, this.delete});

  openCounters(BuildContext context) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => UpdateCounter(counters:counter)),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          //print('Card tapped.');
          openCounters(context);
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
                  title: Text(counter.counterName,style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.pink[900],
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Count: ' + counter.count),
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
                           Text(counter.startDate,
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
                             Text(counter.startDate,
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
                  child: ElevatedButton.icon(onPressed: delete,icon: Icon(Icons.delete_sweep_sharp),label : Text('Delete'),
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
    );
  }
}
