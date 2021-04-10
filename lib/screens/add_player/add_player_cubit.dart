import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum PlayerAddingStatus {adding, added, failed}

class AddPlayerCubit extends Cubit<PlayerAddingStatus> {
  AddPlayerCubit() : super(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String playerName, playerRole;

  void addPlayerToDb(String playerRole) {
    print("Player name:"+playerName);
    print("\n Player role:"+playerRole);
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      Firestore.instance.collection('players').add({
        'name': playerName,
        'role': playerRole,
      }).catchError((error){ print(error); });
    }
  }
}
