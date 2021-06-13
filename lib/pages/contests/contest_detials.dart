import 'package:fantasy_cricket/helpers/get_number_suffix.dart';
import 'package:fantasy_cricket/helpers/get_total_chips.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/pages/contests/cubits/'
       'contest_details_cubit.dart';
import 'package:fantasy_cricket/pages/contests/cubits/'
       'match_leaderboard_cubit.dart' as mlCubit;
import 'package:fantasy_cricket/pages/contests/cubits/'
       'series_leaderboard_cubit.dart' as slCubit;
import 'package:fantasy_cricket/pages/contests/match_leaderboard.dart';
import 'package:fantasy_cricket/pages/contests/series_leaderboard.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/prize_images_folder.dart';
import 'package:fantasy_cricket/widgets/contests_list_item.dart';
import 'package:fantasy_cricket/widgets/fetch_error_or_message.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContestDetails extends StatelessWidget {
  final ContestDetialsCubit cubit;

  ContestDetails(this.cubit);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContestDetialsCubit, CubitState>(
      bloc: cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else if(state == CubitState.fetchError) {
          return FetchErrorOrMessage();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Contest Details'),
            ),
            body: ListView(
              padding: Paddings.pagePadding,
              children: <Widget>[
                // match info
                ContestsListItem(cubit.excerpt, cubit.series, false),
                SizedBox(height: 30),
                
                // match prize details
                getPrizeDetails(
                  'Match',
                  context,
                  (BuildContext context) => MatchLeaderboard(
                    mlCubit.MatchLeaderBoardCubit(cubit.excerpt, 
                      cubit.user.username)
                  ),
                  cubit.excerpt.totalWinners,
                  cubit.contest.chipsDistributes,
                ),
                SizedBox(height: 20),

                // series prize details
                getPrizeDetails(
                  'Series',
                  context,
                  (BuildContext context) => SeriesLeaderboard(
                    slCubit.SeriesLeaderboardCubit(cubit.series, 
                      cubit.user.username)
                  ),
                  cubit.series.chipsDistributes.last.to,
                  cubit.series.chipsDistributes,
                ),

                // for floating action button
                SizedBox(height: 50),
              ],
            ),
          );
        }
      },
    );
  }

  Column getPrizeDetails(String prizeFor, BuildContext context, 
    Function(BuildContext) builder, int totalWinners, 
    List<Distribute> distributes) {
    return Column(
      children: <Widget>[
        getPrizeHeader(prizeFor, context, builder),
        SizedBox(height: 20),
        getPrizeTotals(totalWinners, distributes),
        Divider(color: Colors.grey),
        getWinnersWiseChipsRows(distributes),
      ],
    );
  }

  Row getPrizeHeader(String prizeFor, BuildContext context, 
    Function(BuildContext) builder) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // prize for name
        Text(
          '$prizeFor Prizes',
          style: TextStyle(fontSize: 16),
        ),

        // leaderboard button
        TextButton(
          style: ButtonStyle(
            shadowColor: MaterialStateProperty.all(Colors.grey.shade100),
            elevation: MaterialStateProperty.all(5),
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.leaderboard,
                color: ColorPallate.ebonyClay,
                size: 15,
              ),
              SizedBox(width: 5),
              Text(
                'Leaderboard',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: builder),
          ),
        ),
      ],
    );
  }

  Column getPrizeTotals(int totalWinners, List<Distribute> distributes) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                getPrizeTotalsImage(prizeImagesFolder + 'winner.png'),
                SizedBox(width: 5),
                Text('$totalWinners Winners'),
              ],
            ),
            Row(
              children: <Widget>[
                getPrizeTotalsImage(prizeImagesFolder + 'coins.png'),
                SizedBox(width: 5),
                Text('${getTotalChips(distributes)} Chips'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Image getPrizeTotalsImage(String imageSrc) {
    return Image.asset(
      imageSrc,
      width: 20,
      height: 20,
      fit: BoxFit.contain,
    );
  }

  Column getWinnersWiseChipsRows(List<Distribute> distributes) {
    final List<Column> distributeRows = <Column>[];
    final int totalDistributes = distributes.length;

    for(int i = 0; i < totalDistributes; i++) {
      final int from = distributes[i].from;
      final int to = distributes[i].to;

      distributeRows.add(Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(from.toString() + getNumberSuffix(from) +
                (from != to ? ' - ' + to.toString() + getNumberSuffix(to) : ''),
              ),
              Text(distributes[i].chips.toString() + ' Chips'),
            ],
          ),
          if(i != totalDistributes - 1) Divider(),
        ],
      ));
    }

    return Column(children: distributeRows);
  }
}
