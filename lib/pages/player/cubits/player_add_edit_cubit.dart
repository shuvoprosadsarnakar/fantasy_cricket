import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/repositories/player_repo.dart';
import 'package:flutter/material.dart';

// this enum will be used by PlayerAddEditCubit() cubit to rebuild ui
// 
// loading: adding and updating player to db, name checking
// 
// added: player added to db
// 
// updated: player update into db
// 
// duplicate: name already taken by one other player
// 
// failed: failed to add or update player
// 
// notValid: player name is null or, '', or ' ',
// 
enum AddEditStatus {loading, added, updated, duplicate, failed, notValid}

class PlayerAddEditCubit extends Cubit<AddEditStatus> {
  final Player player;
  
  PlayerAddEditCubit(this.player) : super(null);

  // variable for manipulating the form from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            player.role = null;

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
