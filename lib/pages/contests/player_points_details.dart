import 'package:fantasy_cricket/helpers/get_role_image.dart';
import 'package:fantasy_cricket/pages/contests/cubits/player_points_details_cubit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class PlayerPointsDetails extends StatelessWidget {
  final PlayerPointsDetailsCubit cubit;

  PlayerPointsDetails(this.cubit);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Points Details'),
      ),
      body: ListView(
        padding: Paddings.pagePadding,
        children: <Widget>[
          getPlayerPointsSummary(context),
          SizedBox(height: 30),

          getPointsTitles(context, 'Batting'),
          getBattingPoints(),
          SizedBox(height: 20),

          getPointsTitles(context, 'Bowling'),
          getBowlingPoints(),
          SizedBox(height: 20),

          getPointsTitles(context, 'Fielding'),
          getFieldingPoints(),
          SizedBox(height: 20),

          getPointsTitles(context, 'Others'),
          getOthersPoints(),
        ],
      ),
    );
  }

  ClipRRect getPlayerPointsSummary(BuildContext context) {
    int teamIndex;

    if(cubit.playerIndex < cubit.contest.team1TotalPlayers) {
      teamIndex = 0;
    } else {
      teamIndex = 1;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        minVerticalPadding: 10,
        tileColor: ColorPallate.mercury,
        title: Text(
          cubit.contest.playersNames[cubit.playerIndex],
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        subtitle: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                Image.network(
                  cubit.excerpt.teamImages[teamIndex],
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(cubit.contest.teamsNames[teamIndex]),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: <Widget>[
                Image.asset(
                  getRoleImage(cubit.contest.playersRoles[cubit.playerIndex]),
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(cubit.contest.playersRoles[cubit.playerIndex]),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Points'),
            SizedBox(height: 5),
            Text((cubit.contest.playersPoints.isNotEmpty ?
              cubit.contest.playersPoints[cubit.playerIndex] : 0).toString()),
          ],
        ),
      ),
    );
  }

  Column getPointsTitles(BuildContext context, String category) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            getOnePointsTitle(2, category, context),
            getOnePointsTitle(1, 'Score', context),
            getOnePointsTitle(1, 'Points', context),
          ],
        ),
        Divider(color: Colors.grey),
      ],
    );
  }

  Expanded getOnePointsTitle(int flex, String title, BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  Column getBattingPoints() {    
    return Column(
      children: <Widget>[
        getPointsRow('Runs', cubit.report.runsTaken, cubit.runsTakenPoints),
        getPointsRow('Fours', cubit.report.foursHit, cubit.foursHitPoints),
        getPointsRow('Sixes', cubit.report.sixesHit, cubit.sixesHitPoints),
        getPointsRow('Half Century', cubit.halfCenturies, 
          cubit.halfCenturyPoints),
        getPointsRow('Century', cubit.centuries, cubit.centuryPoints),
        getPointsRow('Strike Rate', cubit.strikeRate, cubit.strikeRatePoints),
      ],
    );
  }

  Column getPointsRow(String title, num report, double points) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(title),
            ),
            Expanded(
              flex: 1,
              child: Text(report.toString()),
            ),
            Expanded(
              flex: 1,
              child: Text(points.toString()),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Column getBowlingPoints() {
    return Column(
      children: <Widget>[
        getPointsRow('Wickets', cubit.report.wicketsTaken, 
          cubit.wicketsTakenPoints),
        getPointsRow('Four Wickets', cubit.fourWickets, 
          cubit.fourWicketsPoints),
        getPointsRow('Five Wickets', cubit.fiveWickets,
          cubit.fiveWicketsPoints),
        getPointsRow('Maiden Overs', cubit.report.maidenOvers,
          cubit.maidenOversPoints),
        getPointsRow('Economy Rate', cubit.economyRate,
          cubit.economyRatePoints),
      ],
    );
  }

  Column getFieldingPoints() {
    return Column(
      children: <Widget>[
        getPointsRow('Catches', cubit.report.catches, cubit.catchesPoints),
        getPointsRow('Stumpings', cubit.report.stumpings, 
          cubit.stumpingsPoints),
        getPointsRow('Run Outs', cubit.report.runOuts, cubit.runOutsPoints),
      ],
    );
  }

  Column getOthersPoints() {
    return Column(
      children: <Widget>[
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text('Playing XI'),
            ),
            Expanded(
              flex: 1,
              child: Text(cubit.contest.isPlayings[cubit.playerIndex] 
                ? 'Yes' : 'No'),
            ),
            Expanded(
              flex: 1,
              child: Text(cubit.isPlayingPoints.toString()),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text('Player of The Match'),
            ),
            Expanded(
              flex: 1,
              child: Text(cubit.contest.playerOfTheMatch == 
                cubit.contest.playersNames[cubit.playerIndex] ? 'Yes' : 'No'),
            ),
            Expanded(
              flex: 1,
              child: Text(cubit.playerOfTheMatchPoints.toString()),
            ),
          ],
        ),
        Divider(),
      ]
    );
  }
}
