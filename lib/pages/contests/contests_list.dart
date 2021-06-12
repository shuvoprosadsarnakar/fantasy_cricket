import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/helpers/get_total_chips.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/pages/contests/contest_detials.dart';
import 'package:fantasy_cricket/pages/contests/contest_ender.dart';
import 'package:fantasy_cricket/pages/contests/contest_manager.dart';
import 'package:fantasy_cricket/pages/contests/cubits/contest_details_cubit.dart' as cdCubit;
import 'package:fantasy_cricket/pages/contests/cubits/contest_ender_cubit.dart'
    as ceCubit;
import 'package:fantasy_cricket/pages/contests/cubits/contest_manager_cubit.dart'
    as cmCubit;
import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
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
            final List<Widget> listItems = _getListItems(context);

            if (listItems.length > 0) {
              return ListView.builder(
                padding: Paddings.pagePadding,
                itemCount: listItems.length,
                itemBuilder: (BuildContext context, int i) => listItems[i],
              );
            } else {
              return Padding(
                padding: Paddings.pagePadding,
                child: Text(
                  'No contest found.',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              );
            }
          }
        },
      ),
    );
  }

  List<Widget> _getListItems(BuildContext context) {
    final List<Widget> listItems = <Widget>[];

    _cubit.notEndedSerieses.forEach((Series series) {
      int totalExcerpts = series.matchExcerpts.length;

      for (int i = 0; i < totalExcerpts; i++) {
        Excerpt excerpt = series.matchExcerpts[i];

        if (excerpt.status == _contestStatus) {
          listItems.add(InkWell(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    _getTeamNames(excerpt.teamImages, excerpt.teamsNames, 
                      context),
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
                  ],
                ),
              ),
            ),
            onTap: _getOnTap(context, series, i),
          ));
          listItems.add(SizedBox(height: 20));
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

  SizedBox _getTeamNames(List<String>teamImages, List<String> teamsNames, 
    BuildContext context) 
  {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          Image.network(
            teamImages[0],
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              '${teamsNames[0]} VS ${teamsNames[1]}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 5),
          Image.network(
            teamImages[1],
            width: 35,
            height: 35,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Text _getMatchTypeAndNo(int no, String type) {
    return Text('No.$no $type');
  }

  Row _getSeriesName(String imageLink, String name, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: Theme.of(context).textTheme.subtitle2,
            textAlign: TextAlign.center,
          ),
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
            if (_contestStatus == ContestStatuses.ended) {
              return ContestDetails(
                cdCubit.ContestDetialsCubit(series, series.matchExcerpts[excerptIndex]));
            } else if (_contestStatus != ContestStatuses.locked) {
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
        'Series: ${getTotalChips(series.chipsDistributes)} ' 
        + 'Chips & ${series.chipsDistributes.last.to} Winners');
  }

  Text _getContestPrice(Excerpt excerpt) {
    return Text(
        'Match: ${excerpt.totalChips} Chips & ${excerpt.totalWinners} Winners');
  }
}
