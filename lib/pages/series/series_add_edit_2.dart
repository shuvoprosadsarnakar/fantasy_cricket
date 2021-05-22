import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/series/cubits/series_add_edit_2_cubit.dart';
import 'package:fantasy_cricket/pages/series/cubits/series_add_edit_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/resources/match_types.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/form_dropdown_field.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_integer_field.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesAddEdit2 extends StatelessWidget {
  // variable to manage state of this screen
  final SeriesAddEdit2Cubit _cubit;
  
  // dropdown items for type dropdown field
  final List<DropdownMenuItem<dynamic>> _typeDropdownList 
    = <DropdownMenuItem<dynamic>>[];

  SeriesAddEdit2(this._cubit) {
    MatchTypes.list.forEach((String type) {
      _typeDropdownList.add(DropdownMenuItem<String>(
        value: type,
        child: Text(type),  
      ));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeriesAddEdit2Cubit, AddEditStatus>(
      bloc: _cubit,
      builder: (BuildContext context, AddEditStatus status) {
        if(status == AddEditStatus.loading) {
          return Loading();
        } else if(status == AddEditStatus.fetchError) {
          return FetchErrorMsg();
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(_cubit.series.id == null ? 
              'Add Series' : 'Update Series')),
            body: Form(
              key: _cubit.formKey,
              child: ListView(
                padding: Paddings.pagePadding,
                children: [
                  FormFieldTitle('Matche Excerpts'),
                  Divider(),
                  SizedBox(height: 20),
                  getMatchExcerptsFields(context),
                  getMatchExcerptsButtons(),
                  SizedBox(height: 20),
                  getFormSubmitButton(context),
                ],
              ),
            ),
          ); 
        }
      }
    );
  }

  Padding getMatchExcerptTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Text(
        '$title : ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Column getMatchExcerptsFields(BuildContext context) {
    final List<Column> matchExcerptWidgets = <Column>[];
    
    // dropdown items for team dropdown fields
    final List<DropdownMenuItem<String>> teamDropdownList = 
      _cubit.allTeams.map((Team team) {
        return DropdownMenuItem<String>(
          value: team.id,
          child: Text(team.name),
        );
      }).toList();

    _cubit.series.matchExcerpts.forEach((Excerpt excerpt) {
      matchExcerptWidgets.add(Column(children: [
        // type field
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 17),
            getMatchExcerptTitle('Type'),
            Expanded(child: FormDropdownField(
              value: excerpt.type,
              hint: Text('Select a match type'),
              items: _typeDropdownList,
              validator: (dynamic value) {
                if(value == null) {
                  return 'Match type is required.';
                } else {
                  return null;
                }
              },
              onSaved: (dynamic value) => excerpt.type = value,
            )),
          ],
        ),
        SizedBox(height: 10),

        // number field
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 30),
            getMatchExcerptTitle('No'),
            Expanded(child: FormIntegerField(
              initialValue: excerpt.no == null ? null : excerpt.no.toString(),
              hintText: 'Match number according to type',
              onSaved: (String value) => excerpt.no = int.parse(value),
            )),
          ],
        ),
        SizedBox(height: 10),

        // team 1 name field
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getMatchExcerptTitle('Team 1'),
            Expanded(child: FormDropdownField(
              value: excerpt.teamsIds[0],
              hint: Text('Select a team'),
              items: teamDropdownList,
              validator: (dynamic value) { 
                if(value == null) {
                  return 'Team 1 is required.';
                } else {
                  // save the value here instead of [onSaved] allow us to check
                  // same team selection error in the team 2 field [validator]
                  // as team 2 [validator] will run after this [validator]
                  excerpt.teamsIds[0] = value;
                  return null;
                }
              },
              onSaved: (dynamic value) {
                excerpt.teamsNames[0] = _cubit.getTeamNameById(value);
                excerpt.teamImages[0] = _cubit.allTeams.firstWhere((Team team) {
                  return team.name == excerpt.teamsNames[0];
                }).photo;
              },
            )),
          ],
        ),
        SizedBox(height: 10),

        // team 2 name field
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getMatchExcerptTitle('Team 2'),
            Expanded(child: FormDropdownField(
              value: excerpt.teamsIds[1],
              hint: Text('Select a team'),
              items: teamDropdownList,
              validator: (dynamic value) {
                if(value == null) {
                  return 'Team 2 is required.';
                } else if(value == excerpt.teamsIds[0]) {
                  return 'Two teams can\'t be same.';
                } else {
                  return null;
                }
              },
              onSaved: (dynamic value) {
                excerpt.teamsIds[1] = value;
                excerpt.teamsNames[1] = _cubit.getTeamNameById(value);
                excerpt.teamImages[1] = _cubit.allTeams.firstWhere((Team team) {
                  return team.name == excerpt.teamsNames[1];
                }).photo;
              },
            )),
          ],
        ),
        SizedBox(height: 10),

        // time picker field
        DateTimePicker(
          type: DateTimePickerType.dateTime,
          initialValue: excerpt.startTime == null ? 
            _cubit.series.times.start.toDate().toString() : 
            excerpt.startTime.toDate().toString(),
          firstDate: _cubit.series.times.start.toDate(),
          lastDate: _cubit.series.times.end.toDate(),
          dateLabelText: 'Starting Time',
          validator: (String value) {
            if(value.isEmpty) {
              return 'Starting time is required.';
            } else {
              return null;
            }
          },
          onSaved: (String value) {
            excerpt.startTime = Timestamp.fromDate(DateTime.parse(value));
          }
        ),
        SizedBox(height: 30), 
      ]));
    });

    return Column(children: matchExcerptWidgets);
  }

  Row getMatchExcerptsButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // remove button
        if(_cubit.series.matchExcerpts.length > 1 && 
          _cubit.series.matchExcerpts.last.id == null) 
        Row(children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: _cubit.removeMatchExcerpt,
          ),
          SizedBox(width: 30),
        ]),

        // add button
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _cubit.addMatchExcerpt,
        )
      ],
    );
  }

  FormSubmitButton getFormSubmitButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Submit',
      onPressed: () async {
        if(await _cubit.addUpdateSeriesInfo(context)) {
          String snackBarMsg;

          if (_cubit.state == AddEditStatus.updated) {
            snackBarMsg = 'Series is updated successfully.';
          } else if (_cubit.state == AddEditStatus.failed) {
            snackBarMsg = 'Failed to perform task, please try again.';
          } else if (_cubit.state == AddEditStatus.duplicate) {
            snackBarMsg = 'Series name already exist.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(snackBarMsg))
          );
        }
      },
    );
  }
}
