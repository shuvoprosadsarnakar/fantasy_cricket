import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/series_leaderboard_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesLeaderboard extends StatelessWidget {
  final SeriesLeaderboardCubit _cubit;

  SeriesLeaderboard(this._cubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else if(state == CubitState.fetchError) {
          return FetchErrorMsg();
        } else {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Series Leaderboard'),
                bottom: TabBar(
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Ranking'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Matches'),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  getRanking(context),
                  getMatches(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  ListView getRanking(BuildContext context) {
    return ListView(
      padding: Paddings.pagePadding,
      children: [
        // ranking titles
        Row(children: [
          Expanded(
            flex: 1,
            child: Text('Rank'),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text('User'),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Text('Points'),
          ),
        ]),
        Divider(),

        // user's ranking
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Text(_cubit.seriesRank.rank.toString()),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(_cubit.seriesRank.username),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Text(_cubit.seriesRank.totalPoints.toString()),
            ),
          ]),
        ),
        Divider(color: Colors.grey),

        // all rankings needs to be set here
      ],
    );
  }

  ListView getMatches() {
    List<Widget> matchWidgets = [];
    int totalMatches = _cubit.seriesFantasies.length;
    
    for(int i = 0; i < totalMatches; i++) {
      Excerpt excerpt = _cubit.series.matchExcerpts[i];
      
      matchWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(excerpt.startTime.toDate().toString()
            .substring(0, 16))),
          SizedBox(width: 5),
          Expanded(child: Text(excerpt.no.toString() + getNoSuffix(excerpt.no) +
            ' ' + excerpt.type)),
          SizedBox(width: 5),
          Expanded(child: Text(excerpt.teamsNames[0] + ' vs ' + 
            excerpt.teamsNames[1])),
          SizedBox(width: 5),
          Expanded(child: Text(_cubit.seriesFantasies[i] != null ?
            _cubit.seriesFantasies[i].totalPoints.toString() : '-')),
          SizedBox(width: 5),
          Expanded(child: Text(_cubit.seriesFantasies[i] != null ?
            _cubit.seriesFantasies[i].rank.toString() : '-')),
        ],
      ));
      matchWidgets.add(Divider());
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Date')),
            SizedBox(width: 5),
            Expanded(child: Text('Type')),
            SizedBox(width: 5),
            Expanded(child: Text('Match')),
            SizedBox(width: 5),
            Expanded(child: Text('Points')),
            SizedBox(width: 5),
            Expanded(child: Text('Rank')),
          ],
        ),
        Divider(),
        Column(children: matchWidgets),
      ],
    );
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
}
