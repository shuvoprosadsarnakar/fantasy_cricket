import 'package:fantasy_cricket/helpers/get_number_suffix.dart';
import 'package:fantasy_cricket/helpers/get_total_chips.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/prize_images_folder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContestsListItem extends StatelessWidget {
  final Excerpt excerpt;
  final Series series;
  final bool showPrizeInfo;

  ContestsListItem(
    this.excerpt,
    this.series,
    [this.showPrizeInfo = true,]
  );
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.5,  
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: <Widget>[
          getMatchRow(),
          if(showPrizeInfo) getPrizeRow(),
        ],
      ),
    );
  }

  Row getMatchRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        getTeamImage(excerpt.teamImages[0]),
        SizedBox(width: 7),
        Expanded(child: getMatchInfo()),
        SizedBox(width: 7),
        getTeamImage(excerpt.teamImages[1]),
      ],
    );
  }

  Column getPrizeRow() {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          children: <Widget>[
            Expanded(
              child: getPrizeInfo(excerpt.totalChips, excerpt.totalWinners,
                'Match'),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5,
              ),
              width: 1,
              height: 50,
              color: Colors.grey.shade200,
            ),
            Expanded(
              child: getPrizeInfo(getTotalChips(series.chipsDistributes),
                series.chipsDistributes.last.to, 'Series'),
            ),
          ],
        ),
      ],
    );
  }

  Image getTeamImage(String imageSrc) {
    return Image.network(
      imageSrc,
      height: 30,
      width: 30,
      fit: BoxFit.contain,
    );
  }

  Column getMatchInfo() {
    return Column(
      children: <Widget>[
        // teams names
        Text(
          '${excerpt. teamsNames[0]} X ${excerpt.teamsNames[1]}',
          style: TextStyle(
            color: ColorPallate.ebonyClay,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            shadows: <Shadow>[
              Shadow(
                blurRadius: 1,
                color: ColorPallate.pomegranate,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 7),

        // match number with type
        Text(
          excerpt.no.toString() + getNumberSuffix(excerpt.no) + ' ' 
            + excerpt.type + ' Match',
          textAlign: TextAlign.center,  
        ),
        SizedBox(height: 7),

        // series name
        Text(
          series.name,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 7),

        // match starting time
        Text(
          DateFormat.yMMMd().add_jm().format(excerpt.startTime.toDate()),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Column getPrizeInfo(int chips, int winners, String prizeFor) {
    return Column(
      children: <Widget>[
        // prize images and totals
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getPrizeImage(prizeImagesFolder + 'coins.png'),
            SizedBox(width: 5),
            Text(chips.toString()),
            SizedBox(width: 10),
            getPrizeImage(prizeImagesFolder + 'winner.png'),
            SizedBox(width: 5),
            Text(winners.toString()),
          ],
        ),
        
        // prize for
        SizedBox(height: 5),
        Text(prizeFor),
      ],
    );
  }

  Image getPrizeImage(String imageSrc) {
    return Image.asset(
      imageSrc,
      width: 20,
      height: 20,
      fit: BoxFit.contain,  
    );
  }
}
