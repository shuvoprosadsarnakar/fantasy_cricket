import 'package:fantasy_cricket/screens/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
 
          return MaterialApp(
            title: 'Material App',
            home: HomePage(),
          );
        
  }
}
