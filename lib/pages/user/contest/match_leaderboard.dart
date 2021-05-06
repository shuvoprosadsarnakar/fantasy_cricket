import 'package:fantasy_cricket/pages/user/contest/cubits/match_leaderboard_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/team_players_points.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchLeaderboard extends StatelessWidget {
  final MatchLeaderboardCubit _cubit;

  MatchLeaderboard(this._cubit);

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
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Match Leaderboard'),
                bottom: TabBar(
                  tabs: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Ranking'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Points'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text('Scores'),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  getRanking(context),
                  getPoints(),
                  getScores(),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  ListView getRanking(BuildContext context) {
    List<Widget> rankRows = [];
    int totalRanks = _cubit.matchFantasies.length;
    int userRank;

    for(int i = 0; i < totalRanks; i++) {
      if(_cubit.user.username == _cubit.matchFantasies[i].username) {
        userRank = i;
      }
      
      rankRows.add(InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Text((i + 1).toString()),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(_cubit.matchFantasies[i].username),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Text(_cubit.matchFantasies[i].totalPoints.toString()),
            ),
          ]),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return TeamPlayersPoints(_cubit.contest, _cubit.matchFantasies[i]);
          },
        )),
      ));
      rankRows.add(Divider());
    }

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
        InkWell(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Text((userRank + 1).toString()),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Text(_cubit.user.username),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Text(_cubit.matchFantasies[userRank].totalPoints
                  .toString()),
              ),
            ]),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return TeamPlayersPoints(
                _cubit.contest,
                _cubit.matchFantasies[userRank],
              );
            },
          )),
        ),
        Divider(color: Colors.grey),

        // all user rankings
        Column(children: rankRows),
      ],
    );
  }

  ListView getPoints() {
    List<Widget> pointsListTiles = [];
    int totalPlayers = _cubit.contest.playersNames.length;

    for(int i = 0; i < totalPlayers; i++) {
      pointsListTiles.add(ListTile(
        title: Text(_cubit.contest.playersNames[i]),
        subtitle: Text(_cubit.contest.playersRoles[i]),
        trailing: Text((_cubit.contest.playersPoints != null ?
          _cubit.contest.playersPoints[i] : 0).toString()),
        onTap: () {},
      ));
      pointsListTiles.add(Divider());
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: [
        // points titles
        ListTile(
          title: Text('Player'),
          trailing: Text('Points'),
        ),
        Divider(color: Colors.grey),

        // player points
        Column(children: pointsListTiles),
      ],
    );
  }

  ListView getScores() {
    String matchStatus;

    if(_cubit.contestStatus == 'Locked') {
      matchStatus = 'Running';
    } else if(_cubit.contestStatus == 'Upcoming' || 
      _cubit.contestStatus == 'Running') {
      matchStatus = 'Not Started';
    } else if(_cubit.contestStatus == 'Ended') {
      matchStatus = _cubit.contestStatus;
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: [
        // match scores excerpt
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(children: [
                Image.network(
                  'https://www.bing.com/th?id=AMMS_5c876f9fd7bc3055e55bc35a4ee71a26&w=110&h=110&c=7&rs=1&qlt=95&pcl=f9f9f9&cdv=1&pid=16.1',
                  width: 30,
                ),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsNames[0]),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsScores != null ? 
                  _cubit.contest.teamsScores[0] : ''),
              ]),
            ),
            SizedBox(width: 10),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(matchStatus),
                  SizedBox(height: 5),
                  Text(
                    _cubit.contest.startTime.toDate().toString()
                      .substring(0, 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),

            Expanded(
              child: Column(children: [
                Image.network(
                  'https://www.bing.com/th?id=AMMS_5c876f9fd7bc3055e55bc35a4ee71a26&w=110&h=110&c=7&rs=1&qlt=95&pcl=f9f9f9&cdv=1&pid=16.1',
                  width: 30,
                ),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsNames[1]),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsScores != null ? 
                  _cubit.contest.teamsScores[1] : ''),
              ]),
            ),
          ],
        ),
        SizedBox(height: 10),

        // match result
        Text(
          _cubit.contest.result ?? '',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
