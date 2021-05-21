import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/report.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/helpers/points_calculator.dart';
import 'package:flutter/material.dart';

class PlayerPointsDetails extends StatelessWidget {
  final Contest _contest;
  final int _playerIndex;
  final Excerpt _excerpt;
  
  Report report = Report();
  int halfCenturies = 0;
  int centuries = 0;
  double strikeRate = 0;
  int fourWickets = 0;
  int fiveWickets = 0;
  double economyRate = 0;

  PlayerPointsDetails(this._contest, this._playerIndex, this._excerpt) {
    if(_contest.playersReports.isNotEmpty) {
      report = _contest.playersReports[_playerIndex];
      halfCenturies = PointsCalculator.getHalfCenturies(report.runsTaken);
      centuries = PointsCalculator.getCenturies(report.runsTaken);
      strikeRate 
        = PointsCalculator.getStrikeRate(report.ballsFaced, report.runsTaken);
      fourWickets = PointsCalculator.getFourWickets(report.wicketsTaken);
      fiveWickets = PointsCalculator.getFiveWickets(report.wicketsTaken);
      economyRate 
        = PointsCalculator.getEconomyRate(report.ballsBowled, report.runsGiven);
    }
  }
  
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
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_contest.playerPhotos[_playerIndex] ?? ''),
        ),
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
            Expanded(
              child: Text(
                _contest.teamsNames[teamIndex] + ' | ' +
                  _contest.playersRoles[_playerIndex],
                style: TextStyle(fontSize: 12),    
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Points'),
            Text((_contest.playersPoints.isNotEmpty ?
              _contest.playersPoints[_playerIndex] : 0).toString()),
          ],
        ),
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
          PointsCalculator.getHalfCenturyPoints(report.runsTaken, 
            _excerpt.type),
        ),
        getPointsRow(
          'Century',
          centuries,
          PointsCalculator.getCenturyPoints(report.runsTaken, _excerpt.type),
        ),
        getPointsRow(
          'Strike Rate',
          strikeRate,
          PointsCalculator.getStrikeRatePoints(report.ballsFaced, 
            report.runsTaken, _excerpt.type),
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
    return Column(
      children: [
        getPointsRow(
          'Wickets',
          report.wicketsTaken,
          PointsCalculator.getWicketsTakenPoints(report.wicketsTaken, 
            _excerpt.type),
        ),
        getPointsRow(
          'Four Wickets',
          fourWickets,
          PointsCalculator.getFourWicketsPoints(report.wicketsTaken, 
            _excerpt.type),
        ),
        getPointsRow(
          'Five Wickets',
          fiveWickets,
          PointsCalculator.getFiveWicketsPoints(report.wicketsTaken, 
            _excerpt.type),
        ),
        getPointsRow(
          'Maiden Overs',
          report.maidenOvers,
          PointsCalculator.getMaidenOversPoints(report.maidenOvers, 
            _excerpt.type),
        ),
        getPointsRow(
          'Economy Rate',
          economyRate,
          PointsCalculator.getEconomyRatePoints(report.ballsBowled, 
            report.runsGiven, _excerpt.type),
        ),
      ],
    );
  }

  Column getFieldingPoints() {
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
          PointsCalculator.getStumpingsPoints(report.stumpings),
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
              child: Text(_contest.isPlayings[_playerIndex] ? 
                'Yes' : 'No'),
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
