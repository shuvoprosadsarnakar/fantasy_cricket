import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/team/cubits/team_add_edit_cubit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/utils/team_util.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamAddEdit extends StatefulWidget {
  final Team team;

  TeamAddEdit({this.team});

  @override
  _TeamAddEditState createState() => _TeamAddEditState();
}

class _TeamAddEditState extends State<TeamAddEdit> {
  final TeamAddEditCubit _teamAddEditCubit = TeamAddEditCubit();

  @override
  void initState() {
    _teamAddEditCubit.init(widget.team);
    super.initState();
  }

  @override
  void dispose() {
    _teamAddEditCubit.teamNameController.dispose();
    _teamAddEditCubit.addPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamAddEditCubit, AddEditStatus>(
      bloc: _teamAddEditCubit,
      builder: (BuildContext context, AddEditStatus addEditStatus) {
        if(_teamAddEditCubit.state == AddEditStatus.loading) {
          return Loading();
        } else if(_teamAddEditCubit.state == AddEditStatus.fetchError) {
          return Scaffold(
            body: SafeArea(child: Padding(
              padding: EdgeInsets.all(15),
              child: Text('Failed to fetch players to add/update team.'),
            )),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(_teamAddEditCubit.team.id == null ? 
              'Add Team' : 'Update Team')),
            body: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _teamAddEditCubit.formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 20,
                ),
                children: [
                  // team name field
                  getNameField(),
                  if(_teamAddEditCubit.state == AddEditStatus.validationError)
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'Team name is required',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
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
                          SizedBox(height: 5),
                          getAddPlayerFieldMsg(context),
                          SizedBox(height: 20),
                        ],
                      ),
                      // search results
                      if(_teamAddEditCubit.addPlayerController.text != null &&
                      _teamAddEditCubit.addPlayerController.text.trim() != '')
                        getPlayerSearchResult(),
                    ],
                  ),

                  // added team players
                  getAddedTeamPlayers(),
                  SizedBox(height: 15),

                  // submit button
                  if(_teamAddEditCubit.playersNeeded <= 0) SizedBox(
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

  Padding getFieldTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Text(
        title,
        style: TextStyle(
          color: ColorPallate.ebonyClay,
          fontSize: 20,
        ),
      ),
    );
  }

  Column getNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitle('Name'),
        TextFormField(
          controller: _teamAddEditCubit.teamNameController,
          cursorColor: Colors.black38,
          decoration: InputDecoration(
            fillColor: ColorPallate.mercury,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 6,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintStyle: TextStyle(fontSize: 16),
            hintText: 'Enter team name',
          ),
        ),
      ],
    );
  }

  Column getAddPlayerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitle('Add Player'),
        TextFormField(
          controller: _teamAddEditCubit.addPlayerController,
          cursorColor: Colors.black38,
          decoration: InputDecoration(
            fillColor: ColorPallate.mercury,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 6,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintStyle: TextStyle(fontSize: 16),
            hintText: 'Enter player name',
          ),
          onChanged: (String value) {
            _teamAddEditCubit.searchPlayer(value);
          },
        ),
      ],
    );
  }

  Padding getAddPlayerFieldMsg(BuildContext context) {
    String msg;
    Color msgColor;

    if(_teamAddEditCubit.playersNeeded <= 0) {
      msg = '${_teamAddEditCubit.addedPlayers.length} players added.';
      msgColor = Colors.grey;
    } else {
      msg = '${_teamAddEditCubit.playersNeeded} more players to add.';
      msgColor = Theme.of(context).errorColor;
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        msg,
        style: TextStyle(
          color: msgColor,
          fontSize: 12,
        ),
      ),
    );
  }

  TextButton getFormSubmitButton(BuildContext context) {
    return TextButton(
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 20),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        primary: Colors.white,
        backgroundColor: ColorPallate.pomegranate,
      ),
      onPressed: () async {
        await _teamAddEditCubit.addUpdateTeam();

        if(_teamAddEditCubit.state != AddEditStatus.validationError) {
          String snackBarMsg;

          if (_teamAddEditCubit.state == AddEditStatus.added) {
            snackBarMsg = 'Team added successfully.';
          } else if (_teamAddEditCubit.state == AddEditStatus.updated) {
            snackBarMsg = 'Team updated successfully.';
          } else if (_teamAddEditCubit.state == AddEditStatus.failed) {
            snackBarMsg = 'Failed to perform task, please try again.';
          } else if (_teamAddEditCubit.state == AddEditStatus.duplicate) {
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

    _teamAddEditCubit.matchedPlayers.forEach((Player player) {
      matchedPlayersWidgets.add(ListTile(
        title: Text(player.name),
        subtitle: Text(player.role),
        onTap: () => _teamAddEditCubit.addPlayer(player),
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
    
    _teamAddEditCubit.addedPlayers.forEach((Player player) {
      addedPlayerWidgets.add(Column(
        children: [
          Card(
            child: ListTile(
              title: Text(player.name),
              subtitle: Text(player.role),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _teamAddEditCubit.deletePlayer(player),
              ),
            ),
          ),
          SizedBox(height: 5),
        ],
      ));
    });
    
    return Column(children: addedPlayerWidgets);
  }
}