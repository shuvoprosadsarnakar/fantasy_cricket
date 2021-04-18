import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_role_cubit.dart';
import 'package:fantasy_cricket/repositories/player_repo.dart';
import 'package:fantasy_cricket/utils/player_util.dart';
import 'package:flutter/material.dart';

class PlayerAddEditCubit extends Cubit<AddEditStatus> {
  PlayerAddEditCubit() : super(null);

  // variable for manipulating the form from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // variable for managing state of role field
  final PlayerRoleCubit playerRoleCubit = PlayerRoleCubit();
  
  // A player object will be paseed to PlayerAddEdit() screen if admin want to  
  // edit and that object will be set here. If user want to add player then a 
  // new player object will be created and set into this variable. This obect is
  // used to show player information on PlayerAddEdit() screen.
  final Player player = Player();

  // This function sets player variable and if user is doing editing then emits   
  // player role to show player role value in the form. Argument player will be
  // null if admin is creating player.
  void setPlayer(Player player) {
    if(player != null) {
      this.player.id = player.id;
      this.player.name = player.name;
      this.player.role = player.role;
      playerRoleCubit.emitState(player.role);
    }
  }

  Future<void> addUpdatePlayer() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      // after emitting this state a progress animation will be shown on 
      // PlayerAddEdit() screen
      emit(AddEditStatus.loading);

      // try catch block is used for handeling db functions exceptions
      try {
        if(await PlayerRepo.checkPlayerName(player)) {
          if(player.id == null) {
            await PlayerRepo.addPlayer(player);

            // if player is successfully added then null below properties 
            // because after emitting next state the PlayerAddEdit() screen     
            // form will be shown again where name and role field should be 
            // empty
            player.name = null;
            playerRoleCubit.emitState(null);

            // after emitting this state PlayerAddEdit() screen form will be  
            // shown again with empty form fields and a success message will be 
            // shown
            emit(AddEditStatus.added);
          } else {
            await PlayerRepo.updatePlayer(player);
            
            // after emitting this state PlayerAddEdit() screen form will be  
            // shown again with past form values and a success message will be 
            // shown
            emit(AddEditStatus.updated);
          }
        } else {
          emit(AddEditStatus.duplicate);
        }
      } catch(error) {
        // after emitting this state the PlayerAddEdit() screen form will be 
        // shown again with past form values and an error message will be shown
        emit(AddEditStatus.failed);
      }
    } else {
      emit(AddEditStatus.notValid);
    }
  }
}
