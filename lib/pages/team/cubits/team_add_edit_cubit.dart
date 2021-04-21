import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/repositories/player_repo.dart';
import 'package:fantasy_cricket/repositories/team_repo.dart';
import 'package:fantasy_cricket/utils/team_util.dart';
import 'package:flutter/material.dart';

class TeamAddEditCubit extends Cubit<AddEditStatus> {
  TeamAddEditCubit() : super(null);

  // form key and controllers for handling the team add edit form from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController addPlayerController = TextEditingController();
  final TextEditingController teamNameController = TextEditingController();

  // A team object will be paseed to TeamAddEdit() screen if admin want to edit
  // and that object will be set here. If user want to add player then a new
  // player object will be created and set into this variable. This obect is
  // used to show team information on TeamAddEdit() screen and save team
  // information to database.
  final Team team = Team();

  // all players form databse will be here to search player and get players of
  // a team to show on the ui
  final List<Player> allPlayers = [];

  // all players already added or, will be added will be added to here to build
  // player list ui
  final List<Player> addedPlayers = [];

  // all name matched player when searching will be added here then the list
  // will be shown as search result
  final List<Player> matchedPlayers = [];

  // this wil be used for generating add player field msg on the ui
  int get playersNeeded => 11 - addedPlayers.length;

  // argument 'team' will be null if admin is creating team
  void setTeam(Team team) {
    if (team != null) {
      this.team.id = team.id;
      this.team.name = teamNameController.text = team.name;
      this.team.playerIds = team.playerIds;
    } else {
      // this is done to add player ids to the list without checking it's null
      // or not
      this.team.playerIds = [];
    }

    // emit state to show progress indicator because all players nedded to be
    // fetched from database
    emit(AddEditStatus.loading);

    // get all players from db and set them to 'allPlayers' list and add team
    // players to 'addedPlayers' to show team players on the ui
    setAllPlayers();
  }

  // get all players from db and set them to 'allPLayers' to build player search
  // result ui and team player list ui
  Future<void> setAllPlayers() async {
    try {
      QuerySnapshot snapshot = await PlayerRepo.getAllPlayers();

      snapshot.docs.forEach((DocumentSnapshot snapshot) {
        allPlayers.add(Player.fromMap(snapshot.data(), snapshot.id));
      });

      // set 'addedPlayers' to show team players list on the ui
      setAddedPlayers();

      emit(null);
    } catch (error) {
      print(error);
      // because of this state only a message will be shown on the ui, not form
      emit(AddEditStatus.fetchError);
    }
  }

  // setting 'addedPlayers' from 'allPlayers' by matching ids which are taken
  // from 'team.playerIds'
  void setAddedPlayers() {
    Player player;

    team.playerIds.forEach((String playerId) {
      player = allPlayers.firstWhere((Player player) => player.id == playerId);
      addedPlayers.add(player);
    });
  }

  // this function deletes player from team, one at a time
  void deletePlayer(Player player) {
    team.playerIds.remove(player.id);
    addedPlayers.remove(player);

    // emiiting same state doesn't rebuild ui, that's why different state will
    // be emitted everytime from here
    if (state == AddEditStatus.playerDeleted)
      emit(null);
    else
      emit(AddEditStatus.playerDeleted);
  }

  // this function adds player to the team, one at a time
  void addPlayer(Player player) {
    team.playerIds.add(player.id);
    addedPlayers.add(player);
    addPlayerController.clear();

    // emiiting same state doesn't rebuild ui, that's why different state will
    // be emitted everytime from here
    if (state == AddEditStatus.playerAdded) {
      emit(null);
    } else {
      emit(AddEditStatus.playerAdded);
    }
  }

  // this function gets called when add player field is changed
  void searchPlayer(String name) {
    matchedPlayers.clear(); // clear previous search matched players

    if (name != null && name != '') {
      name = name.toLowerCase();
      allPlayers.forEach((Player player) {
        if (player.name.toLowerCase().contains(name) &&
            (team.playerIds.contains(player.id) == false)) {
          matchedPlayers.add(player);
        }
      });
    }

    if (state == AddEditStatus.searched) {
      emit(null);
    } else {
      emit(AddEditStatus.searched);
    }
  }

  // add or update team to database
  Future<void> addUpdateTeam() async {
    if (teamNameController.text == null ||
        teamNameController.text.trim() != '') {
      team.name = teamNameController.text.trim();

      // after emitting this state a progress animation will be shown on the ui
      emit(AddEditStatus.loading);

      // try catch block is used for handeling db functions exceptions
      try {
        if (await TeamRepo.checkTeamName(team)) {
          print('rangan');
          if (team.id == null) {
            await TeamRepo.addTeam(team);

            team.playerIds.clear();
            addedPlayers.clear();
            teamNameController.clear();
            addPlayerController.clear();

            // after emitting this state TeamAddEdit() screen form will be shown
            // again with empty form fields and a success message will be shown
            emit(AddEditStatus.added);
          } else {
            await TeamRepo.updateTeam(team);
            addPlayerController.clear();

            // after emitting this state TeamAddEdit() screen form will be shown
            // again with past form values and a success message will be shown
            emit(AddEditStatus.updated);
          }
        } else {
          emit(AddEditStatus.duplicate);
        }
      } catch (error) {
        // after emitting this state the TeamAddEdit() screen form will be shown
        // again with past form values and an error message will be shown
        emit(AddEditStatus.failed);
      }
    } else {
      emit(AddEditStatus.validationError);
    }
  }
}
