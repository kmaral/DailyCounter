
import 'package:flutter/material.dart';
import 'package:my_counter/pages/loading.dart';
import 'package:my_counter/pages/home.dart';
void main() =>
  runApp(
    MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My Counter',
      initialRoute: '/',
      routes: {
        '/' : (context) => Loading(),
        '/home': (context) => Home()
      },
    ),
  );



