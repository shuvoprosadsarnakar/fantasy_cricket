import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/screens/home/player_list.dart';
import 'package:fantasy_cricket/screens/player/add_player.dart';
import 'package:fantasy_cricket/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Player>>.value(
      value: DataBase().Players,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
            )
          ],
        ),
        body: Center(
          child: Container(
            child: PlayerList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30.0,
          ),
          mini: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPlayer()),
            );
          },
        ),
      ),
    );
  }

}
