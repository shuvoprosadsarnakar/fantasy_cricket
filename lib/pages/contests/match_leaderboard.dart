import 'package:fantasy_cricket/helpers/get_role_image.dart';
import 'package:fantasy_cricket/helpers/get_user_rank.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/pages/contests/cubits/'
       'fantasy_player_points_cubit.dart' as fppCubit;
import 'package:fantasy_cricket/pages/contests/cubits/'
       'match_leaderboard_cubit.dart';
import 'package:fantasy_cricket/pages/contests/cubits/'
       'player_points_details_cubit.dart';
import 'package:fantasy_cricket/pages/contests/fantasy_player_points.dart';
import 'package:fantasy_cricket/pages/contests/player_points_details.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:fantasy_cricket/widgets/fetch_error_or_message.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:fantasy_cricket/widgets/ranking_titles.dart';
import 'package:fantasy_cricket/widgets/total_contestants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchLeaderboard extends StatelessWidget {
  final MatchLeaderBoardCubit cubit;

  MatchLeaderboard(this.cubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchLeaderBoardCubit, CubitState>(
      bloc: cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else if(state == CubitState.fetchError) {
          return FetchErrorOrMessage();
        } else {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Match Leaderboard'),
                bottom: TabBar(
                  tabs: getTabs(),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  getRanking(context),
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

  ListView getRanking(BuildContext context) {
    int userChips;
    final int userRankIndex = cubit.contest.ranks.indexWhere((Rank rank) {
      return cubit.username == rank.username;
    });
    final int userRank = getUserRank(userRankIndex);
    final int totalContestants = cubit.contest.ranks.length;
    final List<Widget> rankingListTiles = <Widget>[];

    // set [rankingListTiles]
    cubit.contest.chipsDistributes.forEach((Distribute distribute) {
      if(userRank >= distribute.from && userRank <= distribute.to) {
        userChips = distribute.chips;
      }

      for(int i = distribute.from - 1; 
        i < distribute.to && i < totalContestants; i++) {
        rankingListTiles.add(getRankingListTile(i, distribute.chips, context));
        rankingListTiles.add(Divider(height: 1));
      }
    });
    
    return ListView(
      padding: Paddings.pagePadding,
      children: <Widget>[
        // number of total contestants
        TotalContestants(totalContestants),
        SizedBox(height: 10),

        // ranking titles
        RankingTitles(),
        Divider(height: 1),

        // user's ranking
        if(userRank != 0) Column(
          children: <Widget>[
            getRankingListTile(userRankIndex, userChips, context),
            Divider(
              color: Colors.grey.shade700,
              height: 1,
            ),
          ],
        ),

        // all contestants ranking
        Column(children: rankingListTiles),
      ],
    );
  }

  ListTile getRankingListTile(int rankIndex, int chips, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      minVerticalPadding: 0,
      leading: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(getUserRank(rankIndex).toString()),
      ),
      title: Text(cubit.contest.ranks[rankIndex].username),
      subtitle: Text(chips.toString() + ' Chips'),
      trailing: Text(cubit.contest.ranks[rankIndex].totalPoints.toString()),
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return FantasyPlayerPoints(fppCubit.FantasyPlayerPointsCubit(
            cubit.contest,
            cubit.contest.ranks[rankIndex].username,
            cubit.excerpt,
          ));
        },
      )),
    );
  }

  ListView getPlayerPoints(BuildContext context) {
    final List<Widget> pointsListTiles = <Widget>[];
    final int totalPlayers = cubit.contest.playersNames.length;

    for(int i = 0; i < totalPlayers; i++) {
      if(i == cubit.contest.team1TotalPlayers) {
        pointsListTiles.add(SizedBox(height: 20));
        pointsListTiles.add(getPlayerPointsTeamInfo(1, context));
        pointsListTiles.add(Divider(color: Colors.grey.shade700));
      }

      pointsListTiles.add(ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(cubit.contest.playersNames[i]),
        subtitle: Row(
          children: <Widget>[
            Image.asset(
              getRoleImage(cubit.contest.playersRoles[i]),
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(cubit.contest.playersRoles[i]),
            ),
          ],
        ),
        trailing: Text((cubit.contest.playersPoints.isNotEmpty
          ? cubit.contest.playersPoints[i] : 0).toString()),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return PlayerPointsDetails(PlayerPointsDetailsCubit(
              cubit.contest, i, cubit.excerpt));
          },
        )),
      ));

      if(i != cubit.contest.team1TotalPlayers - 1 &&
        i != cubit.contest.playersNames.length -1) 
        pointsListTiles.add(Divider(height: 1));
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: <Widget>[
        getPlayerPointsTeamInfo(0, context),
        Divider(color: Colors.grey.shade700),
        Column(children: pointsListTiles),
      ],
    );
  }

  ListTile getPlayerPointsTeamInfo(int teamIndex, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.network(
        cubit.excerpt.teamImages[teamIndex],
        width: 35,
        height: 35,
        fit: BoxFit.contain,
      ),
      title: Text(
        cubit.excerpt.teamsNames[teamIndex],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).primaryColor,
        ),  
      ),
      trailing: Text(
        'Points',
        style: Theme.of(context).textTheme.subtitle2,  
      ),
    );
  }

  ListView getMatchScores(BuildContext context) {
    String matchStatus;

    if(cubit.excerpt.status == ContestStatuses.locked) {
      matchStatus = 'Running';
    } else if(cubit.excerpt.status == ContestStatuses.ended) {
      matchStatus = 'Ended';
    } else {
      matchStatus = 'Not Started';
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // team one's image, name and score
            Expanded(child: getTeamScore(context, 0)),
            SizedBox(width: 10),
            
            // match status, date and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(matchStatus),
                  SizedBox(height: 5),
                  Text(
                    DateFormat.yMMMd().add_jm().format(cubit.contest.startTime
                      .toDate()),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),

            // team two's image, name and score
            Expanded(child: getTeamScore(context, 1)),
          ],
        ),
        SizedBox(height: 10),

        // match result
        Text(
          cubit.contest.result ?? '',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),

        TextButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Text(
            'Full Score',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,  
            ),  
          ),
          onPressed: () async {
            if(await canLaunch(cubit.contest.fullScoreUrl)) {
              await launch(
                cubit.contest.fullScoreUrl,
                forceWebView: true,
                enableJavaScript: true,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Full score isn\'t available right now.'),
              ));
            }
          },
        ),
      ],
    );
  }

  Column getTeamScore(BuildContext context, int teamIndex) {
    return Column(
      children: <Widget>[
        Image.network(
          cubit.excerpt.teamImages[teamIndex],
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 5),
        Text(
          cubit.contest.teamsNames[teamIndex],
          style: Theme.of(context).textTheme.subtitle2,  
        ),
        SizedBox(height: 5),
        Text(cubit.contest.teamsScores.isNotEmpty 
          ? cubit.contest.teamsScores[teamIndex] : ''),
      ],
    );
  }
}
