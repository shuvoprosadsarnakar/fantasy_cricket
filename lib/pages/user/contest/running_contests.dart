import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/pages/user/contest/contest_detials.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/contest_details_cubit.dart' as cdCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:fantasy_cricket/widgets/contests_list_item.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RunningContests extends StatelessWidget {
  final RunningContestsCubit _cubit;
  
  RunningContests(this._cubit);
  
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
          return  ListView(
              padding: Paddings.pagePadding,
              children: getListItems(context),
            
          );
        }
      },
    );
  }

  List<Widget> getListItems(BuildContext context) {
    final List<Excerpt> runningContestsExcerpts = <Excerpt>[];
    final List<Series> runningContestsSerieses = <Series>[];
    final List<InkWell> listItems = <InkWell>[];
      
    // init [runningContestsExcerpts] & [runningContestsSerieses] variables
    _cubit.notEndedSerieses.forEach((Series series) {
      series.matchExcerpts.forEach((Excerpt excerpt) {
        if(excerpt.status == ContestStatuses.running && 
          _cubit.user.contestIds.contains(excerpt.id) == false) {
          runningContestsExcerpts.add(excerpt);
          runningContestsSerieses.add(series);
        }
      });
    });

    final int totalListItems = runningContestsExcerpts.length;

    for(int i = 0; i < totalListItems; i++) {
      listItems.add(InkWell(
        child: ContestsListItem(
          runningContestsExcerpts[i],
          runningContestsSerieses[i],
        ),
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return ContestDetails(cdCubit.ContestDetialsCubit(
                runningContestsSerieses[i],
                runningContestsExcerpts[i],
                _cubit.user,
              ));
            },
          ));

          // rebuild UI to update running contests list if user has joined the 
          // contest
          _cubit.rebuildUi();
        },
      ));
    }

    return listItems;
  }
}
