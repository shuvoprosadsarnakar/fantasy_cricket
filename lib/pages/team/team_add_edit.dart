import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/team/cubits/team_add_edit_cubit.dart';
import 'package:fantasy_cricket/widgets/fetch_error_msg.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Stateful widget is taken instead of Stateless to dispose form field 
// controllers
class TeamAddEdit extends StatefulWidget {
  final TeamAddEditCubit _cubit;

  TeamAddEdit(this._cubit);

  @override
  _TeamAddEditState createState() => _TeamAddEditState(_cubit);
}

class _TeamAddEditState extends State<TeamAddEdit> {
  final TeamAddEditCubit _cubit;

  _TeamAddEditState(this._cubit);

  @override
  void dispose() {
    _cubit.teamNameController.dispose();
    _cubit.addPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamAddEditCubit, AddEditStatus>(
      bloc: _cubit,
      builder: (BuildContext context, AddEditStatus status) {
        if(status == AddEditStatus.loading) {
          return Loading();
        } else if(status == AddEditStatus.fetchError) {
          return FetchErrorMsg();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(_cubit.team.id == null ? 'Add Team' : 'Update Team'),
            ),
            body: Form(
              key: _cubit.formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 20,
                ),
                children: [
                  // team name field
                  getNameFieldWithTitle(),
                  // this is done due to validation is not working in regular 
                  // way for unknown reason
                  if(status == AddEditStatus.validationError)
                    getFieldMsg(
                      'Team name is required.',
                      Theme.of(context).errorColor,
                    ),
                  SizedBox(height: 15),

                  // team photo field
                  getPhotoFieldWithTitle(),
                  SizedBox(height: 15),

                  // stack of add player field and player search results
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // add player textfield
                          getAddPlayerField(),
                          getAddPlayerFieldMsg(context),
                          SizedBox(height: 15),
                        ],
                      ),
                      // search results
                      if(_cubit.addPlayerController.text != null &&
                      _cubit.addPlayerController.text.trim() != '')
                        getPlayerSearchResult(),
                    ],
                  ),

                  // added team players
                  getAddedTeamPlayers(),
                  SizedBox(height: 15),

                  // submit button
                  if(_cubit.playersNeeded <= 0) SizedBox(
                    width: double.maxFinite,
                    child: getFormSubmitButton(context),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Column getNameFieldWithTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Name'),
        FormTextField(
          hintText: 'Enter team name',
          controller: _cubit.teamNameController,
        ),
      ],
    );
  }

  Column getPhotoFieldWithTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Photo'),
        FormTextField(
          keyboardType: TextInputType.url,
          hintText: 'Enter team photo url',
          initialValue: _cubit.team.photo,
          onSaved: (String value) {
            _cubit.team.photo = value.trim();
          },
        ),
      ],
    );
  }

  Padding getFieldMsg(String msg, Color color) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Text(
        msg,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }

  Column getAddPlayerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Add Player'),
        FormTextField(
          controller: _cubit.addPlayerController,
          onChanged: (String value) => _cubit.searchPlayer(value),
        ),
      ],
    );
  }

  Padding getAddPlayerFieldMsg(BuildContext context) {
    if(_cubit.playersNeeded <= 0) {
      return getFieldMsg(
        '${_cubit.team.playersNames.length} players added.',
        Colors.grey,
      );
    } else {
      return getFieldMsg(
        '${_cubit.playersNeeded} more players to add.',
        Theme.of(context).errorColor,
      );
    }
  }

  FormSubmitButton getFormSubmitButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Submit',
      onPressed: () async {
        await _cubit.addUpdateTeam();

        if(_cubit.state != AddEditStatus.validationError) {
          String snackBarMsg;

          if (_cubit.state == AddEditStatus.added) {
            snackBarMsg = 'Team added successfully.';
          } else if (_cubit.state == AddEditStatus.updated) {
            snackBarMsg = 'Team updated successfully.';
          } else if (_cubit.state == AddEditStatus.failed) {
            snackBarMsg = 'Failed to perform task, please try again.';
          } else if (_cubit.state == AddEditStatus.duplicate) {
            snackBarMsg = 'Team name already exist.';
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(snackBarMsg),
          ));
        }
      },
    );
  }

  Container getPlayerSearchResult() {
    List<ListTile> matchedPlayersWidgets = [];

    _cubit.matchedPlayers.forEach((Player player) {
      matchedPlayersWidgets.add(ListTile(
        title: Text(player.name),
        subtitle: Text(player.role),
        onTap: () => _cubit.addPlayer(player),
      ));
    });

    if(matchedPlayersWidgets.isNotEmpty) {
      matchedPlayersWidgets.add(ListTile(title: Text('No more match.')));
    } else {
      matchedPlayersWidgets.add(ListTile(title: Text('No match.')));
    }
    
    return Container(
      margin: EdgeInsets.only(top: 85),
      constraints: BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: matchedPlayersWidgets.length <= 3 ? 
          Column(
            children: matchedPlayersWidgets,
            mainAxisSize: MainAxisSize.min,
          ) :
          ListView(children: matchedPlayersWidgets),
      ),
    );
  }

  Column getAddedTeamPlayers() {
    List<Column> addedPlayerWidgets = [];
    int totalPlayers = _cubit.team.playersNames.length;

    for(int i = 0; i < totalPlayers; i++) {
      addedPlayerWidgets.add(Column(children: [
          Card(
            child: ListTile(
              title: Text(_cubit.team.playersNames[i]),
              subtitle: Text(_cubit.team.playersRoles[i]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _cubit.deletePlayer(_cubit.team.playersNames[i]);
                },
              ),
            ),
          ),
          SizedBox(height: 5),
      ]));
    }
    
    return Column(children: addedPlayerWidgets);
  }
}
