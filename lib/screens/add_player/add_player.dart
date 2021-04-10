import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/screens/add_player/add_player_cubit.dart';
import 'package:fantasy_cricket/screens/add_player/player_role_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlayer extends StatelessWidget {
  // variable for managing state of this screen
  final AddPlayerCubit addPlayerCubit = AddPlayerCubit();

  // All player roles. Every role (String) will used to make dropdown items for
  // role field of the add player form.
  final List<String> playerRoles = <String>[
    'Batsman',
    'Wicket Keeper',
    'All Rounder',
    'Bowler',
  ];
  
  // dropdown item list for role field
  final List<DropdownMenuItem<String>> playerRoleDropdownList = [];

  // add dropdown items of role field to _playerRoleDropdownList
  AddPlayer() {
    playerRoles.forEach((String value) {
      playerRoleDropdownList.add(DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPlayerCubit, PlayerAddingStatus>(
      bloc: addPlayerCubit,
      builder: (BuildContext context, PlayerAddingStatus playerAddingStatus) {
        if(addPlayerCubit.state == PlayerAddingStatus.adding) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else return Scaffold(
          appBar: AppBar(title: Text('Add Player')),
          body: Form(
            key: addPlayerCubit.formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 45,
              ),
              children: [
                // name field with field title
                getNameField(),
                SizedBox(height: 15),
                
                // role field with field title
                getRoleField(),
                SizedBox(height: 20),

                // add player button
                getFormSubmitButton(context),
              ],
            ),
          ),
        );
      }
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
        attachFieldContainer(
          TextFormField(
            initialValue: addPlayerCubit.playerName,
            cursorColor: Colors.black38,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 16),
              hintText: 'Enter name',
            ),
            validator: (String value) {
              if(value.isEmpty) {
                return 'Player name is required.';
              } else  return null;
            },
            onSaved: (String value) {
              addPlayerCubit.playerName = value;
            },
          ),
        ),
      ],
    );
  }

  // returns role field with field title
  Column getRoleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitle('Role'),
        attachFieldContainer(
          BlocBuilder<PlayerRoleCubit, String>(
            bloc: addPlayerCubit.playerRoleCubit,
            builder: (BuildContext context, String state) {
              return DropdownButtonFormField<String>(
                value: addPlayerCubit.playerRoleCubit.state,
                isExpanded: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                hint: Text('Select a role'),
                items: playerRoleDropdownList,
                onChanged: (String value) {
                  addPlayerCubit.playerRoleCubit.emitState(value);
                },
                validator: (String value) {
                  if(value == null) {
                    return 'Player role is required.';
                  } else return null;
                },
              );
            }
          ),
        ),
      ],
    );
  }

  // returns add player button
  TextButton getFormSubmitButton(BuildContext context) {
    return TextButton(
      child: Text(
        'Add Player',
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
        await addPlayerCubit.addPlayerToDb();

        if(addPlayerCubit.state != null) {
          String snackBarMsg;
          
          if(addPlayerCubit.state == PlayerAddingStatus.added) {
            snackBarMsg = 'Player added successfully.';
          } else if(addPlayerCubit.state == PlayerAddingStatus.
            failed) {
            snackBarMsg = 'Failed to add player, try again.';
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(snackBarMsg),
          ));
        }
      },
    );
  }

  // places a field inside a container and returns the container
  Container attachFieldContainer(Widget field) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: ColorPallate.mercury,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: field,
    );
  }
}
