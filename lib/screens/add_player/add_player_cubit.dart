import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fantasy_cricket/screens/add_player/player_role_cubit.dart';

enum PlayerAddingStatus {adding, added, failed}

class AddPlayerCubit extends Cubit<PlayerAddingStatus> {
  AddPlayerCubit() : super(null);

  // variable for manipulating the from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // variable for managing state of role field and get player's role
  final PlayerRoleCubit playerRoleCubit = PlayerRoleCubit();
  
  // player's name of the form will be set here
  String playerName;

  Future<void> addPlayerToDb() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      // after emitting this state a progress animation will be shown on 
      // AddPlayer() screen
      emit(PlayerAddingStatus.adding);
      
      try {
        // add player into firestore
        await Firestore.instance.collection('players').add({
          'name': playerName,
          'role': playerRoleCubit.state,
        });

        // if player is successfully added then null below properties because
        // after emitting next state the AddPlayer() screen form will be shown   
        // again where name and role field should be empty
        playerName = null;
        playerRoleCubit.emitState(null);
        
        // after emitting this state AddPlayer() screen form will be shown again
        // and a success message will be shown
        emit(PlayerAddingStatus.added);
      } catch(error) { 
        // show error on debug console
        print(error);
        // after emitting this state the AddPlayer() screen form will be shown
        // again with past form values and an error message will be shown
        emit(PlayerAddingStatus.failed);
      }
    }
  }
}
