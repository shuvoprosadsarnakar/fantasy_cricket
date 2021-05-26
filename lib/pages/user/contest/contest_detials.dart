import 'package:fantasy_cricket/helpers/number_suffix_finder.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/contest_details_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/match_leaderboard_cubit.dart'
    as mlCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart'
    as rcCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/series_leaderboard_cubit.dart'
    as slCubit;
import 'package:fantasy_cricket/pages/user/contest/cubits/team_manager_cubit.dart'
    as tmCubit;
import 'package:fantasy_cricket/pages/user/contest/match_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/series_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/team_manager.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:fantasy_cricket/resources/strings/ad_units.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class ContestDetails extends StatefulWidget {
  final ContestDetialsCubit _cubit;

  ContestDetails(this._cubit);

  @override
  _ContestDetailsState createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
  bool _isButtonDisabled = true;
  bool _isRewardedAdReady = false;
  RewardedAd _rewardedAd;
  final RewardedAd myRewarded = RewardedAd(
    adUnitId: rewarded,
    request: AdRequest(),
    listener: AdListener(
      onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
        print(reward.type);
        print(reward.amount);
      },
      onAdLoaded: (ad) {
        print("Ad loaded");
      },
      onAdFailedToLoad: (ad, error) {
        print("Ad failed to load");
      },
    ),
  );
  @override
  void initState() {
    super.initState();
    createReawrdAdAndLoad();
  }

@override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget._cubit,
      builder: (BuildContext context, CubitState state) {
        if (state == CubitState.loading) {
          return Loading();
        } else if (state == CubitState.fetchError) {
          return FetchErrorMsg();
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Contest Details')),
            body: ListView(
              padding: Paddings.pagePadding,
              children: [
                _getContestDetilsHeader(),
                Divider(color: Colors.grey.shade900, height: 30),
                _getMatchPrizes(context),
                SizedBox(height: 20),
                _getSeriesPrizes(context),
                SizedBox(height: 50), // for floating action button
              ],
            ),
            floatingActionButton:
                widget._cubit.excerpt.status == ContestStatuses.running
                    ? _getJoinContestButton(context)
                    : null,
          );
        }
      },
    );
  }

  Row _getContestDetilsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getTeamImage(widget._cubit.excerpt.teamImages[0]),
        SizedBox(width: 10),
        Expanded(
          child: Column(children: [
            Text(
              widget._cubit.excerpt.teamsNames[0] +
                  ' X ' +
                  widget._cubit.excerpt.teamsNames[1],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 7),
            Text(
              widget._cubit.excerpt.no.toString() +
                  NumberSuffixFinder.getNumberSuffix(widget._cubit.excerpt.no) +
                  ' ' +
                  widget._cubit.excerpt.type +
                  ' Match',
            ),
            SizedBox(height: 7),
            Text(
              widget._cubit.series.name,
            ),
            SizedBox(height: 7),
            Text(
              DateFormat.yMMMd()
                  .add_jm()
                  .format(widget._cubit.excerpt.startTime.toDate()),
            ),
          ]),
        ),
        SizedBox(width: 10),
        _getTeamImage(widget._cubit.excerpt.teamImages[1]),
      ],
    );
  }

  Image _getTeamImage(String imageLink) {
    return Image.network(
      imageLink,
      height: 35,
      width: 35,
      fit: BoxFit.cover,
    );
  }

  Column _getMatchPrizes(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Match Prizes',
            style: TextStyle(fontSize: 16),
          ),
          TextButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(5),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.leaderboard,
                  color: ColorPallate.ebonyClay,
                  size: 15,
                ),
                SizedBox(width: 3),
                Text(
                  'Leaderboard',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return MatchLeaderboard(mlCubit.MatchLeaderBoardCubit(
                    widget._cubit.excerpt, widget._cubit.user));
              },
            )),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'lib/resources/images/winner.png',
                width: 17,
                height: 17,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Text('${widget._cubit.excerpt.totalWinners} Winners'),
            ],
          ),
          Row(
            children: [
              Image.asset(
                'lib/resources/images/coins.png',
                width: 34,
                height: 34,
                fit: BoxFit.cover,
              ),
              Text('${widget._cubit.excerpt.totalChips} Chips'),
            ],
          ),
        ],
      ),
      Divider(color: Colors.grey),
      _getWinnersWiseChipsRows(widget._cubit.contest.chipsDistributes),
    ]);
  }

  Column _getSeriesPrizes(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Series Prizes',
            style: TextStyle(fontSize: 16),
          ),
          TextButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(5),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.leaderboard,
                  color: ColorPallate.ebonyClay,
                  size: 15,
                ),
                SizedBox(width: 3),
                Text(
                  'Leaderboard',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return SeriesLeaderboard(slCubit.SeriesLeaderboardCubit(
                  widget._cubit.series,
                  widget._cubit.user,
                ));
              },
            )),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'lib/resources/images/winner.png',
                width: 17,
                height: 17,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 8),
              Text('${widget._cubit.series.chipsDistributes.last.to} Winners'),
            ],
          ),
          Row(
            children: [
              Image.asset(
                'lib/resources/images/coins.png',
                width: 34,
                height: 34,
                fit: BoxFit.cover,
              ),
              Text(rcCubit.RunningContestsCubit.getSeriesTotalChips(
                          widget._cubit.series)
                      .toString() +
                  ' Chips'),
            ],
          ),
        ],
      ),
      Divider(color: Colors.grey),
      _getWinnersWiseChipsRows(widget._cubit.series.chipsDistributes),
    ]);
  }

  Column _getWinnersWiseChipsRows(List<Distribute> distributes) {
    List<Column> distributeRows = <Column>[];
    int totalDistributes = distributes.length;

    for (int i = 0; i < totalDistributes; i++) {
      int from = distributes[i].from;
      int to = distributes[i].to;

      distributeRows.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                from.toString() +
                    NumberSuffixFinder.getNumberSuffix(from) +
                    (from != to
                        ? ' - ' +
                            to.toString() +
                            NumberSuffixFinder.getNumberSuffix(to)
                        : ''),
              ),
              Text(distributes[i].chips.toString() + ' Chips'),
            ],
          ),
          Divider(),
        ],
      ));
    }

    return Column(children: distributeRows);
  }

  Widget _getJoinContestButton(BuildContext context) {
    String buttonText;

    if (widget._cubit.user.contestIds.contains(widget._cubit.excerpt.id)) {
      buttonText = 'Update Team';
    } else {
      buttonText = 'Create Team';
    }

    return TextButton(
      child: Text(buttonText),
      style: ButtonStyle(
        backgroundColor: _isButtonDisabled
            ? MaterialStateProperty.all(Colors.grey)
            : MaterialStateProperty.all(Colors.red),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        elevation: MaterialStateProperty.all(5),
      ),
      onPressed: () {
        //myRewarded.show();
        if (!_isButtonDisabled) {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return TeamManager(tmCubit.TeamManagerCubit(widget._cubit.series,
                  widget._cubit.user, widget._cubit.excerpt));
            },
          ));
        } else {
          myRewarded.show();
          print("show ad");
          //createReawrdAdAndLoad();
        }

        // rebuild UI to change button text if user has joined contest
        widget._cubit.rebuildUi();
      },
    );
  }

  createReawrdAdAndLoad() {
    _rewardedAd = RewardedAd(
      adUnitId: rewarded,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isRewardedAdReady = true;
            _rewardedAd.show();
            //_isButtonDisabled = false;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a rewarded ad: ${err.message}');
          _isRewardedAdReady = false;
          //ad.dispose();
        },
        onAdClosed: (_) {
          setState(() {
            _isRewardedAdReady = false;
          });
          _rewardedAd.load();
        },
        onRewardedAdUserEarnedReward: (_, reward) {
          _isButtonDisabled = false;
        },
      ),
    );

    _rewardedAd.load();
  }
}
