import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/screens/add_player/add_player.dart';
import 'package:fantasy_cricket/screens/home/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
      home: AddPlayer(player: Player(id: '3M6o64w9i361HoiCr40Z', name: 'a', role: 'Wicket Keeper')),
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
