import 'package:fantasy_cricket/model/player.dart';
import 'package:flutter/material.dart';

class PlayerListTile extends StatelessWidget
{
  final Player player;

  const PlayerListTile({this.player});

  @override
  Widget build(BuildContext context)
  {
    return ListTile(
      leading: CircleAvatar(
        child: Text(player.name[0]),
      ),
      title: Text(player.name),
      subtitle: Text(player.role),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => print('hello!'),
      ),
      onTap: () => print('pressed!'),
    );
  }
}