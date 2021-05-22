import 'package:fantasy_cricket/pages/player/cubits/player_add_edit_cubit.dart';
import 'package:fantasy_cricket/resources/player_roles.dart';
import 'package:fantasy_cricket/widgets/form_dropdown_field.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerAddEdit extends StatelessWidget {
  // variable for managing state of this screen
  final PlayerAddEditCubit _playerAddEditCubit;
  
  // role dropdown list for player role dropdown field
  final List<DropdownMenuItem<String>> _roleDropdownList = [];

  PlayerAddEdit(this._playerAddEditCubit) {
    PlayerRoles.list.forEach((String value) {
      _roleDropdownList.add(DropdownMenuItem<String>(
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
                  getNameFieldWithTitle(),
                  SizedBox(height: 15),
                  getRoleFieldWithTitle(),
                  SizedBox(height: 15),
                  getPhotoFieldWithTitle(),
                  SizedBox(height: 20),
                  getFormSubmitButton(context),
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

  Column getRoleFieldWithTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Role'),
        FormDropdownField(
          value: _playerAddEditCubit.player.role,
          hint: Text('Select a player role'),
          items: _roleDropdownList,
          validator: (dynamic value) {
            if (value == null) {
              return 'Player role is required.';
            } else {
              return null;
            }
          },
          onSaved: (dynamic value) => _playerAddEditCubit.player.role = value,
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
          hintText: 'Enter player photo url',
          initialValue: _playerAddEditCubit.player.photo,
          onSaved: (String value) {
            _playerAddEditCubit.player.photo = value.trim();
          },
        ),
      ],
    );
  }

  FormSubmitButton getFormSubmitButton(BuildContext context) {
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
