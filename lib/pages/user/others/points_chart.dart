import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:flutter/material.dart';

class PointsChart extends StatelessWidget {
  final BoxDecoration titlesRowDecoration 
    = BoxDecoration(color: ColorPallate.mercury);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Points Chart')),
      body: ListView(
        padding: Paddings.pagePadding,
        children: <Widget>[
          getBattingPointsChart(),
          SizedBox(height: 20),
          getBattingStrikeRatePointsChart(),
          SizedBox(height: 20),
          getBowlingPointsChart(),
          SizedBox(height: 20),
          getEconomyRatePoints(),
          SizedBox(height: 20),
          getFieldingPointsChart(),
          SizedBox(height: 20),
          getOthersPointsChart(),
        ],
      ),
    );
  }

  Padding getTableColumn(String text, {TextStyle textStyle}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Padding getTitleColumn(String title) {
    return getTableColumn(
      title,
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Table getTable(List<TableRow> tableRows) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(),
      children: tableRows,
    );
  }

  Table getBattingPointsChart() {
    return getTable(<TableRow>[
      TableRow(
        decoration: titlesRowDecoration,
        children: <Widget>[
          getTitleColumn('Batting'),
          getTitleColumn('T20'),
          getTitleColumn('ODI'),
          getTitleColumn('Test'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Run'),
          getTableColumn('0.5'),
          getTableColumn('0.5'),
          getTableColumn('0.5'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Four'),
          getTableColumn('0.5'),
          getTableColumn('0.5'),
          getTableColumn('0.5'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Six'),
          getTableColumn('1'),
          getTableColumn('1'),
          getTableColumn('1'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Half Century'),
          getTableColumn('4'),
          getTableColumn('2'),
          getTableColumn('2'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Per Century'),
          getTableColumn('8'),
          getTableColumn('4'),
          getTableColumn('4'),
        ],
      ),
    ]);
  }

  Table getBattingStrikeRatePointsChart() {
    return getTable(<TableRow>[
      TableRow(
        decoration: titlesRowDecoration,
        children: <Widget>[
          getTitleColumn('Batting Strike Rate'),
          getTitleColumn('T20'),
          getTitleColumn('ODI'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Minimum Balls Faced'),
          getTableColumn('10'),
          getTableColumn('20'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Breakdown'),
          getTableColumn('below 51: -3\n\n51 to 60: -2\n\n61 to 70: -1'),
          getTableColumn('below 41: -3\n\n41 to 50: -2\n\n51 to 60: -1'),
        ],
      ),
    ]);
  }

  Table getBowlingPointsChart() {
    return getTable(<TableRow>[
      TableRow(
        decoration: titlesRowDecoration,
        children: <Widget>[
          getTitleColumn('Bowling'),
          getTitleColumn('T20'),
          getTitleColumn('ODI'),
          getTitleColumn('Test'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Per Wicket'),
          getTableColumn('10'),
          getTableColumn('12'),
          getTableColumn('10'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Four Wickets'),
          getTableColumn('4'),
          getTableColumn('2'),
          getTableColumn('2'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Per Five Wickets'),
          getTableColumn('8'),
          getTableColumn('4'),
          getTableColumn('4'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Per Maiden Over'),
          getTableColumn('4'),
          getTableColumn('2'),
          getTableColumn('n/a'),
        ],
      ),
    ]);
  }

  Table getEconomyRatePoints() {
    return getTable(<TableRow>[
      TableRow(
        decoration: titlesRowDecoration,
        children: <Widget>[
          getTitleColumn('Economy Rate'),
          getTitleColumn('T20'),
          getTitleColumn('ODI'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Minimum Overs'),
          getTableColumn('10'),
          getTableColumn('20'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Breakdown'),
          getTableColumn('below 5: 3\n\n5: 2\n\n6 to 7: 1\n\n 8 to 9: -1\n\n'
            + '10 to 11: -2\n\nabove 11: -3'),
          getTableColumn('below 2.6: 3\n\n2.6 to 3.5: 2\n\n3.6 to 4.5: 1\n\n' 
            + '7 to 8: -1\n\n 8.1 to 9: -2\n\nabove 9: -3'),
        ],
      ),
    ]);
  }

  Table getFieldingPointsChart() {
    return getTable(<TableRow>[
      TableRow(
        decoration: titlesRowDecoration,
        children: <Widget>[
          getTitleColumn('Fielding'),
          getTitleColumn('T20'),
          getTitleColumn('ODI'),
          getTitleColumn('Test'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Catch'),
          getTableColumn('4'),
          getTableColumn('4'),
          getTableColumn('4'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Stumping'),
          getTableColumn('6'),
          getTableColumn('6'),
          getTableColumn('6'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Run Out'),
          getTableColumn('4'),
          getTableColumn('4'),
          getTableColumn('4'),
        ],
      ),
    ]);
  }

  Table getOthersPointsChart() {
    return getTable(<TableRow>[
      TableRow(
        decoration: titlesRowDecoration,
        children: <Widget>[
          getTitleColumn('Others'),
          getTitleColumn('T20'),
          getTitleColumn('ODI'),
          getTitleColumn('Test'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Playing XI'),
          getTableColumn('2'),
          getTableColumn('2'),
          getTableColumn('2'),
        ],
      ),
      TableRow(
        children: <Widget>[
          getTableColumn('Man of The Match'),
          getTableColumn('10'),
          getTableColumn('10'),
          getTableColumn('10'),
        ],
      ),
    ]);
  }
}
