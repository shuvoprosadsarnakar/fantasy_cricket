import 'package:fantasy_cricket/models/match_excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/pages/contests/contest_manager.dart';
import 'package:fantasy_cricket/pages/contests/cubits/contest_manager_cubit.dart' as cmCubit;
import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContestsList extends StatelessWidget {
  final ContestsListCubit _cubit;
  final String _contestStatus;

  ContestsList(this._cubit, this._contestStatus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$_contestStatus Contests')),
      body: BlocBuilder(
        bloc: _cubit,
        builder: (BuildContext context, CubitState state) {
          if(state == CubitState.loading) {
            return Loading();
          } else if(state == CubitState.fetchError) {
            return FetchErrorMsg();
          } else {
            List<InkWell> listItems = [];
            initListItemsVar(context, listItems);

            return ListView.builder(
              padding: Paddings.pagePadding,
              itemCount: listItems.length,
              itemBuilder: (BuildContext context, int i) => listItems[i],
            );
          }
        },
      ),
    );
  }

  void initListItemsVar(BuildContext context, List<InkWell> listItems) {
    int totalExcerpts;
    MatchExcerpt excerpt;

    _cubit.notEndedSerieses.forEach((Series series) {
      totalExcerpts = series.matchExcerpts.length;

      for(int i = 0; i < totalExcerpts; i++) {
        excerpt = series.matchExcerpts[i];

        if(excerpt.status == _contestStatus) {
          // add list item
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
                  '${excerpt.teamsNames[0]} VS ${excerpt.teamsNames[1]}',
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
            onTap: () async {   
              String snackBarText;

              if(_contestStatus != ContestStatuses.locked) {
                snackBarText = await Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return ContestManager(cmCubit.ContestManagerCubit(series, i));
                  },
                ));
              } else {
                snackBarText = 'Contest reporter screen needed to be set.';
              }
           
              if(snackBarText != null) {
                _cubit.rebuildUi();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(snackBarText),
                ));
              }
            },
          ));
        }
      }
    });
  }
}
