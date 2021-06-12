import 'package:fantasy_cricket/helpers/get_role_image.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/pages/contests/cubits/fantasy_player_points_cubit.dart';
import 'package:fantasy_cricket/pages/contests/cubits/player_points_details_cubit.dart';
import 'package:fantasy_cricket/pages/contests/player_points_details.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_or_message.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FantasyPlayerPoints extends StatelessWidget {
  final FantasyPlayerPointsCubit cubit;

  FantasyPlayerPoints(this.cubit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fantasy Player Points'),
      ),
      body: BlocBuilder<FantasyPlayerPointsCubit, CubitState>(
        bloc: cubit,
        builder: (BuildContext context, CubitState state) {
          if(state == CubitState.loading) {
            return Loading();
          } else if(state == CubitState.fetchError) {
            return FetchErrorOrMessage();
          } else {
            return ListView(
              padding: Paddings.pagePadding,
              children: <Widget>[
                getFantasySummary(),
                SizedBox(height: 30),
                
                getPlayerPointsTitles(),
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
    final int rankIndex = cubit.contest.ranks.indexWhere((Rank rank) {
      return rank.username == cubit.username;
    });

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        tileColor: ColorPallate.mercury,
        title: Text(
          cubit.username,
          style: TextStyle(color: ColorPallate.pomegranate),  
        ),
        subtitle: Text('Rank: ' + (rankIndex + 1).toString()),
        trailing: Text('Points: ' + 
          cubit.contest.ranks[rankIndex].totalPoints.toString()),
      ),
    );
  }

  Row getPlayerPointsTitles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Player'),
        Text('Points'),
      ],
    );
  }

  Column getPlayerPoints(BuildContext context) {
    List<Column> pointsRows 
      = cubit.fantasy.playerNames.map((String playerName) {
      final int playerIndex = cubit.contest.playersNames.indexOf(playerName);
      final int teamIndex 
        = playerIndex < cubit.contest.team1TotalPlayers ? 0 : 1;
      
      String playerPointsPrefix;
      String playerNameSuffix;
      int playerPointsMultiplicator;

      if(playerName == cubit.fantasy.captain) {
        playerPointsPrefix = '(x 2)';
        playerNameSuffix = '(C)';
        playerPointsMultiplicator = 2;
      } else if(playerName == cubit.fantasy.viceCaptain) {
        playerPointsPrefix = '(x 1.5)';
        playerNameSuffix = '(VC)';
        playerPointsMultiplicator = 1;
      } else {
        playerPointsPrefix = '';
        playerNameSuffix = '';
        playerPointsMultiplicator = 1;
      }

      return Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,

            // player name with suffix
            title: Text(
              playerName + ' ' + playerNameSuffix,
              style: Theme.of(context).textTheme.subtitle1,  
            ),

            // role and team images and names
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5),
                
                // role image and name
                Row(
                  children: <Widget>[
                    Image.asset(
                      getRoleImage(cubit.contest.playersRoles[playerIndex]),
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(cubit.contest.playersRoles[playerIndex]),
                    ),
                  ],
                ),
                SizedBox(height: 5),

                // team image and name
                Row(
                  children: <Widget>[
                    Image.network(
                      cubit.excerpt.teamImages[teamIndex],
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(cubit.contest.teamsNames[teamIndex]),
                    ),
                  ],
                ),
              ],
            ),
            
            // player points
            trailing: Text(playerPointsPrefix + ' ' 
              + (cubit.contest.playersPoints.isNotEmpty 
              ? cubit.contest.playersPoints[playerIndex] 
              * playerPointsMultiplicator : 0).toString()),
            
            // points details page
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return PlayerPointsDetails(PlayerPointsDetailsCubit(
                  cubit.contest, playerIndex, cubit.excerpt));
              },
            )),
          ),
          if(playerName != cubit.fantasy.playerNames.last) Divider(),
        ],
      );
    }).toList();

    return Column(children: pointsRows);
  }
}
