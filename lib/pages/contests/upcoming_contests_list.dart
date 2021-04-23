import 'package:fantasy_cricket/models/match_excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/contests/cubits/upcoming_contests_list_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpcomingContestsList extends StatelessWidget {
  static final String routeName = 'upcoming_contests_list';
  
  final List<InkWell> listItems = [];
  
  final UpcomingContestsListCubit _cubit;

  UpcomingContestsList(this._cubit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upcoming Contests')),
      body: BlocBuilder<UpcomingContestsListCubit, States>(
        bloc: _cubit,
        builder: (BuildContext context, States state) {
          if(state == States.loading) {
            return Loading();
          } else if(state == States.fetchError) {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Text('Failed to fetch data from database.'),
            );
          } else {
            initListItemsVar(context);
            return Padding(
              padding: Paddings.pagePadding,
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (BuildContext context, int i) => listItems[i],
              ),
            );
          }
        },
      ),
    );
  }

  void initListItemsVar(BuildContext context) {
    Team team1, team2;

    _cubit.notEndedSerieses.forEach((Series series) {
      series.matchExcerpts.forEach((MatchExcerpt excerpt) {
        if(excerpt.id == null) {
          // set team1
          team1 = _cubit.allTeams.firstWhere((Team team) {
            return excerpt.teamIds[0] == team.id;
          });

          // set team2
          team2 = _cubit.allTeams.firstWhere((Team team) {
            return excerpt.teamIds[1] == team.id;
          });

          // create and add list item
          listItems.add(InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // starting time
                Text(
                  excerpt.startTime.toDate().toString(),
                  style: TextStyle(fontStyle: FontStyle.italic),  
                ),
                SizedBox(height: 5),
                
                // team names
                Text(
                  '${team1.name} VS ${team2.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),  
                ),
                SizedBox(height: 5),
                
                // match type and typewise no
                Text('No.${excerpt.no} ${excerpt.type}'),
                SizedBox(height: 5),
                
                // series name and divider
                Text(
                  series.name,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Divider(height: 30),
              ],
            ),
            onTap: () {},
          ));
        }
      });
    });
  }
}