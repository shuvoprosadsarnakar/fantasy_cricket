import 'package:fantasy_cricket/model/player.dart';
import 'package:flutter/material.dart';

class PlayerTile extends StatelessWidget {
  final Player player;

  const PlayerTile({ this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.amber,
            ),
          title: Text(player.name),
          subtitle: Text(player.role),
          trailing: Text(player.handed),
        ),
      ),
    );
  }
}