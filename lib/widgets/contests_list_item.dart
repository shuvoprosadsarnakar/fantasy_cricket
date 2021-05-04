import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:flutter/material.dart';

class ContestsListItem extends StatelessWidget {
  final Excerpt _excerpt;
  final Series _series;

  ContestsListItem(
    this._excerpt,
    this._series,
  );
  
  @override
  Widget build(BuildContext context) {
    int seriesTotalChips = 0;
    int seriesTotalWinners = _series.chipsDistributes.last.to;

    _series.chipsDistributes.forEach((Distribute distribute) {
      seriesTotalChips += distribute.chips;
    });

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getTeamImage('https://www.bing.com/th?id=AMMS_5c876f9fd7bc3055e55bc35a4ee71a26&w=110&h=110&c=7&rs=1&qlt=95&pcl=f9f9f9&cdv=1&pid=16.1'),
          SizedBox(width: 10),
          getMatchInfo(),
          SizedBox(width: 10),
          getTeamImage('https://www.bing.com/th?id=AMMS_b161ce1c295b4dc5cced0a19bc9d156c&w=110&h=110&c=7&rs=1&qlt=95&pcl=f9f9f9&cdv=1&pid=16.1'),
        ],
      ),
      
      Divider(),
      
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getChipsAndWinnerInfo(
            _excerpt.totalChips,
            _excerpt.totalWinners,
            'Match',
          ),
          getChipsAndWinnerInfo(
            seriesTotalChips,
            seriesTotalWinners,
            'Series',
          ),
        ],
      ),

      Divider(color: Theme.of(context).primaryColor),
    ]);
  }

  Image getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 50,
      width: 50,
    );
  }

  Column getMatchInfo() {
    return Column(children: [
      Text(
        '${_excerpt. teamsNames[0]} vs ${_excerpt.teamsNames[1]}',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      SizedBox(height: 5),
      Text('${_excerpt.no}${getNoSuffix(_excerpt.no)} Match'),
      SizedBox(height: 5),
      Text(_series.name),
      SizedBox(height: 5),
      Text('${_excerpt.startTime.toDate().toString().substring(0, 16)}'),
    ]);
  }

  String getNoSuffix(int no) {
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

  Column getChipsAndWinnerInfo(int chips, int winners, String contestType) {
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
