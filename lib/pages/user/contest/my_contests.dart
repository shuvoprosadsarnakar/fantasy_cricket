import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/pages/user/contest/contest_detials.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/contest_details_cubit.dart'
    as cdCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/contests_list_item.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyContests extends StatelessWidget {
  final RunningContestsCubit _cubit;

  MyContests(this._cubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if (state == CubitState.loading) {
          return Loading();
        } else if (state == CubitState.fetchError) {
          return FetchErrorMsg();
        } else {
          final List<InkWell> listItems = getListItems(context);
          final int totalItems = listItems.length;

          if (totalItems > 0) {
            return ListView.builder(
              padding: Paddings.pagePadding,
              itemCount: totalItems,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  children: [
                    listItems[i],
                    SizedBox(height: 20),
                  ],
                );
              },
            );
          } else {
            return Padding(
              padding: Paddings.pagePadding,
              child: Text('No running contest found.'),
            );
          }
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
        if (_cubit.user.contestIds.contains(excerpt.id)) {
          runningContestsExcerpts.add(excerpt);
          runningContestsSerieses.add(series);
        }
      });
    });

    final int totalListItems = runningContestsExcerpts.length;

    for (int i = 0; i < totalListItems; i++) {
      listItems.add(InkWell(
        child: ContestsListItem(
          runningContestsExcerpts[i],
          runningContestsSerieses[i],
          RunningContestsCubit.getSeriesTotalChips(runningContestsSerieses[i]),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return ContestDetails(cdCubit.ContestDetialsCubit(
              runningContestsSerieses[i],
              runningContestsExcerpts[i],
              _cubit.user,
            ));
          },
        )),
      ));
    }

    return listItems;
  }
}
