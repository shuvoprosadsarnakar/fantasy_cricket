import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_role_cubit.dart';
import 'package:fantasy_cricket/repositories/player_repo.dart';
import 'package:fantasy_cricket/utils/crud_status_util.dart';
import 'package:flutter/material.dart';

class PlayerAddEditCubit extends Cubit<CrudStatus> {
  PlayerAddEditCubit() : super(null);

  // variable for manipulating the form from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // variable for managing state of role field
  final PlayerRoleCubit playerRoleCubit = PlayerRoleCubit();
  
  // dropdown item's list for role field, items will be added from AddPlayer()
  // screen
  final List<DropdownMenuItem<String>> playerRoleDropdownList = [];
  
  // A player object will be paseed to PlayerAddEdit() screen if admin want to  
  // edit and that object will be set here. If user want to add player then a 
  // new player object will be created and set into this variable. This obect is
  // used to show player information on PlayerAddEdit() screen.
  Player player;

  // This function sets player variable and if user is doing editing then emits   
  // player role to show player role value in the form. Argument player will be
  // null if admin is creating player.
  void setPlayer(Player player) {
    if(player != null) {
      this.player = player;
      playerRoleCubit.emitState(player.role);
    } else {
      this.player = Player();
    }
  }

  Future<void> addUpdatePlayer() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      // after emitting this state a progress animation will be shown on 
      // AddPlayer() screen
      emit(CrudStatus.loading);

      // try catch block is used for handeling db functions exceptions
      try {
        if(await PlayerRepo.checkPlayerName(player) == false) {
          emit(CrudStatus.duplicate);
        } else if(player.id == null) {
          await PlayerRepo.addPlayer(player);

          // if player is successfully added then null below properties 
          // because after emitting next state the AddPlayer() screen form    
          // will be shown again where name and role field should be empty
          player.name = null;
          playerRoleCubit.emitState(null);

          // after emitting this state AddPlayer() screen form will be shown 
          // again with empty form fields and a success message will be shown
          emit(CrudStatus.added);
        } else {
          await PlayerRepo.updatePlayer(player);
          
          // after emitting this state AddPlayer() screen form will be shown 
          // again with past form values and a success message will be shown
          emit(CrudStatus.updated);
        }
      } catch(error) {
        // after emitting this state the AddPlayer() screen form will be shown
        // again with past form values and an error message will be shown
        emit(CrudStatus.failed);
      }
    }
  }
}
