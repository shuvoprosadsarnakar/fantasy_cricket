import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/pages/user/contest/contest_detials.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/contest_details_cubit.dart'
    as cdCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:fantasy_cricket/resources/strings/ad_units.dart';
import 'package:fantasy_cricket/widgets/contests_list_item.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RunningContests extends StatefulWidget {
  final RunningContestsCubit _cubit;

  RunningContests(this._cubit);

  @override
  _RunningContestsState createState() => _RunningContestsState();
}

class _RunningContestsState extends State<RunningContests> {
  BannerAd _bannerAd;

  bool _isBannerAdReady = false;

  @override
  void initState() {
    createAndLoadAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      floatingActionButton: _isBannerAdReady ? Container(
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd),
      ) : null,
      floatingActionButtonLocation: 
        FloatingActionButtonLocation.centerDocked,
      body: BlocBuilder(
        bloc: widget._cubit,
        builder: (BuildContext context, CubitState state) {
          if (state == CubitState.loading) {
            return Loading();
          } else if (state == CubitState.fetchError) {
            return FetchErrorMsg();
          } else {
            final List<InkWell> listItems = _getListItems(context);
            final int totalItems = listItems.length;

            if (totalItems > 0) {
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 70),
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
                child: Text(
                  'No running contest found for you to join.',
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
    final List<Excerpt> runningContestsExcerpts = <Excerpt>[];
    final List<Series> runningContestsSerieses = <Series>[];
    final List<InkWell> listItems = <InkWell>[];

    // init [runningContestsExcerpts] & [runningContestsSerieses] variables
    widget._cubit.notEndedSerieses.forEach((Series series) {
      series.matchExcerpts.forEach((Excerpt excerpt) {
        if (excerpt.status == ContestStatuses.running &&
            widget._cubit.user.contestIds.contains(excerpt.id) == false) {
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
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return ContestDetails(cdCubit.ContestDetialsCubit(
                runningContestsSerieses[i],
                runningContestsExcerpts[i],
                widget._cubit.user,
              ));
            },
          ));

          // rebuild UI to update running contests list if user has joined the
          // contest
          widget._cubit.rebuildUi();
        },
      ));
    }

    return listItems;
  }

  void createAndLoadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.banner,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          print('Banner ad loaded');
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
  }
}
