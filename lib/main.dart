import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/screens/home/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
      home: Home(),
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: ColorPallate.mercury,
        accentColor: ColorPallate.pomegranate,

        canvasColor: ColorPallate.mercury
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
