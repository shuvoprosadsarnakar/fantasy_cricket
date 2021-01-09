import 'package:flutter/material.dart';
import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/screens/player_profile/player_profile.dart';

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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => PlayerProfile(player))
      ),
    );
  }
}