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
          Expanded(child: _getMatchInfo()),
          SizedBox(width: 10),
          _getTeamImage(_excerpt.teamImages[1]),
        ],
      ),
      SizedBox(height: 15),      
      Row(
        children: [
          Expanded(
            child: _getChipsAndWinnerInfo(
              _excerpt.totalChips,
              _excerpt.totalWinners,
              'Match',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _getChipsAndWinnerInfo(
              _seriesTotalChips,
              _series.chipsDistributes.last.to,
              'Series',
            ),
          ),
        ],
      ),
      Divider(
        thickness: 2,
        color: Colors.grey.shade300,
        height: 40,
      ),
    ]);
  }

  Image _getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 40,
      width: 40,
      fit: BoxFit.cover,
    );
  }

  Column _getMatchInfo() {
    return Column(
      children: [
        Text(
          '${_excerpt. teamsNames[0]} vs ${_excerpt.teamsNames[1]}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 7),
        Text('${_excerpt.no}${getNoSuffix(_excerpt.no)} ' 
          + '${_excerpt.type} Match'),
        SizedBox(height: 7),
        Text(
          _series.name,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 7),
        Text('${_excerpt.startTime.toDate().toString().substring(0, 16)}'),
      ],
    );
  }

  static String getNoSuffix(int no) {
    switch(no) {
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
          Image.asset(
            'lib/resources/images/coins.png',
            width: 40,
            height: 40,  
          ),
          Text(chips.toString()),
          SizedBox(width: 10),
          Image.asset(
            'lib/resources/images/winner.png',
            width: 20,
            height: 20,  
          ),
          SizedBox(width: 5),
          Text(winners.toString()),
        ],
      ),
      SizedBox(height: 5),
      Container(
        padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 10,  
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(contestType),
      ),
    ]);
  }
}
