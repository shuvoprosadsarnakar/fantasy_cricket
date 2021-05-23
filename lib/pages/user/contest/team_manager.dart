import 'package:fantasy_cricket/helpers/role_image_finder.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/team_manager_cubit.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamManager extends StatelessWidget {
  final TeamManagerCubit _cubit;

  TeamManager(this._cubit);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading || _cubit.state == CubitState.added || 
          _cubit.state == CubitState.updated) {
          return Loading();
        } else if(state == CubitState.fetchError) {
          return FetchErrorMsg();
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Team Manager')),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Column(children: [
                    getPlayerSelectionResultBarOne(),
                    Divider(),
                    getPlayerSelectionResultBarTwo(),
                    Divider(color: Colors.grey.shade900),
                  ]),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 20),
                      getTeam1Players(context),
                      SizedBox(height: 30),
                      getTeam2Players(context),
                      SizedBox(height: 20),
                      if(_cubit.fantasy.playerNames.length == 11 &&
                        _cubit.fantasy.captain != null && 
                        _cubit.fantasy.viceCaptain != null) 
                        getTeamSubmitButton(context),
                      if(_cubit.fantasy.playerNames.length == 11 &&
                        _cubit.fantasy.captain != null && 
                        _cubit.fantasy.viceCaptain != null) 
                        SizedBox(height: 30),
                    ],
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
          _cubit.contest.teamsNames[0],
          _cubit.team1TotalPlayers.toString(),
        ),
        getSelectionResultColumn(
          'Players',
          _cubit.fantasy.playerNames.length.toString() + '/11',
        ),
        getSelectionResultColumn(
          'Credits',
          _cubit.creditsLeft.toString() + '/100.0',
        ),
        getSelectionResultColumn(
          _cubit.contest.teamsNames[1],
          _cubit.team2TotalPlayers.toString(),
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
        Text('BAT (${_cubit.totalBatsmans})'),
        Text('WK (${_cubit.totalWicketKeepers})'),
        Text('AR (${_cubit.totalAllRounders})'),
        Text('BOWL (${_cubit.totalBowlers})'),
      ],
    );
  }

  Column getTeam1Players(BuildContext context) {
    List<Widget> playersRows = <Widget>[];
    
    for(int i = 0; i < _cubit.contest.team1TotalPlayers; i++) {
      playersRows.add(getPlayerRow(context, i));
      playersRows.add(Divider());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTeamName(_cubit.excerpt.teamImages[0], _cubit.contest.teamsNames[0], 
          context),
        SizedBox(height: 20),
        getPlayerFieldTitles(),
        Divider(color: Colors.grey),
        Column(children: playersRows),
      ],
    );
  }

  Column getTeam2Players(BuildContext context) {
    List<Widget> playersRows = <Widget>[];
    int totalPlayers = _cubit.contest.playersNames.length;

    for(int i = _cubit.contest.team1TotalPlayers; i < totalPlayers; i++) {
      playersRows.add(getPlayerRow(context, i));
      playersRows.add(Divider());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTeamName(_cubit.excerpt.teamImages[1], _cubit.contest.teamsNames[1], 
          context),
        SizedBox(height: 20),
        getPlayerFieldTitles(),
        Divider(color: Colors.grey),
        Column(children: playersRows),
      ],
    );
  }

  Row getTeamName(String imageLink, String name, BuildContext context) {
    return Row(
      children: [
        Image.network(
          imageLink,
          width: 40,
          height: 40,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
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
    String playerName = _cubit.contest.playersNames[i];
    String playerRole = _cubit.contest.playersRoles[i];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(_cubit.contest.playerPhotos[i] ?? ''),
        ),
        SizedBox(width: 10),
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
              Text('${_cubit.contest.playersCredits[i]} Credits'),
              SizedBox(height: 5),
              Text('${_cubit.series.playerPoints[_cubit.series.playerNames
                .indexOf(playerName)]} Series Points'),
              SizedBox(height: 5),
              Text('Picked by ${_cubit.getPlayerPickedPercentage(i)}%'),
              if(_cubit.contest.isPlayings[i]) SizedBox(height: 5),
              if(_cubit.contest.isPlayings[i]) 
                Text('Playing', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
        SizedBox(width: 10),
        
        // captain field
        Expanded(child: Checkbox(
          value: playerName == _cubit.fantasy.captain ? true : false,
          onChanged: (bool value) {
            if(playerName == _cubit.fantasy.viceCaptain) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Captain and vice captain can\'t be same.'),
              ));
            } else if(_cubit.fantasy.playerNames.contains(playerName) == false) 
              {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Captain can\'t be an unselected player.'),
              ));
            } else {
              _cubit.fantasy.captain = playerName;
              _cubit.rebuildUi();
            }
          },
        )),
        SizedBox(width: 10),
        
        // vice captain field
        Expanded(child: Checkbox(
          value: playerName == _cubit.fantasy.viceCaptain ? true : false,
          onChanged: (bool value) {
            if(playerName == _cubit.fantasy.captain) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Captain and vice captain can\'t be same.'),
              ));
            } else if(_cubit.fantasy.playerNames.contains(playerName) == false) 
              {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Vice captain can\'t be an unselected player.'),
              ));
            } else {
              _cubit.fantasy.viceCaptain = playerName;
              _cubit.rebuildUi();
            }
          },
        )),
        SizedBox(width: 10),

        // slection field
        Expanded(child: Checkbox(
          value: _cubit.fantasy.playerNames.contains(playerName),
          onChanged: (bool value) {
            if(value) {
              String snackBarText;

              if(_cubit.fantasy.playerNames.length == 11) {
                snackBarText = '11 player is selected. Can\'t add more player';
              } else if((i < _cubit.contest.team1TotalPlayers && _cubit.team1TotalPlayers == 7) ||
                (i >= _cubit.contest.team1TotalPlayers && _cubit.team2TotalPlayers == 7)) {
                snackBarText = 'Maximum 7 players can be added from a team.';
              } else if(_cubit.creditsLeft - _cubit.contest.playersCredits[i] < 0) {
                snackBarText = 'Not enough credits to add the player.';
              } else if(playerRole == 'Batsman' && _cubit.totalBatsmans == 5){
                snackBarText = 'Can\'t add more than five batsmen.';
              } else if(playerRole == 'Wicket Keeper' && _cubit.totalWicketKeepers == 2) {
                snackBarText = 'Can\'t add more than two wicket keepers.';
              } else if(playerRole == 'All Rounder' && _cubit.totalAllRounders == 3) {
                snackBarText = 'Can\'t add more than 3 all rounders.';
              } else if(playerRole == 'Bowler' && _cubit.totalBowlers == 5) {
                snackBarText = 'Can\'t add more than five bowlers.';
              } else if(_cubit.fantasy.playerNames.length == 10 && 
                _cubit.totalWicketKeepers == 0 && 
                playerRole != 'Wicket Keeper') {
                snackBarText = 'Have to select 1 wicket keeper minimum.';
              } else {
                _cubit.addPlayer(i);
              }

              if(snackBarText != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(snackBarText)
                ));
              }
            } else {
              _cubit.removePlayer(i);
            }

            _cubit.rebuildUi();
          },
        )),
      ],
    );
  }

  FormSubmitButton getTeamSubmitButton(BuildContext context) {
    String buttonText;

    if(_cubit.user.contestIds.contains(_cubit.contest.id)) {
      buttonText = 'Update Team';
    } else {
      buttonText = 'Create Team';
    }
    
    return FormSubmitButton(
      title: buttonText,
      onPressed: () async {
        await _cubit.addOrUpdateFantasy();

        String snackBarText;

        if(_cubit.state == CubitState.addFailed) {
          snackBarText = 'Failed to add team, try again.';
        } else if(_cubit.state == CubitState.updateFailed) {
          snackBarText = 'Failed to update team, try again.';
        } else if(_cubit.state == CubitState.added) {
          snackBarText = 'Team is added successfully.';
        } else if(_cubit.state == CubitState.updated) {
          snackBarText = 'Team is updated successfully.';
        } else if(_cubit.state == CubitState.timeOver) {
          snackBarText = 'Team submition time is over.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarText),
        ));

        if(_cubit.state == CubitState.added || 
          _cubit.state == CubitState.updated) {
          Navigator.pop(context);
        }
      },
    );
  }
}
