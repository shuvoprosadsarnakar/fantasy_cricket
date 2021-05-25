import 'package:fantasy_cricket/helpers/number_suffix_finder.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 1,
            height: 50,
            color: Colors.grey.shade300,
          ),
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
        thickness: 3,
        color: Colors.grey.shade300,
        height: 40,
      ),
    ]);
  }

  Image _getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 35,
      width: 35,
      fit: BoxFit.cover,
    );
  }

  Column _getMatchInfo() {
    return Column(
      children: [
        Text(
          '${_excerpt. teamsNames[0]} X ${_excerpt.teamsNames[1]}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 7),
        Text(
          '${_excerpt.no}${NumberSuffixFinder.getNumberSuffix(_excerpt.no)} '
            + '${_excerpt.type} Match',
        ),
        SizedBox(height: 7),
        Text(
          _series.name,
        ),
        SizedBox(height: 7),
        Text(
          DateFormat.yMMMd().add_jm().format(_excerpt.startTime.toDate()), 
        ),
      ],
    );
  }

  Column _getChipsAndWinnerInfo(int chips, int winners, String contestType) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/resources/images/coins.png',
            width: 31,
            height: 31,
            fit: BoxFit.cover,  
          ),
          Text(
            chips.toString(),
  
          ),
          SizedBox(width: 10),
          Image.asset(
            'lib/resources/images/winner.png',
            width: 15,
            height: 15,
            fit: BoxFit.cover, 
          ),
          SizedBox(width: 7),
          Text(
            winners.toString(), 
          ),
        ],
      ),
      SizedBox(height: 5),
      Container(
        padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5,  
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 0.7,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          contestType,
          style: TextStyle(
            fontSize: 13,
            letterSpacing: 1,
          ),
        ),
      ),
    ]);
  }
}
