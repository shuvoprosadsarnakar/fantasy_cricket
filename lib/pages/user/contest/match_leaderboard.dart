import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/fantasy_player_points_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/series_leaderboard_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/fantasy_player_points.dart';
import 'package:fantasy_cricket/pages/user/contest/player_points_details.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:flutter/material.dart';

class MatchLeaderboard extends StatelessWidget {
  final Contest contest;
  final Excerpt excerpt;
  final User user;

  MatchLeaderboard({
    this.contest,
    this.excerpt,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
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
            getMatchScores(),
          ],
        ),
      ),
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
    int userRankIndex = contest.ranks.indexWhere((Rank rank) {
      return user.username == rank.username;
    });
    
    return Padding(
      padding: Paddings.pagePadding,
      child: Column(
        children: [
          // ranking titles
          Row(children: [
            getRankTile(1, 'Rank', context),
            SizedBox(width: 10),
            getRankTile(3, 'User', context),
            SizedBox(width: 10),
            getRankTile(1, 'Points', context),
          ]), 
          Divider(),

          // user's ranking
          if(userRankIndex != -1) getRankRow(
            userRankIndex,
            contest.ranks[userRankIndex],
            context,
          ),
          if(userRankIndex != -1) Divider(color: Colors.grey),

          // all rankings including the user
          ListView.builder(
            shrinkWrap: true,
            itemCount: contest.ranks.length,
            itemBuilder: (BuildContext context, int i) {
              return Column(children: [
                getRankRow(i, contest.ranks[i], context),
                Divider(),
              ]);
            },
          ),
        ],
      ),
    );
  }

  Expanded getRankTile(int flex, String title, BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,  
      ),
    );
  }

  InkWell getRankRow(int rankIndex, Rank rank, BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Expanded(
            flex: 1,
            child: Text(SeriesLeaderboardCubit.getRank(rankIndex).toString()),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(rank.username),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Text(rank.totalPoints.toString()),
          ),
        ]),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return FantasyPlayerPoints(FantasyPlayerPointsCubit(
            contest,
            rank.username,
            excerpt,
          ));
        },
      )),
    );
  }

  ListView getPlayerPoints(BuildContext context) {
    List<Widget> pointsListTiles = <Widget>[];
    int totalPlayers = contest.playersNames.length;

    for(int i = 0; i < totalPlayers; i++) {
      pointsListTiles.add(ListTile(
        title: Text(contest.playersNames[i]),
        subtitle: Text(contest.playersRoles[i]),
        trailing: Text((contest.playersPoints.isNotEmpty
          ? contest.playersPoints[i] : 0).toString()),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return PlayerPointsDetails(contest, i, excerpt);
          },
        )),
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

  ListView getMatchScores() {
    String matchStatus;

    if(excerpt.status == ContestStatuses.locked) {
      matchStatus = 'Running';
    } else if(excerpt.status == ContestStatuses.ended) {
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
                  excerpt.teamImages[0],
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 5),
                Text(contest.teamsNames[0]),
                SizedBox(height: 5),
                Text(contest.teamsScores.isNotEmpty 
                  ? contest.teamsScores[0] : ''),
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
                    contest.startTime.toDate().toString().substring(0, 16),
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
                  excerpt.teamImages[1],
                  width: 40,
                  height: 40,
                ),
                SizedBox(height: 5),
                Text(contest.teamsNames[1]),
                SizedBox(height: 5),
                Text(contest.teamsScores.isNotEmpty 
                  ? contest.teamsScores[1] : ''),
              ]),
            ),
          ],
        ),
        SizedBox(height: 10),

        // match result
        Text(
          contest.result ?? '',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
