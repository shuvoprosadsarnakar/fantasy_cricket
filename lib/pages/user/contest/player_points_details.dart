import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/report.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/points_calculator.dart';
import 'package:flutter/material.dart';

class PlayerPointsDetails extends StatelessWidget {
  final Contest _contest;
  final int _playerIndex;
  final Excerpt _excerpt;

  PlayerPointsDetails(
    this._contest,
    this._playerIndex,
    this._excerpt,
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player Points Details')),
      body: ListView(
        padding: Paddings.pagePadding,
        children: [
          getPlayerPointsSummary(),
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

  ClipRRect getPlayerPointsSummary() {
    int teamIndex;

    if(_playerIndex < _contest.team1TotalPlayers) {
      teamIndex = 0;
    } else {
      teamIndex = 1;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        tileColor: ColorPallate.mercury,
        title: Text(_contest.playersNames[_playerIndex]),
        subtitle: Row(
          children: [
            Image.network(
              _excerpt.teamImages[teamIndex],
              width: 20,
              height: 20,
            ),
            SizedBox(width: 5),
            Text(_contest.teamsNames[teamIndex] + ' | ' +
              _contest.playersRoles[_playerIndex]),
          ],
        ),
        trailing: Text(_contest.playersPoints[_playerIndex].toString()),
      ),
    );
  }

  Column getPointsTitles(BuildContext context, String category) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getOnePointsTitle(2, category, context),
            getOnePointsTitle(1, 'Report', context),
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
    Report report = _contest.playersReports[_playerIndex];
    int halfCenturies = (report.runsTaken % 100 >= 50) ? 1 : 0;
    int centuries = (report.runsTaken / 100).floor();
    double strikeRate = report.runsTaken / report.ballsFaced * 100;
    
    return Column(
      children: [
        getPointsRow(
          'Runs',
          report.runsTaken,
          PointsCalculator.getRunsTakenPoints(report.runsTaken),
        ),
        getPointsRow(
          'Fours',
          report.foursHit,
          PointsCalculator.getFoursHitPoints(report.foursHit),
        ),
        getPointsRow(
          'Sixes',
          report.sixesHit,
          PointsCalculator.getSixesHitPoints(report.sixesHit),
        ),
        getPointsRow(
          'Half Century',
          halfCenturies,
          PointsCalculator.getHalfCenturyPoints(halfCenturies, _excerpt.status),
        ),
        getPointsRow(
          'Century',
          centuries,
          PointsCalculator.getCenturyPoints(centuries, _excerpt.status),
        ),
        getPointsRow(
          'Strike Rate',
          strikeRate,
          PointsCalculator.getStrikeRatePoints(report.ballsBowled, strikeRate, 
            _excerpt.status),
        ),
      ],
    );
  }

  Column getPointsRow(String title, num report, double points) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
    Report report = _contest.playersReports[_playerIndex];
    int fourWickets = (report.wicketsTaken % 5 >= 4) ? 1 : 0;
    int fiveWickets = (report.wicketsTaken / 5).floor();
    double economyRate = report.runsGiven / (report.ballsBowled / 6);

    return Column(
      children: [
        getPointsRow(
          'Wickets',
          report.wicketsTaken,
          PointsCalculator.getWicketsTakenPoints(report.runsTaken, 
            _excerpt.status),
        ),
        getPointsRow(
          'Four Wickets',
          fourWickets,
          PointsCalculator.getWicketsTakenPoints(fourWickets, _excerpt.status),
        ),
        getPointsRow(
          'Five Wickets',
          fiveWickets,
          PointsCalculator.getWicketsTakenPoints(fiveWickets, _excerpt.status),
        ),
        getPointsRow(
          'Maiden Overs',
          report.maidenOvers,
          PointsCalculator.getWicketsTakenPoints(report.maidenOvers, 
            _excerpt.status),
        ),
        getPointsRow(
          'Economy Rate',
          economyRate,
          PointsCalculator.getEconomyRatePoints(report.ballsBowled, economyRate, 
            _excerpt.status),
        ),
      ],
    );
  }

  Column getFieldingPoints() {
    Report report = _contest.playersReports[_playerIndex];
    
    return Column(
      children: [
        getPointsRow(
          'Catches',
          report.catches,
          PointsCalculator.getCatchesPoints(report.catches),
        ),
        getPointsRow(
          'Stumpings',
          report.stumpings,
          PointsCalculator.getStumpingsPoints(report.catches),
        ),
        getPointsRow(
          'Run Outs',
          report.runOuts,
          PointsCalculator.getRunOutsPoints(report.runOuts),
        ),
      ],
    );
  }

  Column getOthersPoints() {
    Report report = _contest.playersReports[_playerIndex];
      
    return Column(
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text('Playing XI'),
            ),
            Expanded(
              flex: 1,
              child: Text(_contest.isPlayings[_playerIndex] ? 'Yes' : 'No'),
            ),
            Expanded(
              flex: 1,
              child: Text(PointsCalculator.getIsPlayingPoints(
                _contest.isPlayings[_playerIndex]).toString()),
            ),
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text('Player of The Match'),
            ),
            Expanded(
              flex: 1,
              child: Text(_contest.playerOfTheMatch == 
                _contest.playersNames[_playerIndex] ? 'Yes' : 'No'),
            ),
            Expanded(
              flex: 1,
              child: Text(PointsCalculator.getPlayerOfTheMatchPoints(
                _contest.playerOfTheMatch == 
                _contest.playersNames[_playerIndex]).toString()),
            ),
          ],
        ),
      ]
    );
  }
}
