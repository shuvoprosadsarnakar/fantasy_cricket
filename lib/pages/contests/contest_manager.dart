import 'package:fantasy_cricket/pages/contests/cubits/contest_manager_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/form_distributes_field.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// this screen is used to run, update and lock contest

class ContestManager extends StatelessWidget {
  final ContestManagerCubit _cubit;

  ContestManager(this._cubit);

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
          return Scaffold(
            appBar: AppBar(title: Text(_cubit.contest.id == null ? 
              'Run Contest' : 'Update or Lock Contest')),
            body: SingleChildScrollView(
              padding: Paddings.pagePadding,
              child: Form(
                key: _cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // chips distributes fields
                    FormDistributesField(
                      _cubit.contest.chipsDistributes,
                      _cubit.addChipsDistribute,
                      _cubit.removeChipsDistribute,
                    ),
                    SizedBox(height: 10),

                    // players info fields
                    FormFieldTitle('Players Info'),
                    SizedBox(height: 10),
                    getPlayersInfoFields(context),
                    SizedBox(height: 10),

                    // form submit button
                    _cubit.contest.id == null ? getRunContestButton(context) :
                      Column(children: [
                        getContestUpdaterButton(context),
                        SizedBox(height: 10),
                        getContestLockerButton(context),
                      ])
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Column getTeamNameAndFieldTitles(String teamName, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // team name
        SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            '$teamName',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,  
            ), 
          ),
        ),
        SizedBox(height: 20),
        
        // players info fields titles
        Row(children:[
          Expanded(
            flex: 2,
            child: Text(
              'Player',
              style: TextStyle(fontSize: 14),  
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Text('Credits'),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Text('Is Playing'),
          ),
        ]),
        Divider(),
      ],
    );
  }

  Column getPlayersInfoFields(BuildContext context) {
    List<Widget> infoTiles = [
      // first team name with players info field titles
      getTeamNameAndFieldTitles(_cubit.contest.teamsNames[0], context)
    ];
    
    int totalPlayers = _cubit.contest.playersNames.length;

    for(int i = 0; i < totalPlayers; i++) {
      // second team name with players info field titles
      if(i == _cubit.contest.team1TotalPlayers) {
        infoTiles.add(getTeamNameAndFieldTitles(
          _cubit.contest.teamsNames[1], context));
      }
      
      infoTiles.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // player name and role
                Text(
                  _cubit.contest.playersNames[i],
                  style: TextStyle(fontSize: 16),  
                ),
                SizedBox(height: 5),
                Text(_cubit.contest.playersRoles[i]),
              ],
            ),
          ),
          SizedBox(width: 10),
          
          // player credits field
          Expanded(
            flex: 1,
            child: SizedBox(
              child: FormTextField(
                initialValue: _cubit.contest.playersCredits[i] == null ? null :
                  _cubit.contest.playersCredits[i].toString(),
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if(value.isEmpty) {
                    return 'Player credits is required.';
                  }

                  try {
                    double.parse(value);
                  } catch(error) {
                    return 'Enter a valid double.';
                  }

                  return null;
                },
                onSaved: (String value) {
                  _cubit.contest.playersCredits[i] = double.parse(value);
                },
              ),
              width: 50,
            ),
          ),
          SizedBox(width: 10),

          // player is playing field
          Expanded(
            flex: 1,
            child: Checkbox(
              value: _cubit.contest.isPlayings[i],
              onChanged: (bool value) {
                _cubit.contest.isPlayings[i] = value;
                _cubit.changeIsPlaying();
              },
            ),
          ),
        ],
      ));

      infoTiles.add(Divider());
    }

    return Column(children: infoTiles);
  }

  SizedBox getRunContestButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: FormSubmitButton(
        title: 'Run Contest',
        onPressed: () async {
          if(await _cubit.runContest()) {
            if(_cubit.state == CubitState.failed) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to run contest, try again.'),
              ));
            } else {
              Navigator.pop(context, 'Contest run successfully.');
            }
          }
        },
      ),
    );
  }

  SizedBox getContestUpdaterButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: FormSubmitButton(
        title: 'Update Contest',
        onPressed: () async {
          if(await _cubit.updateContest()) {
            String snackBarText;

            if(_cubit.state == CubitState.failed) {
              snackBarText = 'Failed to update contest, try again.';
            } else {
              snackBarText = 'Contest updated successfully.';
            }

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(snackBarText),
            ));
          }
        },
      ),
    );
  }

  SizedBox getContestLockerButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: FormSubmitButton(
        title: 'Lock Contest',
        onPressed: () async {
          if(await _cubit.lockContest()) {
            if(_cubit.state == CubitState.failed) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to lock contest, try again.'),
              ));
            } else {
              Navigator.pop(context, 'Contest locked successfully.');
            }
          }
        },
      ),
    );
  }
}
