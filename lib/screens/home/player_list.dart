import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/screens/home/player_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

class PlayerList extends StatefulWidget
{
  @override
  PlayerListState createState() => PlayerListState();
}

class PlayerListState extends State<PlayerList>
{
  String search = '';

  @override
  Widget build(BuildContext context)
  {
    final allPlayers = Provider.of<List<Player>>(context);
    int totalPlayers = allPlayers == null ? 0 : allPlayers.length;
    List<Player> filteredPlayers = [];

    if(search.isNotEmpty)
    {
      search = search.toLowerCase();

      for(int i = 0; i < totalPlayers; i++)
      {
        if(allPlayers[i].name.toLowerCase().contains(search))
        {
          filteredPlayers.add(allPlayers[i]);
        }
      }
    }
    else if(allPlayers != null) filteredPlayers = allPlayers;

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search Player',
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
          onChanged: (String name) {
            search = name;
            setState(() {});
          },
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: filteredPlayers.length,
            itemBuilder: (BuildContext context, int index) {
              return PlayerListTile(player: filteredPlayers[index]);
            },
          ),
        ),
      ],
    );
  }
}
