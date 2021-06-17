import 'package:fantasy_cricket/pages/contests/cubits/contest_ender_cubit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/form_dropdown_field.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_integer_field.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContestEnder extends StatelessWidget {
  final ContestEnderCubit _cubit;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  ContestEnder(this._cubit);

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
            key: scaffoldKey,
            appBar: AppBar(title: Text('End Contest')),
            body: SingleChildScrollView(
              padding: Paddings.pagePadding,
              child: Form(
                key: _cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // team 1 report form fields
                    getTeamNameAndScoreField(_cubit.contest.teamsNames[0], 0, 
                      context, _cubit.contest.teamsScores[0]),
                    SizedBox(height: 20),
                    Divider(),
                    getPlayerReportFields(0, _cubit.contest.team1TotalPlayers),
                    SizedBox(height: 20),

                    // team 2 report form fields
                    getTeamNameAndScoreField(_cubit.contest.teamsNames[1], 1,
                      context, _cubit.contest.teamsScores[1]),
                    SizedBox(height: 20),
                    Divider(),
                    getPlayerReportFields(_cubit.contest.team1TotalPlayers,
                      _cubit.contest.playersNames.length),
                    SizedBox(height: 20),

                    // man of the match field
                    FormFieldTitle('Player of The Match'),
                    SizedBox(height: 5),
                    getPlayerOfTheMatchField(),
                    SizedBox(height: 20),

                    // match result field
                    FormFieldTitle('Result'),
                    SizedBox(height: 5),
                    getMatchResultField(context),
                    SizedBox(height: 20),

                    // is series ended checkbox
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _cubit.isSeriesEnded, 
                          onChanged: (bool value) {
                            _cubit.isSeriesEnded = value;
                            _cubit.rebuild();
                          },
                        ),
                        FormFieldTitle('Series Ended'),
                      ],
                    ),
                    SizedBox(height: 20),

                    // form buttons
                    getUpdateContestButton(context),
                    SizedBox(height: 10),
                    getFormSubmitButton(context),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Row getTeamNameAndScoreField(String name, int scoreIndex,
    BuildContext context, String initialValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        SizedBox(
          width: 150,
          child: FormTextField(
            hintText: 'Score',
            initialValue: initialValue,
            validator: (String value) {
              if(value == null || value.trim().isEmpty) {
                return 'Team score is required.';
              } else {
                return null;
              }
            },
            onSaved: (String value) {
              _cubit.contest.teamsScores[scoreIndex] = value;
            }
          ),
        ),
      ],
    );
  }

  Column getPlayerReportFields(int start, int end) {
    final List<Column> playerReportRows = <Column>[];
    final int totalReportFields = _cubit.reportKeys.length;
    
    for(int i = start; i < end; i++) {
      playerReportRows.add(Column(
        children: <Widget>[
          ListTile(
            title: Text(_cubit.contest.playersNames[i]),
            subtitle: Text(_cubit.contest.playersRoles[i]),
          ),

          Row(
            children: <Widget>[
              for(int j = 0; j < totalReportFields; j++) Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(mapKeyToFieldTitle(_cubit.reportKeys[j])),
                      SizedBox(
                        width: 100,
                        child: FormIntegerField(
                          initialValue:
                            (_cubit.playersReports[i][_cubit.reportKeys[j]] != null 
                            ? _cubit.playersReports[i][_cubit.reportKeys[j]] : 0)
                            .toString(),
                          onSaved: (String value) {
                          _cubit.playersReports[i][_cubit.reportKeys[j]] = 
                            int.parse(value);
                        }),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
          Divider(),
        ],
      ));
    }

    return Column(children: playerReportRows);
  }

  FormDropdownField getPlayerOfTheMatchField() {
    List<DropdownMenuItem<String>> dropdownItems = _cubit.contest.playersNames
      .map((String name) {
        return DropdownMenuItem<String>(
          value: name,
          child: Text(name),
        );
      }).toList();

    return FormDropdownField(
      hint: Text('Select player of the match'),
      items: dropdownItems,
      value: _cubit.contest.playerOfTheMatch,
      // validator: (dynamic value) {
      //   if(value == null) {
      //     return 'Player of the match is required.';
      //   } else {
      //     return null;
      //   }
      // },
      onSaved: (dynamic value) => _cubit.contest.playerOfTheMatch = value,
    );
  }

  FormTextField getMatchResultField(BuildContext context) {
    return FormTextField(
      initialValue: _cubit.contest.result,
      // validator: (String value) {
      //   if(value == null || value.trim().isEmpty) {
      //     return 'Match result is required.';
      //   } else {
      //     return null;
      //   }
      // },
      onSaved: (String value) {
        _cubit.contest.result = value;
      }
    );
  }

  SizedBox getFormSubmitButton(BuildContext context) {
    final BuildContext oldContext = context;

    return SizedBox(
      width: double.maxFinite,
      child: FormSubmitButton(
        title: 'End Contest',
        onPressed: () {
          showDialog(
            context: context, 
            builder: (BuildContext context) {
              return Center(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Are you sure to end the contest?',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            TextButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                foregroundColor: MaterialStateProperty.all(
                                  ColorPallate.pomegranate
                                ),
                                backgroundColor: 
                                  MaterialStateProperty.all(Colors.white),
                              ),
                              child: Text('No'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 20),
                            TextButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                foregroundColor: MaterialStateProperty.all(
                                  ColorPallate.pomegranate
                                ),
                                backgroundColor: 
                                  MaterialStateProperty.all(Colors.white),
                              ),
                              child: Text('Yes'),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                if(await _cubit.endContest()) {
                                  if(_cubit.state == CubitState.failed) {
                                    ScaffoldMessenger
                                      .of(context)
                                      .showSnackBar(SnackBar(
                                        content: Text(
                                          'Failed to end contest, try again.'
                                        ),
                                      ));
                                  } else {
                                    Navigator
                                      .of(oldContext)
                                      .pop('Contest ended successfully.');
                                  }
                                }
                              }
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  SizedBox getUpdateContestButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: FormSubmitButton(
        title: 'Update Contest',
        onPressed: () async {
          await _cubit.updateContest();

          if(_cubit.state == CubitState.failed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to update contest, try again.'),
            ));
          } else if(_cubit.state == CubitState.updated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Contest updated successfully.'),
            ));
          }
        },
      ),
    );
  }

  String mapKeyToFieldTitle(String mapKey) {
    int length = mapKey.length;
    String capitalized = mapKey[0].toUpperCase();

    for(int i = 1; i < length; i++) {
      int codeUnit = mapKey[i].codeUnits[0];
      
      if(codeUnit >= 65 && codeUnit <= 90) {
        capitalized += ' ';
      }
      
      capitalized += mapKey[i];
    }

    return capitalized;
  }
}
