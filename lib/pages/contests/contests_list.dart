import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/pages/contests/contest_ender.dart';
import 'package:fantasy_cricket/pages/contests/contest_manager.dart';
import 'package:fantasy_cricket/pages/contests/cubits/contest_ender_cubit.dart'
    as ceCubit;
import 'package:fantasy_cricket/pages/contests/cubits/contest_manager_cubit.dart'
    as cmCubit;
import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart'
    as rcCubit;
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
          if (state == CubitState.loading) {
            return Loading();
          } else if (state == CubitState.fetchError) {
            return FetchErrorMsg();
          } else {
            final List<InkWell> listItems = _getListItems(context);

            if (listItems.length > 0) {
              return ListView.builder(
                padding: Paddings.pagePadding,
                itemCount: listItems.length,
                itemBuilder: (BuildContext context, int i) => listItems[i],
              );
            } else {
              return Padding(
                padding: Paddings.pagePadding,
                child: Text('No contest found.'),
              );
            }
          }
        },
      ),
    );
  }

  List<InkWell> _getListItems(BuildContext context) {
    final List<InkWell> listItems = <InkWell>[];

    _cubit.notEndedSerieses.forEach((Series series) {
      int totalExcerpts = series.matchExcerpts.length;

      for (int i = 0; i < totalExcerpts; i++) {
        Excerpt excerpt = series.matchExcerpts[i];

        if (excerpt.status == _contestStatus) {
          listItems.add(InkWell(
            child: Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getTeamNames(excerpt.teamsNames, context),
                    SizedBox(height: 5),
                    _getMatchTypeAndNo(excerpt.no, excerpt.type),
                    SizedBox(height: 5),
                    _getSeriesName(series.photo, series.name, context),
                    SizedBox(height: 5),
                    if (_contestStatus != ContestStatuses.upcoming)
                      _getContestPrice(excerpt),
                    if (_contestStatus != ContestStatuses.upcoming)
                      SizedBox(height: 5),
                    _getSeriesPrice(series),
                    SizedBox(height: 5),
                    _getStartingTime(excerpt.startTime),
                    Divider(height: 30),
                  ],
                ),
              ),
            ),
            onTap: _getOnTap(context, series, i),
          ));
        }
      }
    });

    return listItems;
  }

  Text _getStartingTime(Timestamp startTime) {
    String date = DateFormat.yMMMd().add_jm().format(startTime.toDate());
    return Text(
      'Time: ' + date,
      style: TextStyle(fontWeight: FontWeight.w500,
      fontSize: 16,),
    );
  }

  Text _getTeamNames(List<String> teamsNames, BuildContext context) {
    return Text(
      '${teamsNames[0]} VS ${teamsNames[1]}',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Text _getMatchTypeAndNo(int no, String type) {
    return Text('No.$no $type');
  }

  Row _getSeriesName(String imageLink, String name, BuildContext context) {
    return Row(
      children: [
        Image.network(
          imageLink,
          width: 50,
          height: 50,
        ),
        SizedBox(width: 10),
        Text(
          name,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }

  Function _getOnTap(BuildContext context, Series series, int excerptIndex) {
    return () async {
      String snackBarText = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            if (_contestStatus != ContestStatuses.locked) {
              return ContestManager(
                  cmCubit.ContestManagerCubit(series, excerptIndex));
            } else {
              return ContestEnder(
                  ceCubit.ContestEnderCubit(series, excerptIndex));
            }
          },
        ),
      );

      if (snackBarText != null) {
        _cubit.rebuildUi();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarText),
        ));
      }
    };
  }

  Text _getSeriesPrice(Series series) {
    return Text(
        'Series: ${rcCubit.RunningContestsCubit.getSeriesTotalChips(series)} Chips & ${series.chipsDistributes.last.to} ' +
            'Winners');
  }

  Text _getContestPrice(Excerpt excerpt) {
    return Text(
        'Match: ${excerpt.totalChips} Chips & ${excerpt.totalWinners} Winners');
  }
}
