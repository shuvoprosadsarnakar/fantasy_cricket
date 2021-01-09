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
      home: ManagePlayer(),
      debugShowCheckedModeBanner: false,
    );
  }
}
