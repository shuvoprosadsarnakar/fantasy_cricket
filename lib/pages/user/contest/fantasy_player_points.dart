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
      
      double pointsMultiplicator;
      String playerNameSuffix;

      if(playerName == _cubit.fantasy.captain) {
        pointsMultiplicator = 2;
        playerNameSuffix = '(C)';
      } else if(playerName == _cubit.fantasy.viceCaptain) {
        pointsMultiplicator = 1.5;
        playerNameSuffix = '(VC)';
      } else {
        pointsMultiplicator = 1;
        playerNameSuffix = '';
      }

      return Column(
        children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playerName + ' ' + playerNameSuffix,
                          style: Theme.of(context).textTheme.subtitle1,  
                        ),
                        SizedBox(height: 5),
                        Text(
                          _cubit.contest.playersRoles[playerIndex],
                          style: TextStyle(fontWeight: FontWeight.w300),  
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Image.network(
                              _cubit.excerpt.teamImages[teamIndex],
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 5),
                            Text(_cubit.contest.teamsNames[teamIndex]),
                          ],
                        ),
                      ],
                    ),
                    Row(children: [
                      SizedBox(width: 10),
                      if(pointsMultiplicator != 1) 
                        Text('(x ' + pointsMultiplicator.toString() + ')'),
                      if(pointsMultiplicator != 1) SizedBox(width: 10),
                      Text((_cubit.contest.playersPoints.isNotEmpty 
                        ? _cubit.contest.playersPoints[playerIndex] 
                        * pointsMultiplicator : 0).toString()),
                    ]),
                  ],
                ),
              ]),
            ),
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
