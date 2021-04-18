import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_role_cubit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/utils/player_util.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerAddEdit extends StatelessWidget {
  // variable for managing state of this screen
  final PlayerAddEditCubit _playerAddEditCubit = PlayerAddEditCubit();
  
  // dropdown item's list for role field, items will be added from 
  final List<DropdownMenuItem<String>> _playerRoleDropdownList = [];

  PlayerAddEdit({Player player}) {
    // to show player info on the form save player into '_playerAddEditCubit'
    _playerAddEditCubit.setPlayer(player);

    // add dropdown items of role field to 'playerRoleDropdownList' property
    playerRoles.forEach((String value) {
      _playerRoleDropdownList.add(DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerAddEditCubit, AddEditStatus>(
      bloc: _playerAddEditCubit,
      builder: (BuildContext context, AddEditStatus addEditStatus) {
        if (_playerAddEditCubit.state == AddEditStatus.loading) {
          return Loading();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(_playerAddEditCubit.player.id == null
                    ? 'Add Player'
                    : 'Update Player')),
            body: Form(
              key: _playerAddEditCubit.formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 45,
                ),
                children: [
                  getNameField(),
                  SizedBox(height: 15),
                  getRoleField(),
                  SizedBox(height: 20),
                  getSubmitButton(context),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // returns name field with field title
  Column getNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Name'),
        FormTextField(
          hintText: 'Enter player name',
          initialValue: _playerAddEditCubit.player.name,
          validator: (String value) {
            if (value == null || value.trim() == '') {
              return 'Player name is required.';
            } else {
              return null;
            }
          },
          onSaved: (String value) {
            _playerAddEditCubit.player.name = value.trim();
          },
        ),
      ],
    );
  }

  // returns role field with field title
  Column getRoleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Role'),
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
              hint: Text('Select a player role'),
              items: _playerRoleDropdownList,
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
              onSaved: (String value) =>
                  _playerAddEditCubit.player.role = value,
            );
          },
        ),
      ],
    );
  }

  // returns submit button
  FormSubmitButton getSubmitButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Submit',
      onPressed: () async {
        await _playerAddEditCubit.addUpdatePlayer();

        // _playerAddEditCubit.state will be AddEditStatus.notValid  if form has 
        // validation error
        if(_playerAddEditCubit.state != AddEditStatus.notValid) {
          String snackBarMsg;

          if (_playerAddEditCubit.state == AddEditStatus.added) {
            snackBarMsg = 'Player added successfully.';
          } else if (_playerAddEditCubit.state == AddEditStatus.updated) {
            snackBarMsg = 'Player updated successfully.';
          } else if (_playerAddEditCubit.state == AddEditStatus.failed) {
            snackBarMsg = 'Failed to perform task, please try again.';
          } else if (_playerAddEditCubit.state == AddEditStatus.duplicate) {
            snackBarMsg = 'Player name already exist.';
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(snackBarMsg),
          ));
        }
      },
    );
  }
}
