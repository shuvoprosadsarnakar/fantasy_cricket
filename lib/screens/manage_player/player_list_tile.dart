import 'package:fantasy_cricket/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/screens/player_profile/player_profile.dart';

class PlayerListTile extends StatelessWidget {
  final Player player;
  const PlayerListTile({this.player});
  void deleteRecord() {
    DataBase().deletePlayer(player.id);
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(player.name[0]),
      ),
      title: Text(player.name),
      subtitle: Text(player.handed),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => deleteRecord(),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PlayerProfile(player))),
    );
  }
}
