import 'package:fantasy_cricket/helpers/role_image_finder.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:flutter/material.dart';

class ReviewTeam  extends StatelessWidget {
  final Contest contest;
  final Fantasy fantasy;
  final Excerpt excerpt;

  ReviewTeam(
    this.contest,
    this.fantasy,
    this.excerpt,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Team')),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: fantasy.playerNames.length,
        itemBuilder: (BuildContext context, int i) {
          return getPlayerDetailsRow(context, i);
        },
      ),
    );
  }

  Column getPlayerDetailsRow(BuildContext context, int i) {
    int playerIndex = contest.playersNames.indexOf(fantasy.playerNames[i]);
    int teamIndex = playerIndex < contest.team1TotalPlayers ? 0 : 1;
    String playerNameSuffix = '';

    if(fantasy.playerNames[i] == fantasy.captain) {
      playerNameSuffix = '(C)';
    } else if(fantasy.playerNames[i] == fantasy.viceCaptain) {
      playerNameSuffix = '(VC)';
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset(
              RoleImageFinder.getRoleImage(
                contest.playersRoles[playerIndex]),
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                fantasy.playerNames[i] + ' ' + playerNameSuffix,
                style: Theme.of(context).textTheme.subtitle1,  
              ),  
            ),
            SizedBox(width: 10),
            Image.network(
              excerpt.teamImages[teamIndex],
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
          ],
        ),

        if(fantasy.playerNames[i] != fantasy.playerNames.last) Divider(),
      ],
    );
  }
}
