import 'package:fantasy_cricket/helpers/role_image_finder.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/fantasy_player_points_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/player_points_details.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FantasyPlayerPoints extends StatelessWidget {
  final FantasyPlayerPointsCubit _cubit;

  FantasyPlayerPoints(this._cubit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fantasy Player Points')),
      body: BlocBuilder(
        bloc: _cubit,
        builder: (BuildContext context, CubitState state) {
          if(state == CubitState.loading) {
            return Loading();
          } else if(state == CubitState.fetchError) {
            return FetchErrorMsg();
          } else {
            return ListView(
              padding: Paddings.pagePadding,
              children: [
                getFantasySummary(),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Player'),
                    Text('Points'),
                  ],
                ),
                Divider(color: Colors.grey),
                getPlayerPoints(context),
              ],
            );
          }
        },
      ),
    );
  }

  ClipRRect getFantasySummary() {
    int rankIndex = _cubit.contest.ranks.indexWhere((Rank rank) {
      return rank.username == _cubit.username;
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        tileColor: ColorPallate.mercury,
        title: Text(_cubit.username),
        subtitle: Text('Rank: ' + _cubit.getRank(rankIndex).toString()),
        trailing: Text('Points: ' + 
          _cubit.contest.ranks[rankIndex].totalPoints.toString()),
      ),
    );
  }

  Column getPlayerPoints(BuildContext context) {
    List<Widget> pointsRows = _cubit.fantasy.playerNames.map((String playerName) 
    {
      int playerIndex = _cubit.contest.playersNames.indexOf(playerName);
      int teamIndex = playerIndex < _cubit.contest.team1TotalPlayers ? 0 : 1;
      
      String playerPointsPrefix = '';
      String playerNameSuffix = '';
      int playerPointsMultiplicator = 1;

      if(playerName == _cubit.fantasy.captain) {
        playerPointsPrefix = '(x 2)';
        playerNameSuffix = '(C)';
        playerPointsMultiplicator = 2;
      } else if(playerName == _cubit.fantasy.viceCaptain) {
        playerPointsPrefix = '(x 1.5)';
        playerNameSuffix = '(VC)';
        playerPointsMultiplicator = 1;
      }

      return Column(
        children: [
          ListTile(
            title: Text(
              playerName + ' ' + playerNameSuffix,
              style: Theme.of(context).textTheme.subtitle1,  
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Row(
                  children: [
                    Image.asset(
                      RoleImageFinder
                        .getRoleImage(_cubit.contest.playersRoles[playerIndex]),
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 5),
                    Text(_cubit.contest.playersRoles[playerIndex]),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Image.network(
                      _cubit.excerpt.teamImages[teamIndex],
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 5),
                    Expanded(child: Text(_cubit.contest.teamsNames[teamIndex])),
                  ],
                ),
              ],
            ),
            trailing: Text(playerPointsPrefix + ' ' 
              + (_cubit.contest.playersPoints.isNotEmpty 
              ? _cubit.contest.playersPoints[playerIndex] 
              * playerPointsMultiplicator : 0).toString()),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return PlayerPointsDetails(_cubit.contest, playerIndex, 
                  _cubit.excerpt);
              },
            )),
          ),
          Divider(),
        ],
      );
    }).toList();

    return Column(children: pointsRows);
  }
}
