import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/contest_details_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/match_leaderboard_cubit.dart' as mlCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/series_leaderboard_cubit.dart' as slCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/team_manager_cubit.dart' as tmCubit;
import 'package:fantasy_cricket/pages/user/contest/match_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/series_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/team_manager.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContestDetails extends StatelessWidget {
  final ContestDetialsCubit _cubit;

  ContestDetails(this._cubit);

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
          return Scaffold(
            appBar: AppBar(title: Text('Contest Details')),
            body: ListView(
              padding: Paddings.pagePadding,
              children: [
                getContestDetilsHeader(),
                Divider(color: Theme.of(context).primaryColor),
                getMatchPrizes(context),
                Divider(color: Theme.of(context).primaryColor),
                getSeriesPrizes(context),
                SizedBox(height: 50), // for floating action button
              ],
            ),
            floatingActionButton: _cubit.excerpt.status == 
              ContestStatuses.running ? getJoinContestButton(context) : null,
          );
        }
      },
    );
  }

  Row getContestDetilsHeader() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getTeamImage('https://www.bing.com/th?id=AMMS_5c876f9fd7bc3055e55bc35a4ee71a26&w=110&h=110&c=7&rs=1&qlt=95&pcl=f9f9f9&cdv=1&pid=16.1'),
        SizedBox(width: 10),
        
        Column(children: [
          Text(
            '${_cubit.excerpt. teamsNames[0]} vs ${_cubit.excerpt.teamsNames[1]}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text('${_cubit.excerpt.no}${getNoSuffix(_cubit.excerpt.no)} Match'),
          SizedBox(height: 5),
          Text(_cubit.series.name),
          SizedBox(height: 5),
          Text(
            '${_cubit.excerpt.startTime.toDate().toString().substring(0, 16)}'
          ),
        ]),
        SizedBox(width: 10),
        
        getTeamImage('https://www.bing.com/th?id=AMMS_b161ce1c295b4dc5cced0a19bc9d156c&w=110&h=110&c=7&rs=1&qlt=95&pcl=f9f9f9&cdv=1&pid=16.1'),
      ],
    );
  }

  Image getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 50,
      width: 50,
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

  Column getMatchPrizes(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Match Prizes',
            style: TextStyle(fontSize: 18),  
          ),
          TextButton(
            child: Text(
              'Leaderboard',
              style: TextStyle(color: Colors.green),  
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MatchLeaderboard(
                  mlCubit.MatchLeaderboardCubit(
                    _cubit.contest,
                    _cubit.user,
                    _cubit.excerpt.status,
                  )
                );
              },
            )),
          ),
        ],
      ),
      Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${_cubit.excerpt.totalWinners} Total Winners'),
          Text('${_cubit.excerpt.totalChips} Total Chips'),
        ],
      ),
      Divider(),
      getWinnersWiseChipsRows(_cubit.contest.chipsDistributes),
    ]);
  }

  Column getSeriesPrizes(BuildContext context) {
    int totalWinners = _cubit.series.chipsDistributes.last.to;
    int totalChips = 0;
    
    _cubit.series.chipsDistributes.forEach((Distribute distribute) {
      totalChips += distribute.chips;
    });

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Series Prizes',
            style: TextStyle(fontSize: 18),  
          ),
          TextButton(
            child: Text(
              'Leaderboard',
              style: TextStyle(color: Colors.green),  
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return SeriesLeaderboard(slCubit.SeriesLeaderboardCubit(
                  _cubit.series,
                  _cubit.user,
                ));
              },
            )),
          ),
        ],
      ),
      Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$totalWinners Total Winners'),
          Text('$totalChips Total Chips'),
        ],
      ),
      Divider(),
      getWinnersWiseChipsRows(_cubit.series.chipsDistributes),
    ]);
  }

  Column getWinnersWiseChipsRows(List<Distribute> distributes) {
    List<Row> distributeRows = <Row>[];
    int totalDistributes = distributes.length;

    for(int i = 0; i < totalDistributes; i++) {
      int from = distributes[i].from;
      int to = distributes[i].to;
      
      distributeRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            from.toString() + getNoSuffix(from) 
              + (from != to ? ' - ' + to.toString() + getNoSuffix(to) : ''),
          ),
          Text(distributes[i].chips.toString() + ' Chips'),
        ],
      ));
    }

    return Column(children: distributeRows);
  }

  TextButton getJoinContestButton(BuildContext context) {
    String buttonText;
    
    if(_cubit.user.contestIds.contains(_cubit.excerpt.id)) {
      buttonText = 'Update Team';
    } else {
      buttonText = 'Create Team';
    }
    
    return TextButton(
      child: Text(buttonText),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(5),
      ),
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return TeamManager(tmCubit.TeamManagerCubit(
              _cubit.contest, 
              _cubit.user,
            ));
          },
        ));

        // rebuild UI to change button text if user has joined contest
        _cubit.rebuildUi();
      },
    );
  }
}
