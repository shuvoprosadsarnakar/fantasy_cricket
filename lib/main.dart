import 'package:fantasy_cricket/screens/add_player/add_player.dart';
import 'package:fantasy_cricket/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_cricket/screens/manage_player/manage_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Fantasy Cricket',
      home: AddPlayer(),
      debugShowCheckedModeBanner: false,
    );
  }
}
