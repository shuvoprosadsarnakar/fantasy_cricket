import 'package:fantasy_cricket/helpers/get_number_suffix.dart';
import 'package:fantasy_cricket/helpers/get_user_rank.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/pages/contests/cubits/'
       'match_leaderboard_cubit.dart' as mlCubit;
import 'package:fantasy_cricket/pages/contests/cubits/'
       'series_leaderboard_cubit.dart';
import 'package:fantasy_cricket/pages/contests/match_leaderboard.dart';
import 'package:fantasy_cricket/resources/match_types.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_or_message.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:fantasy_cricket/widgets/ranking_titles.dart';
import 'package:fantasy_cricket/widgets/total_contestants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SeriesLeaderboard extends StatelessWidget {
  final SeriesLeaderboardCubit cubit;

  SeriesLeaderboard(this.cubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesLeaderboardCubit, CubitState>(
      bloc: cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else if(state == CubitState.fetchError) {
          return FetchErrorOrMessage();
        } else {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Series Leaderboard'),
              ),
              body: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 110,
                  title: getSeriesInfo(),
                  bottom: getTabBar(),
                ),
                body: TabBarView(
                  children: <Widget>[
                    getRanking(context),
                    getMatches(context),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('Ranking'),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text('Matches'),
        ),
      ],
    );
  }

  ListView getRanking(BuildContext context) {
    int userChips;
    final int userRankIndex = cubit.series.ranks.indexWhere((Rank rank) {
      return cubit.username == rank.username;
    });
    final int userRank = getUserRank(userRankIndex);
    final int totalContestants = cubit.series.ranks.length;
    final List<Widget> rankingListTiles = <Widget>[];

    // set [rankingListTiles]
    cubit.series.chipsDistributes.forEach((Distribute distribute) {
      if(userRank >= distribute.from && userRank <= distribute.to) {
        userChips = distribute.chips;
      }
      
      for(int i = distribute.from - 1; 
        i < distribute.to && i < totalContestants; i++) {
        rankingListTiles.add(getRankingListTile(i, distribute.chips));
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
            getRankingListTile(userRankIndex, userChips),
            Divider(
              color: Colors.grey.shade700,
              height: 1,  
            ),
          ],
        ),

        // all rankings including the user
        Column(children: rankingListTiles),
      ],
    );
  }

  ListTile getRankingListTile(int rankIndex,  int chips) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      minVerticalPadding: 0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(getUserRank(rankIndex).toString()),
      ),
      title: Text(cubit.series.ranks[rankIndex].username),
      subtitle: Text(chips.toString() + ' Chips'),
      trailing: Text(cubit.series.ranks[rankIndex].totalPoints.toString()),
    );
  }

  ListView getMatches(BuildContext context) {
    final List<Widget> matchList = <Widget>[];
    final int totalMatches = cubit.series.matchExcerpts.length;
    
    for(int i = 0; i < totalMatches; i++) {
      final Excerpt excerpt = cubit.series.matchExcerpts[i];
      
      matchList.add(InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // teams names & images
            getTeamNameAndImage(excerpt, 0),
            SizedBox(height: 5),
            getTeamNameAndImage(excerpt, 1),
            SizedBox(height: 5),
            
            // match type and number
            Text(
              excerpt.no.toString() + getNumberSuffix(excerpt.no) + ' ' 
                + excerpt.type,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 5),
            
            // match date
            Text(DateFormat.yMMMd().add_jm().format(excerpt.startTime
              .toDate())),
            SizedBox(height: 5),
            
            // user's achived points
            Text('Points Achived ' + (cubit.userContestRanks[i] != null ? 
              cubit.userContestRanks[i].totalPoints.toString() : '-')),
            SizedBox(height: 5),
            
            // user's rank
            Text('Ranked ' + (cubit.userContestRanks[i] != null ? 
              (cubit.userContestRanks.indexOf(cubit.userContestRanks[i]) + 1)
              .toString() : '-')),
            SizedBox(height: 5),
          ],
        ), 
        onTap: () {
          if(excerpt.id != null) {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MatchLeaderboard(mlCubit.MatchLeaderBoardCubit(excerpt,
                  cubit.username));
              },
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('The contest hasn\'t started yet.'),
            ));
          }
        },
      ));
      
      if(i != totalMatches - 1) matchList.add(Divider());
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: matchList,
    );
  }

  Row getTeamNameAndImage(Excerpt excerpt, int teamIndex) {
    return Row(
      children: <Widget>[
        Image.network(
          excerpt.teamImages[teamIndex],
          width: 20,
          height: 20,
          fit: BoxFit.contain
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(excerpt.teamsNames[teamIndex]),
        ),
      ],
    );
  }

  Column getSeriesInfo() {
    int totalT20s = 0;
    int totalOneDays = 0;
    int totalTests = 0;

    cubit.series.matchExcerpts.forEach((Excerpt excerpt) {
      switch(excerpt.type) {
        case T20: totalT20s++; break;
        case ONE_DAY: totalOneDays++; break;
        case TEST: totalTests++; break;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            if(cubit.series.photo.isNotEmpty) Image.network(
              cubit.series.photo,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                cubit.series.name,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          'T20: $totalT20s | One Day: $totalOneDays | Test: $totalTests',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
