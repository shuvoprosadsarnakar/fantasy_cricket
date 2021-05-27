import 'package:fantasy_cricket/helpers/number_suffix_finder.dart';
import 'package:fantasy_cricket/helpers/ranking_maker.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/match_leaderboard_cubit.dart' as mlCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/series_leaderboard_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/match_leaderboard.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
              appBar: AppBar(title: Text('Series Leaderboard')),
              body: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 110,
                  title: getSeriesInfo(),
                  bottom: TabBar(
                    tabs: [
                      Padding(
                        padding: EdgeInsets.all(10),
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

  ListView getRanking(BuildContext context) {
    int userRankIndex = _cubit.series.ranks.indexWhere((Rank rank) {
      return _cubit.user.username == rank.username;
    });
    int userChips;

    int totalContestants = _cubit.series.ranks.length;
    List<Widget> rankingListTiles = <Widget>[];

    // set [rankingListTiles]
    _cubit.series.chipsDistributes.forEach((Distribute distribute) {
      if(userRankIndex >= RankingMaker.getDistributeFromIndex(distribute.from) 
        && userRankIndex < distribute.to) userChips = distribute.chips;
      
      for(int i = RankingMaker.getDistributeFromIndex(distribute.from); 
        i < distribute.to && i < totalContestants; i++) 
      {
        rankingListTiles.add(ListTile(
          contentPadding: EdgeInsets.all(0),
          minVerticalPadding: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(RankingMaker.getRank(i).toString()),
          ),
          title: Text(_cubit.series.ranks[i].username),
          subtitle: Text(distribute.chips.toString() + ' Chips'),
          trailing: Text(_cubit.series.ranks[i].totalPoints.toString()),
        ));
        rankingListTiles.add(Divider(height: 1));
      }
    });

    return ListView(
      padding: Paddings.pagePadding,
      children: [
        // number of total contestants
        Row(
          children: [
            Icon(
              Icons.people,
              color: Theme.of(context).primaryColor,  
            ),
            SizedBox(width: 5),
            Text(
              ' ${_cubit.series.ranks.length} Contestants',
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center, 
            ),
          ],
        ),
        SizedBox(height: 10),

        // ranking titles
        ListTile(
          contentPadding: EdgeInsets.all(0),
          minVerticalPadding: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: getRankTitle('Rank'),
          ),
          title: getRankTitle('User'),
          trailing: getRankTitle('Points'),
        ),
        Divider(height: 1),

        // user's ranking
        if(userRankIndex != -1) ListTile(
          contentPadding: EdgeInsets.all(0),
          minVerticalPadding: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(RankingMaker.getRank(userRankIndex).toString()),
          ),
          title: Text(_cubit.series.ranks[userRankIndex].username),
          subtitle: Text(userChips.toString() + ' Chips'),
          trailing: Text(_cubit.series.ranks[userRankIndex].totalPoints
            .toString()),
        ),
        if(userRankIndex != -1) Divider(
          color: Colors.grey.shade700,
          height: 1,  
        ),

        // all rankings including the user
        Column(children: rankingListTiles),
      ],
    );
  }

  Text getRankTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
      ),  
    );
  }

  ListView getMatches(BuildContext context) {
    List<Widget> matchWidgets = <Widget>[];
    int totalMatches = _cubit.series.matchExcerpts.length;
    
    for(int i = 0; i < totalMatches; i++) {
      Excerpt excerpt = _cubit.series.matchExcerpts[i];
      
      matchWidgets.add(InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // first team's name & image
            Row(
              children: [
                Image.network(
                  excerpt.teamImages[0],
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 5),
                Expanded(child: Text(excerpt.teamsNames[0])),
              ],
            ),
            SizedBox(height: 5),

            // second team's name & image
            Row(
              children: [
                Image.network(
                  excerpt.teamImages[1],
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 5),
                Expanded(child: Text(excerpt.teamsNames[1])),
              ],
            ),
            SizedBox(height: 5),
            
            // match type and number
            Text(
              excerpt.no.toString()
              + NumberSuffixFinder.getNumberSuffix(excerpt.no) + ' ' 
              + excerpt.type,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 5),
            // match date
            Text(DateFormat.yMMMd().add_jm().format(excerpt.startTime
              .toDate())),
            SizedBox(height: 5),
            // user's achived points
            Text('Points Achived ' + (_cubit.userContestRanks[i] != null ? 
              _cubit.userContestRanks[i].totalPoints.toString() : '-')),
            SizedBox(height: 5),
            // user's rank
            Text('Ranked ' + (_cubit.userContestRanks[i] != null ? 
              RankingMaker.getRank(_cubit.userContestRanks.indexOf(
              _cubit.userContestRanks[i])).toString() : '-')),
            SizedBox(height: 5),
          ],
        ), 
        onTap: () {
          if(excerpt.id != null) {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MatchLeaderboard(mlCubit.MatchLeaderBoardCubit(excerpt,
                  _cubit.user));
              },
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('The contest hasn\'t started yet.'),
            ));
          }
        },
      ));
      matchWidgets.add(Divider());
    }

    return ListView(
      padding: Paddings.pagePadding,
      children: matchWidgets,
    );
  }

  Column getSeriesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Image.network(
              _cubit.series.photo,
              width: 30,
              height: 30,
            ),
            Expanded(
              child: Text(
                ' ' + _cubit.series.name,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            getSeriesInfoText('T20: ${_cubit.numberOfT20Matches} | '),
            getSeriesInfoText('One Day: ${_cubit.numberOfOneDayMatches} | '),
            getSeriesInfoText('Test: ${_cubit.numberOfTestMatches}'),
          ],
        )
      ],
    );
  }

  Text getSeriesInfoText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
