import 'package:fantasy_cricket/helpers/number_suffix_finder.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/contest_details_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/match_leaderboard_cubit.dart' as mlCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart' as rcCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/series_leaderboard_cubit.dart' as slCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/team_manager_cubit.dart' as tmCubit;
import 'package:fantasy_cricket/pages/user/contest/match_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/series_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/team_manager.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                _getContestDetilsHeader(),
                Divider(color: Colors.grey.shade900, height: 30),
                _getMatchPrizes(context),
                SizedBox(height: 20),
                _getSeriesPrizes(context),
                SizedBox(height: 50), // for floating action button
              ],
            ),
            floatingActionButton: _cubit.excerpt.status == 
              ContestStatuses.running ? _getJoinContestButton(context) : null,
          );
        }
      },
    );
  }

  Row _getContestDetilsHeader() {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getTeamImage(_cubit.excerpt.teamImages[0]),
        SizedBox(width: 10),
        
        Expanded(
          child: Column(children: [
            Text(
              _cubit.excerpt.teamsNames[0] + ' vs ' 
                + _cubit.excerpt.teamsNames[1],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 7),
            Text(_cubit.excerpt.no.toString()
              + NumberSuffixFinder.getNumberSuffix(_cubit.excerpt.no) + ' '
              + _cubit.excerpt.type + ' Match'),
            SizedBox(height: 7),
            Text(_cubit.series.name, textAlign: TextAlign.center),
            SizedBox(height: 7),
            Text(DateFormat.yMMMd().add_jm().format(_cubit.excerpt.startTime
              .toDate())),
          ]),
        ),
        SizedBox(width: 10),
        
        _getTeamImage(_cubit.excerpt.teamImages[1]),
      ],
    );
  }

  Image _getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 40,
      width: 40,
      fit: BoxFit.cover,
    );
  }

  Column _getMatchPrizes(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Match Prizes',
            style: TextStyle(fontSize: 18),  
          ),
          TextButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(8),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Text(
              'Leaderboard',
              style: TextStyle(color: Theme.of(context).primaryColor),  
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MatchLeaderboard(mlCubit.MatchLeaderBoardCubit(
                  _cubit.excerpt, _cubit.user));
              },
            )),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'lib/resources/images/winner.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Text('${_cubit.excerpt.totalWinners} Winners'),
            ],
          ),
          Row(
            children: [
              Image.asset(
                'lib/resources/images/coins.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              Text('${_cubit.excerpt.totalChips} Chips'),
            ],
          ),
        ],
      ),
      Divider(color: Colors.grey),
      _getWinnersWiseChipsRows(_cubit.contest.chipsDistributes),
    ]);
  }

  Column _getSeriesPrizes(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Series Prizes',
            style: TextStyle(fontSize: 18),  
          ),
          TextButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(8),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Text(
              'Leaderboard',
              style: TextStyle(color: Theme.of(context).primaryColor),  
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
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'lib/resources/images/winner.png',
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Text('${_cubit.series.chipsDistributes.last.to} Winners'),
            ],
          ),
          Row(
            children: [
              Image.asset(
                'lib/resources/images/coins.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              Text(rcCubit.RunningContestsCubit.getSeriesTotalChips(_cubit.series)
                .toString() + ' Chips'),
            ],
          ),
        ],
      ),
      Divider(color: Colors.grey),
      _getWinnersWiseChipsRows(_cubit.series.chipsDistributes),
    ]);
  }

  Column _getWinnersWiseChipsRows(List<Distribute> distributes) {
    List<Column> distributeRows = <Column>[];
    int totalDistributes = distributes.length;

    for(int i = 0; i < totalDistributes; i++) {
      int from = distributes[i].from;
      int to = distributes[i].to;
      
      distributeRows.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                from.toString() + NumberSuffixFinder.getNumberSuffix(from) 
                  + (from != to ? ' - ' + to.toString() 
                  + NumberSuffixFinder.getNumberSuffix(to) : ''),
              ),
              Text(distributes[i].chips.toString() + ' Chips'),
            ],
          ),
          Divider(),
        ],
      ));
    }

    return Column(children: distributeRows);
  }

  TextButton _getJoinContestButton(BuildContext context) {
    String buttonText;

    print(_cubit.user);
    
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
            return TeamManager(tmCubit.TeamManagerCubit(_cubit.series,
              _cubit.user, _cubit.excerpt));
          },
        ));

        // rebuild UI to change button text if user has joined contest
        _cubit.rebuildUi();
      },
    );
  }
}
