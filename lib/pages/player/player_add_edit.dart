import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_role_cubit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/utils/player_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerAddEdit extends StatelessWidget {
  // variable for managing state of this screen
  final PlayerAddEditCubit _playerAddEditCubit = PlayerAddEditCubit();

  PlayerAddEdit({Player player}) {
    _playerAddEditCubit.setPlayer(player);

    // add dropdown items of role field to 'playerRoleDropdownList' property
    playerRoles.forEach((String value) {
      _playerAddEditCubit.playerRoleDropdownList.add(
        DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerAddEditCubit, PlayerAddEditStatus>(
      bloc: _playerAddEditCubit,
      builder: (BuildContext context, PlayerAddEditStatus playerAddingStatus) {
        if (_playerAddEditCubit.state == PlayerAddEditStatus.loading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(_playerAddEditCubit.player.id == null ? 
              'Add Player' : 'Update Player')),
            body: Form(
              key: _playerAddEditCubit.formKey,
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
          initialValue: _playerAddEditCubit.player.name,
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
            hintText: 'Enter name',
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Player name is required.';
            } else {
              return null;
            }
          },
          onSaved: (String value) => _playerAddEditCubit.player.name = value,
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
        BlocBuilder<PlayerRoleCubit, String>(
          bloc: _playerAddEditCubit.playerRoleCubit,
          builder: (BuildContext context, String state) {
            return DropdownButtonFormField<String>(
              value: _playerAddEditCubit.playerRoleCubit.state,
              isExpanded: true,
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
              ),
              hint: Text('Select a role'),
              items: _playerAddEditCubit.playerRoleDropdownList,
              onChanged: (String value) {
                _playerAddEditCubit.playerRoleCubit.emitState(value);
              },
              validator: (String value) {
                if (value == null) {
                  return 'Player role is required.';
                } else {
                  return null;
                }
              },
              onSaved: (String value) => _playerAddEditCubit.player.role = value,
            );
          },
        ),
      ],
    );
  }

  // returns add player button
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
        await _playerAddEditCubit.addPlayerToDb();

        String snackBarMsg; // snack bar message

        if (_playerAddEditCubit.state == PlayerAddEditStatus.added) {
          snackBarMsg = 'Player added successfully.';
        } else if (_playerAddEditCubit.state == PlayerAddEditStatus.updated) {
          snackBarMsg = 'Player updated successfully.';
        } else if (_playerAddEditCubit.state == PlayerAddEditStatus.failed) {
          snackBarMsg = 'Failed to perform task, please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(snackBarMsg),
        ));
      },
    );
  }
}
