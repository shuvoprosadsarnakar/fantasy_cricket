import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_role_cubit.dart';
import 'package:fantasy_cricket/services/database.dart';
import 'package:flutter/material.dart';

enum PlayerAddEditStatus {loading, added, updated, failed}

class PlayerAddEditCubit extends Cubit<PlayerAddEditStatus> {
  PlayerAddEditCubit() : super(null);

  // variable for manipulating the form from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // variable for managing state of role field
  final PlayerRoleCubit playerRoleCubit = PlayerRoleCubit();
  
  // dropdown item's list for role field, items will be added from AddPlayer()
  // screen
  final List<DropdownMenuItem<String>> playerRoleDropdownList = [];
  
  // A player object will be paseed to AddPlayerScreen() if admin want to edit 
  // and that object will be set here. If user want to add player then a new
  // player object will be created and set into this variable.
  Player player;

  // this function sets player variable and if user want to edit then emits   
  // player role to show player role value in the form
  void initPlayer(Player player) {
    if(player != null) {
      this.player = player;
      playerRoleCubit.emitState(player.role);
    } else {
      this.player = Player();
    }
  }

  Future<void> addPlayerToDb() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      // after emitting this state a progress animation will be shown on 
      // AddPlayer() screen
      emit(PlayerAddEditStatus.loading);
      
      try {
        final db = DataBase();
        
        if(player.id == null) {
          // insert player into database
          await db.addPlayer(player);

          // if player is successfully added then null below properties because
          // after emitting next state the AddPlayer() screen form will be shown   
          // again where name and role field should be empty
          player.name = null;
          playerRoleCubit.emitState(null);

          // after emitting this state AddPlayer() screen form will be shown 
          // again with empty form fields and a success message will be shown
          emit(PlayerAddEditStatus.added);
        } else {
          // update player into databse
          await db.updatePlayer(player);

          // after emitting this state AddPlayer() screen form will be shown 
          // again with past form values and a success message will be shown
          emit(PlayerAddEditStatus.updated);
        }
      } catch(error) {
        // after emitting this state the AddPlayer() screen form will be shown
        // again with past form values and an error message will be shown
        emit(PlayerAddEditStatus.failed);
      }
    }
  }
}
