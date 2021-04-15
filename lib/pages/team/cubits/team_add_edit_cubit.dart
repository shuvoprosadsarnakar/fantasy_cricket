import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/services/db_team.dart';
import 'package:fantasy_cricket/utils/crud_status_util.dart';
import 'package:flutter/material.dart';

class TeamAddEditCubit extends Cubit<CrudStatus> {
  TeamAddEditCubit() : super(null);

  // form key for handling the team add edit form from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // all added players from past and future will be added here
  final List<Player> addedPlayers = [];

  // A team object will be paseed to TeamAddEdit() screen if admin want to edit 
  // and that object will be set here. If user want to add player then a new
  // player object will be created and set into this variable. This obect is
  // used to show team information on TeamAddEdit() screen.
  Team team;

  // argument team will be null if admin is creating team
  void setTeam(Team team) {
    if(team != null) {
      // set team
      this.team = team;
      
      // emit state to show progress indicator because team players nedded to be 
      // fetched from databse by theirs ids to show team players info
      emit(CrudStatus.loading);
      
      team.playerIds.forEach((String id) async {
        DocumentSnapshot snapshot = await DbTeam.getPlayerById(id);
        addedPlayers.add(Player.fromMap(snapshot.data, snapshot.documentID));
        if(addedPlayers.length == team.playerIds.length) {
          print('Hello!');
          emit(CrudStatus.added);
        }
      });

    } else {
      this.team = Team(playerIds: []);
    }
  }

  Future<void> addEditTeam() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
    }
  }
}