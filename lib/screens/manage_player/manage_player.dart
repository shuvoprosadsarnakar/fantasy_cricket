import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/screens/manage_player/player_list.dart';
import 'package:fantasy_cricket/screens/player/add_player.dart';
import 'package:fantasy_cricket/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagePlayer extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return StreamProvider<List<Player>>.value(
      value: DataBase().players,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manage Player'),
          centerTitle: true,
        ),
        body: PlayerList(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          // mini: true,
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
