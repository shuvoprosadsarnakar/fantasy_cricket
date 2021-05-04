import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/pages/contests/contest_ender.dart';
import 'package:fantasy_cricket/pages/contests/contest_manager.dart';
import 'package:fantasy_cricket/pages/contests/cubits/contest_ender_cubit.dart' as ceCubit;
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
            final List<InkWell> listItems = <InkWell>[];
            initListItems(context, listItems);

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

  void initListItems(BuildContext context, List<InkWell> listItems) {
    _cubit.notEndedSerieses.forEach((Series series) {
      int totalExcerpts = series.matchExcerpts.length;

      for(int i = 0; i < totalExcerpts; i++) {
        Excerpt excerpt = series.matchExcerpts[i];

        if(excerpt.status == _contestStatus) {
          listItems.add(InkWell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getStartingTime(excerpt.startTime),
                SizedBox(height: 5),
                getTeamNames(excerpt.teamsNames, context),
                SizedBox(height: 5),
                getMatchTypeAndNo(excerpt.no, excerpt.type),
                SizedBox(height: 5),
                getSeriesName(series.name, context),
                SizedBox(height: 5),
                if(_contestStatus != ContestStatuses.upcoming) 
                  getContestPrice(excerpt),
                if(_contestStatus != ContestStatuses.upcoming)
                  SizedBox(height: 5),
                getSeriesPrice(series),
                Divider(height: 30),
              ],
            ),
            onTap: getOnTap(context, series, i),
          ));
        }
      }
    });
  }

  Text getStartingTime(Timestamp startTime) {
    return Text(
      'Match Time: ' + startTime.toDate().toString(),
      style: TextStyle(fontStyle: FontStyle.italic),  
    );
  }

  Text getTeamNames(List<String> teamsNames, BuildContext context) {
    return Text(
      '${teamsNames[0]} VS ${teamsNames[1]}',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Theme.of(context).primaryColor,
      ),  
    );
  }

  Text getMatchTypeAndNo(int no, String type) {
    return Text('No.$no $type');
  }

  Text getSeriesName(String seriesName, BuildContext context) {
    return Text(
      seriesName,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }

  Function getOnTap(BuildContext context, Series series, int excerptIndex) {
    return () async {
      String snackBarText = await Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (BuildContext context) {
            if(_contestStatus != ContestStatuses.locked) {
              return ContestManager(
                cmCubit.ContestManagerCubit(series, excerptIndex)
              );
            } else {
              return ContestEnder(
                ceCubit.ContestEnderCubit(series, excerptIndex)
              );
            }
          },
        ),
      );
    
      if(snackBarText != null) {
        _cubit.rebuildUi();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarText),
        ));
      }
    };
  }

  Text getSeriesPrice(Series series) {
    int totalChips = 0;
    int totalDistributes = series.chipsDistributes.length;
    
    for(int i = 0; i < totalDistributes; i++) {
      totalChips += series.chipsDistributes[i].chips;
    }

    return Text(
      'Series: $totalChips Chips & ' + 
        '${series.chipsDistributes[totalDistributes - 1].to} Winners',
    );
  }

  Text getContestPrice(Excerpt excerpt) {
    return Text(
      'Match: ${excerpt.totalChips} Chips & ${excerpt.totalWinners} Winners'
    );
  }
}
