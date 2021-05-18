import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/contest_details_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart' as rcCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/series_leaderboard_cubit.dart' as slCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/team_manager_cubit.dart' as tmCubit;
import 'package:fantasy_cricket/pages/user/contest/match_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/series_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/team_manager.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:fantasy_cricket/widgets/contests_list_item.dart';
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
        
        Column(children: [
          Text(
            _cubit.excerpt.teamsNames[0] + ' vs ' 
              + _cubit.excerpt.teamsNames[1],
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(_cubit.excerpt.no.toString()
            + ContestsListItem.getNoSuffix(_cubit.excerpt.no) + ' '
            + _cubit.excerpt.type + ' Match'),
          SizedBox(height: 5),
          Row(
            children: [
              Image.network(
                _cubit.series.photo,
                width: 30,
                height: 30,
              ),
              SizedBox(width: 10),
              Text(_cubit.series.name),
            ],
          ),
          SizedBox(height: 5),
          Text(
            '${_cubit.excerpt.startTime.toDate().toString().substring(0, 16)}'
          ),
        ]),
        SizedBox(width: 10),
        
        _getTeamImage(_cubit.excerpt.teamImages[1]),
      ],
    );
  }

  Image _getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 50,
      width: 50,
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
            child: Text(
              'Leaderboard',
              style: TextStyle(color: Theme.of(context).primaryColor),  
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MatchLeaderboard(
                  contest: _cubit.contest,
                  excerpt: _cubit.excerpt,
                  user: _cubit.user,
                );
              },
            )),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${_cubit.excerpt.totalWinners} Total Winners'),
          Text('${_cubit.excerpt.totalChips} Total Chips'),
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
          Text('${_cubit.series.chipsDistributes.last.to} Total Winners'),
          Text(rcCubit.RunningContestsCubit.getSeriesTotalChips(_cubit.series)
            .toString() + ' Total Chips'),
        ],
      ),
      Divider(color: Colors.grey),
      _getWinnersWiseChipsRows(_cubit.series.chipsDistributes),
    ]);
  }

  Column _getWinnersWiseChipsRows(List<Distribute> distributes) {
    List<Row> distributeRows = <Row>[];
    int totalDistributes = distributes.length;

    for(int i = 0; i < totalDistributes; i++) {
      int from = distributes[i].from;
      int to = distributes[i].to;
      
      distributeRows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            from.toString() + ContestsListItem.getNoSuffix(from) 
              + (from != to ? ' - ' + to.toString() 
              + ContestsListItem.getNoSuffix(to) : ''),
          ),
          Text(distributes[i].chips.toString() + ' Chips'),
        ],
      ));
    }

    return Column(children: distributeRows);
  }

  TextButton _getJoinContestButton(BuildContext context) {
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
              _cubit.series,
              _cubit.contest, 
              _cubit.user,
              _cubit.excerpt,
            ));
          },
        ));

        // rebuild UI to change button text if user has joined contest
        _cubit.rebuildUi();
      },
    );
  }
}
