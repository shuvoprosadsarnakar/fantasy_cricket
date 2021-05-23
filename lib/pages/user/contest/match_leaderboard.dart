import 'package:fantasy_cricket/helpers/ranking_maker.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/fantasy_player_points_cubit.dart' as fppCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/match_leaderboard_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/fantasy_player_points.dart';
import 'package:fantasy_cricket/pages/user/contest/player_points_details.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchLeaderboard extends StatelessWidget {
  final MatchLeaderBoardCubit _cubit;

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
                bottom: TabBar(tabs: getTabs()),
              ),
              body: TabBarView(
                children: [
                  getUserRankings(context),
                  getPlayerPoints(context),
                  getMatchScores(context),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  List<Widget> getTabs() {
    return <Widget>[
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
    ];
  }

  Padding getUserRankings(BuildContext context) {
    int userRankIndex = _cubit.contest.ranks.indexWhere((Rank rank) {
      return _cubit.user.username == rank.username;
    });
    int userChips;

    int totalContestants = _cubit.contest.ranks.length;
    List<ListTile> rankingListTiles = <ListTile>[];

    // set [rankingListTiles]
    _cubit.contest.chipsDistributes.forEach((Distribute distribute) {
      if(userRankIndex >= RankingMaker.getDistributeFromIndex(distribute.from) 
        && userRankIndex < distribute.to) userChips = distribute.chips;
      
      for(int i = RankingMaker.getDistributeFromIndex(distribute.from); 
        i < distribute.to && i < totalContestants; i++) 
      {
        rankingListTiles.add(ListTile(
          leading: Text(RankingMaker.getRank(i).toString()),
          title: Text(_cubit.contest.ranks[i].username),
          subtitle: Text(distribute.chips.toString() + ' Chips'),
          trailing: Text(_cubit.contest.ranks[i].totalPoints.toString()),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return FantasyPlayerPoints(fppCubit.FantasyPlayerPointsCubit(
                _cubit.contest,
                _cubit.contest.ranks[i].username,
                _cubit.excerpt,
              ));
            },
          )),
        ));
      }
    });
    
    return Padding(
      padding: Paddings.pagePadding,
      child: Column(
        children: [
          // number of total contestants
          Row(
            children: [
              Icon(Icons.people),
              SizedBox(width: 10),
              Text(
                '$totalContestants Contestants',
                style: Theme.of(context).textTheme.subtitle2,  
              ),
            ],
          ),
          SizedBox(height: 30),

          // ranking titles
          Row(children: [
            getRankTitle(1, 'Rank', context),
            SizedBox(width: 10),
            getRankTitle(3, 'User', context),
            SizedBox(width: 10),
            getRankTitle(1, 'Points', context),
          ]), 
          Divider(),

          // user's ranking
          if(userRankIndex != -1) ListTile(
            leading: Text(RankingMaker.getRank(userRankIndex).toString()),
            title: Text(_cubit.contest.ranks[userRankIndex].username),
            subtitle: Text(userChips.toString() + ' Chips'),
            trailing: Text(_cubit.contest.ranks[userRankIndex].totalPoints
              .toString()),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return FantasyPlayerPoints(fppCubit.FantasyPlayerPointsCubit(
                  _cubit.contest,
                  _cubit.contest.ranks[userRankIndex].username,
                  _cubit.excerpt,
                ));
              },
            )),
          ),
          if(userRankIndex != -1) Divider(
            color: Colors.grey.shade700,
            height: 1,  
          ),

          // all rankings including the user
          ListView.builder(
            shrinkWrap: true,
            itemCount: rankingListTiles.length,
            itemBuilder: (BuildContext context, int i) {
              return Column(
                children: [
                  rankingListTiles[i],
                  Divider(height: 1),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Expanded getRankTitle(int flex, String title, BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,  
      ),
    );
  }

  ListView getPlayerPoints(BuildContext context) {
    List<Widget> pointsListTiles = <Widget>[];
    int totalPlayers = _cubit.contest.playersNames.length;

    for(int i = 0; i < totalPlayers; i++) {
      if(i == _cubit.contest.team1TotalPlayers) {
        pointsListTiles.add(SizedBox(height: 10));
        pointsListTiles.add(ListTile(
          leading: Image.network(
            _cubit.excerpt.teamImages[1],
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
          title: Text(
            _cubit.excerpt.teamsNames[1],
            style: Theme.of(context).textTheme.headline6,  
          ),
          trailing: Text(
            'Points',
            style: Theme.of(context).textTheme.subtitle2,  
          ),
        ));
        pointsListTiles.add(Divider(color: Colors.grey));
      }

      pointsListTiles.add(ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_cubit.contest.playerPhotos[i] ?? ''),
        ),
        title: Text(_cubit.contest.playersNames[i]),
        subtitle: Text(_cubit.contest.playersRoles[i]),
        trailing: Text((_cubit.contest.playersPoints.isNotEmpty
          ? _cubit.contest.playersPoints[i] : 0).toString()),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return PlayerPointsDetails(_cubit.contest, i, _cubit.excerpt);
          },
        )),
      ));

      if(i != _cubit.contest.team1TotalPlayers - 1 &&
        i != _cubit.contest.playersNames.length -1) 
        pointsListTiles.add(Divider(height: 1));
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: [
        // points titles
        ListTile(
          leading: Image.network(
            _cubit.excerpt.teamImages[0],
            width: 40,
            height: 40,
          ),
          title: Text(
            _cubit.excerpt.teamsNames[0],
            style: Theme.of(context).textTheme.headline6,  
          ),
          trailing: Text(
            'Points',
            style: Theme.of(context).textTheme.subtitle2, 
          ),
        ),
        Divider(color: Colors.grey),

        // player points
        Column(children: pointsListTiles),
      ],
    );
  }

  ListView getMatchScores(BuildContext context) {
    String matchStatus;

    if(_cubit.excerpt.status == ContestStatuses.locked) {
      matchStatus = 'Running';
    } else if(_cubit.excerpt.status == ContestStatuses.ended) {
      matchStatus = 'Ended';
    } else {
      matchStatus = 'Not Started';
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: [
        // team one's image, name and score
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(children: [
                Image.network(
                 _cubit.excerpt.teamImages[0],
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsNames[0]),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsScores.isNotEmpty 
                  ? _cubit.contest.teamsScores[0] : ''),
              ]),
            ),
            SizedBox(width: 10),
            
            // match status, date and time
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

            // team two's image, name and score
            Expanded(
              child: Column(children: [
                Image.network(
                  _cubit.excerpt.teamImages[1],
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsNames[1]),
                SizedBox(height: 5),
                Text(_cubit.contest.teamsScores.isNotEmpty 
                  ? _cubit.contest.teamsScores[1] : ''),
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
        SizedBox(height: 20),

        TextButton(
          child: Text(
            'Full Score',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,  
            ),  
          ),
          onPressed: () async {
            await _cubit.launchFullScoreUrl();
            
            if(_cubit.state == CubitState.launchFailed) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Full score not available right now.'),
              ));
            }
          },
        ),
      ],
    );
  }
}
