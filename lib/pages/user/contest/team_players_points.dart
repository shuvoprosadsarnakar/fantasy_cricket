import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class TeamPlayersPoints extends StatelessWidget {
  final Contest _contest;
  final Fantasy _fantasy;

  TeamPlayersPoints(this._contest, this._fantasy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Team of ${_fantasy.username}')),
      body: ListView(
        padding: Paddings.pagePadding,
        children: [
          // team summary titles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Player'),
              Text('Points'),
            ],
          ),
          Divider(color: Colors.grey),

          // team summary rows
          getPlayerPoints(),
        ],
      ),
    );
  }

  Column getPlayerPoints() {
    List<Widget> pointsRows = _fantasy.playerNames.map((String playerName) {
      int pointsIndex = _contest.playersNames.indexOf(playerName);

      return Column(
        children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(playerName),
                    Row(children: [
                      SizedBox(width: 10),
                      Text((_contest.playersPoints != null ?
                        _contest.playersPoints[pointsIndex] : 0).toString()),
                    ]),
                  ],
                ),
              ]),
            ),
            onTap: () {},
          ),
          Divider(),
        ],
      );
    }).toList();

    return Column(children: pointsRows);
  }
}
