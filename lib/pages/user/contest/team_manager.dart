import 'package:fantasy_cricket/helpers/role_image_finder.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/team_manager_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/review_team.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/strings/ad_units.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TeamManager extends StatefulWidget {
  final TeamManagerCubit _cubit;

  TeamManager(this._cubit);

  @override
  _TeamManagerState createState() => _TeamManagerState();
}

class _TeamManagerState extends State<TeamManager> {

  RewardedAd _rewardedAd;
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
        if (state == CubitState.loading ||
            widget._cubit.state == CubitState.added ||
            widget._cubit.state == CubitState.updated) {
          return Loading();
        } else if (state == CubitState.fetchError) {
          return FetchErrorMsg();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Team Manager'),
              actions: <Widget>[
                if (widget._cubit.fantasy.playerNames.isNotEmpty)
                  TextButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(1),
                    ),
                    child: Text(
                      'Review\nTeam',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      widget._cubit.sortPlayersByRole();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ReviewTeam(widget._cubit.contest,
                              widget._cubit.fantasy, widget._cubit.excerpt);
                        },
                      ));
                    },
                  ),
              ],
            ),
            body: Column(
              children: [
                // selection result bars
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(children: [
                    getPlayerSelectionResultBarOne(),
                    Divider(),
                    getPlayerSelectionResultBarTwo(),
                  ]),
                ),

                // player selection rows
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: ColorPallate.mercury,
                        automaticallyImplyLeading: false,
                        toolbarHeight: 54,
                        bottom: TabBar(
                          labelColor: ColorPallate.ebonyClay,
                          indicatorColor: Colors.grey,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          tabs: <Widget>[
                            getTeamName(widget._cubit.excerpt.teamImages[0],
                                widget._cubit.contest.teamsNames[0], context),
                            getTeamName(widget._cubit.excerpt.teamImages[1],
                                widget._cubit.contest.teamsNames[1], context),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: <Widget>[
                          ListView(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            children: <Widget>[
                              getTeam1Players(context),
                              SizedBox(height: 20),
                              if (widget._cubit.fantasy.playerNames.length ==
                                      11 &&
                                  widget._cubit.fantasy.captain != null &&
                                  widget._cubit.fantasy.viceCaptain != null)
                                getTeamSubmitButton(context),
                            ],
                          ),
                          ListView(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 30,
                            ),
                            children: <Widget>[
                              getTeam2Players(context),
                              SizedBox(height: 20),
                              if (widget._cubit.fantasy.playerNames.length ==
                                      11 &&
                                  widget._cubit.fantasy.captain != null &&
                                  widget._cubit.fantasy.viceCaptain != null)
                                getTeamSubmitButton(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Row getPlayerSelectionResultBarOne() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        getSelectionResultColumn(
          widget._cubit.contest.teamsNames[0],
          widget._cubit.team1TotalPlayers.toString(),
        ),
        getSelectionResultColumn(
          'Players',
          widget._cubit.fantasy.playerNames.length.toString() + '/11',
        ),
        getSelectionResultColumn(
          'Credits',
          widget._cubit.creditsLeft.toString() + '/100.0',
        ),
        getSelectionResultColumn(
          widget._cubit.contest.teamsNames[1],
          widget._cubit.team2TotalPlayers.toString(),
        ),
      ],
    );
  }

  Column getSelectionResultColumn(String title, String value) {
    return Column(children: [
      Text(title),
      SizedBox(height: 5),
      Text(value),
    ]);
  }

  Row getPlayerSelectionResultBarTwo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('BAT (${widget._cubit.totalBatsmans})'),
        Text('WK (${widget._cubit.totalWicketKeepers})'),
        Text('AR (${widget._cubit.totalAllRounders})'),
        Text('BOWL (${widget._cubit.totalBowlers})'),
      ],
    );
  }

  Column getTeam1Players(BuildContext context) {
    List<Widget> playersRows = <Widget>[];

    for (int i = 0; i < widget._cubit.contest.team1TotalPlayers; i++) {
      playersRows.add(getPlayerRow(context, i));
      if (i != widget._cubit.contest.team1TotalPlayers - 1)
        playersRows.add(Divider());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getPlayerFieldTitles(),
        Divider(color: Colors.grey),
        Column(children: playersRows),
      ],
    );
  }

  Column getTeam2Players(BuildContext context) {
    List<Widget> playersRows = <Widget>[];
    int totalPlayers = widget._cubit.contest.playersNames.length;

    for (int i = widget._cubit.contest.team1TotalPlayers;
        i < totalPlayers;
        i++) {
      playersRows.add(getPlayerRow(context, i));
      if (i != totalPlayers - 1) playersRows.add(Divider());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getPlayerFieldTitles(),
        Divider(color: Colors.grey),
        Column(children: playersRows),
      ],
    );
  }

  Row getTeamName(String imageLink, String name, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          imageLink,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Row getPlayerFieldTitles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: Text('Player')),
        SizedBox(width: 10),
        Expanded(child: Text('C', textAlign: TextAlign.center)),
        SizedBox(width: 10),
        Expanded(child: Text('VC', textAlign: TextAlign.center)),
        SizedBox(width: 10),
        Expanded(child: Icon(Icons.check)),
      ],
    );
  }

  Row getPlayerRow(BuildContext context, int i) {
    String playerName = widget._cubit.contest.playersNames[i];
    String playerRole = widget._cubit.contest.playersRoles[i];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // player's contest info
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playerName,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Image.asset(
                    RoleImageFinder.getRoleImage(playerRole),
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 5),
                  Text(playerRole),
                ],
              ),
              SizedBox(height: 5),
              Text('${widget._cubit.contest.playersCredits[i]} Credits'),
              SizedBox(height: 5),
              Text(
                  '${widget._cubit.series.playerPoints[widget._cubit.series.playerNames.indexOf(playerName)].toStringAsFixed(1)} Series Points'),
              SizedBox(height: 5),
              Text(
                  'Picked by ${widget._cubit.getPlayerPickedPercentage(i).toStringAsFixed(1)}%'),
              if (widget._cubit.contest.isPlayings[i]) SizedBox(height: 5),
              if (widget._cubit.contest.isPlayings[i])
                Text('Playing', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
        SizedBox(width: 10),

        // captain field
        Expanded(
            child: Checkbox(
          value: playerName == widget._cubit.fantasy.captain ? true : false,
          onChanged: (bool value) {
            if (value) {
              if (playerName == widget._cubit.fantasy.viceCaptain) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Captain and vice captain can\'t be same.'),
                ));
              } else if (widget._cubit.fantasy.playerNames
                      .contains(playerName) ==
                  false) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Captain can\'t be an unselected player.'),
                ));
              } else {
                widget._cubit.fantasy.captain = playerName;
                widget._cubit.rebuildUi();
              }
            } else {
              widget._cubit.fantasy.captain = null;
              widget._cubit.rebuildUi();
            }
          },
        )),
        SizedBox(width: 10),

        // vice captain field
        Expanded(
            child: Checkbox(
          value: playerName == widget._cubit.fantasy.viceCaptain ? true : false,
          onChanged: (bool value) {
            if (value) {
              if (playerName == widget._cubit.fantasy.captain) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Captain and vice captain can\'t be same.'),
                ));
              } else if (widget._cubit.fantasy.playerNames
                      .contains(playerName) ==
                  false) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Vice captain can\'t be an unselected player.'),
                ));
              } else {
                widget._cubit.fantasy.viceCaptain = playerName;
                widget._cubit.rebuildUi();
              }
            } else {
              widget._cubit.fantasy.viceCaptain = null;
              widget._cubit.rebuildUi();
            }
          },
        )),
        SizedBox(width: 10),

        // slection field
        Expanded(
            child: Checkbox(
          value: widget._cubit.fantasy.playerNames.contains(playerName),
          onChanged: (bool value) {
            if (value) {
              String snackBarText;

              if (widget._cubit.fantasy.playerNames.length == 11) {
                snackBarText = '11 player is selected. Can\'t add more player';
              } else if ((i < widget._cubit.contest.team1TotalPlayers &&
                      widget._cubit.team1TotalPlayers == 7) ||
                  (i >= widget._cubit.contest.team1TotalPlayers &&
                      widget._cubit.team2TotalPlayers == 7)) {
                snackBarText = 'Maximum 7 players can be added from a team.';
              } else if (widget._cubit.creditsLeft -
                      widget._cubit.contest.playersCredits[i] <
                  0) {
                snackBarText = 'Not enough credits to add the player.';
              } else if (playerRole == 'Batsman' &&
                  widget._cubit.totalBatsmans == 5) {
                snackBarText = 'Can\'t add more than five batsmen.';
              } else if (playerRole == 'Wicket Keeper' &&
                  widget._cubit.totalWicketKeepers == 2) {
                snackBarText = 'Can\'t add more than two wicket keepers.';
              } else if (playerRole == 'All Rounder' &&
                  widget._cubit.totalAllRounders == 3) {
                snackBarText = 'Can\'t add more than 3 all rounders.';
              } else if (playerRole == 'Bowler' &&
                  widget._cubit.totalBowlers == 5) {
                snackBarText = 'Can\'t add more than five bowlers.';
              } else if (widget._cubit.fantasy.playerNames.length == 10 &&
                  widget._cubit.totalWicketKeepers == 0 &&
                  playerRole != 'Wicket Keeper') {
                snackBarText = 'Have to select 1 wicket keeper minimum.';
              } else {
                widget._cubit.addPlayer(i);
              }

              if (snackBarText != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(snackBarText)));
              }
            } else {
              widget._cubit.removePlayer(i);
            }

            widget._cubit.rebuildUi();
          },
        )),
      ],
    );
  }

  FormSubmitButton getTeamSubmitButton(BuildContext context) {
    String buttonText;

    if (widget._cubit.user.contestIds.contains(widget._cubit.contest.id)) {
      buttonText = 'Update Team';
    } else {
      buttonText = 'Create Team';
    }

    return FormSubmitButton(
      title: buttonText,
      onPressed: () async {
        await widget._cubit.addOrUpdateFantasy();

        String snackBarText;

        if (widget._cubit.state == CubitState.addFailed) {
          snackBarText = 'Failed to add team, try again.';
        } else if (widget._cubit.state == CubitState.updateFailed) {
          snackBarText = 'Failed to update team, try again.';
        } else if (widget._cubit.state == CubitState.added) {
          snackBarText = 'Team is added successfully.';
        } else if (widget._cubit.state == CubitState.updated) {
          snackBarText = 'Team is updated successfully.';
        } else if (widget._cubit.state == CubitState.timeOver) {
          snackBarText = 'Team submition time is over.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarText),
        ));

        if (widget._cubit.state == CubitState.added ||
            widget._cubit.state == CubitState.updated) {
          Navigator.pop(context);
        }
      },
    );
  }

  createReawrdAdAndLoad() {
    _rewardedAd = RewardedAd(
      adUnitId: AdHelper.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _rewardedAd.show();
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a rewarded ad: ${err.message}');
          ad.dispose();
        },
        onAdClosed: (_) {

          _rewardedAd.load();
        },
        onRewardedAdUserEarnedReward: (_, reward) {

        },
      ),
    );

    _rewardedAd.load();
  }
}
