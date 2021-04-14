import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/player_add_edit.dart';
import 'package:fantasy_cricket/pages/team/team_add_edit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
      home: TeamAddEdit(),
      //home: Home(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorPallate.mercury,
        accentColor: ColorPallate.pomegranate,
        //canvasColor: ColorPallate.mercury,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
