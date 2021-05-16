import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:flutter/material.dart';

class ContestsListItem extends StatelessWidget {
  final Excerpt _excerpt;
  final Series _series;
  final int _seriesTotalChips;

  ContestsListItem(
    this._excerpt,
    this._series,
    this._seriesTotalChips,
  );
  
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getTeamImage(_excerpt.teamImages[0]),
          SizedBox(width: 10),
          _getMatchInfo(),
          SizedBox(width: 10),
          _getTeamImage(_excerpt.teamImages[1]),
        ],
      ),
      
      Divider(),
      
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getChipsAndWinnerInfo(
            _excerpt.totalChips,
            _excerpt.totalWinners,
            'Match',
          ),
          _getChipsAndWinnerInfo(
            _seriesTotalChips,
            _series.chipsDistributes.last.to,
            'Series',
          ),
        ],
      ),

      Divider(color: Theme.of(context).primaryColor),
    ]);
  }

  Image _getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 50,
      width: 50,
    );
  }

  Column _getMatchInfo() {
    return Column(children: [
      Text(
        '${_excerpt. teamsNames[0]} vs ${_excerpt.teamsNames[1]}',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      SizedBox(height: 5),
      Text('${_excerpt.no}${getNoSuffix(_excerpt.no)} ${_excerpt.type} Match'),
      SizedBox(height: 5),
      Row(
        children: [
          Image.network(
            _series.photo,
            width: 30,
            height: 30,
          ),
          SizedBox(width: 10),
          Text(_series.name),
        ],
      ),
      SizedBox(height: 5),
      Text('${_excerpt.startTime.toDate().toString().substring(0, 16)}'),
    ]);
  }

  static String getNoSuffix(int no) {
    switch(no % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
       return 'rd';
      default:
        return 'th';
    }
  }

  Column _getChipsAndWinnerInfo(int chips, int winners, String contestType) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.money),
          SizedBox(width: 5),
          Text(chips.toString()),
          SizedBox(width: 5),
          Text('|'),
          SizedBox(width: 5),
          Icon(Icons.person),
          SizedBox(width: 5),
          Text(winners.toString()),
        ],
      ),
      SizedBox(height: 5),
      Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Text(contestType),
      ),
    ]);
  }
}
