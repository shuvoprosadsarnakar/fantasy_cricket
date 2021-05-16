import 'package:fantasy_cricket/pages/user/contest/cubits/fantasy_player_points_cubit.dart';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Player'),
                    Text('Points'),
                  ],
                ),
                Divider(color: Colors.grey),
                getPlayerPoints(),
              ],
            );
          }
        },
      ),
    );
  }

  Column getPlayerPoints() {
    List<Widget> pointsRows = _cubit.fantasy.playerNames.map((String playerName) 
    {
      int pointsIndex = _cubit.contest.playersNames.indexOf(playerName);

      return Column(
        children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(playerName),
                    Row(children: [
                      SizedBox(width: 10),
                      Text((_cubit.contest.playersPoints.isNotEmpty ?
                        _cubit.contest.playersPoints[pointsIndex] : 0)
                        .toString()),
                    ]),
                  ],
                ),
              ]),
            ),
            onTap: () {},
          ),
          Divider(),
        ],
      );
    }).toList();

    return Column(children: pointsRows);
  }
}
