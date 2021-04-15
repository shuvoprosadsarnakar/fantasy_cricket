import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/team/cubits/team_add_edit_cubit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/utils/crud_status_util.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamAddEdit extends StatelessWidget {
  final TeamAddEditCubit _teamAddEditCubit = TeamAddEditCubit();

  TeamAddEdit({Team team}) {
    _teamAddEditCubit.setTeam(team);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamAddEditCubit, CrudStatus>(
      bloc: _teamAddEditCubit,
      builder: (BuildContext context, CrudStatus crudStatus) {
        if(_teamAddEditCubit.state == CrudStatus.loading) {
          return Loading();
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(_teamAddEditCubit.team.id == null ? 
              'Add Team' : 'Update Team')),
            body: Form(
              key: _teamAddEditCubit.formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 20,
                ),
                children: [
                  // team name field
                  getNameField(),
                  SizedBox(height: 15),

                  // stack of add player field, player search results, submit   
                  // button and added team players
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
                          
                          // added team players
                          getAddedTeamPlayers(),
                          SizedBox(height: 15),

                          // submit button
                          if(_teamAddEditCubit.team.playerIds.length >= 11) 
                            SizedBox(
                            width: double.maxFinite,
                            child: getFormSubmitButton(context),
                          ),
                        ],
                      ),

                      // search results
                      // getPlayerSearchResult(),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // returns field title
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

  // returns name field with field title
  Column getNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitle('Name'),
        TextFormField(
          initialValue: _teamAddEditCubit.team.name,
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
          validator: (String value) {
            if (value.isEmpty) {
              return 'Team name is required.';
            } else {
              return null;
            }
          },
          onSaved: (String value) {
            _teamAddEditCubit.team.name = value;
          },
        ),
      ],
    );
  }

  // returns add player field with field title
  Column getAddPlayerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitle('Add Player'),
        TextFormField(
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
        ),
      ],
    );
  }

  // returns add player field message 
  Padding getAddPlayerFieldMsg(BuildContext context) {
    int playersLeft = 11 - _teamAddEditCubit.team.playerIds.length;
    String msg;

    if(playersLeft > 0) {
      msg = 'Add $playersLeft more players.';
    } else {
      msg = '${playersLeft * (-1) + 11} players added.';
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        msg,
        style: TextStyle(
          color: Theme.of(context).errorColor,
          fontSize: 12,
        ),
      ),
    );
  }

  // returns submit button
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
        await _teamAddEditCubit.addEditTeam();
      },
    );
  }

  // returns a container of search matched players
  Container getPlayerSearchResult() {
    return Container(
      margin: EdgeInsets.only(top: 85),
      height: 300,
      width: double.maxFinite,
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
        child: ListView(
          children: [
            ListTile(
              title: Text('Shane Watson'),
              subtitle: Text('Batsman'),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('Shane Watson'),
              subtitle: Text('Batsman'),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('Shane Watson'),
              subtitle: Text('Batsman'),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('Shane Watson'),
              subtitle: Text('Batsman'),
            ),
          ],
        ),
      ),
    );
  }

  // returns a column of added team players
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
                onPressed: () {},
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