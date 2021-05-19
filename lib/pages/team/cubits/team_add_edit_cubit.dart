import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/repositories/player_repo.dart';
import 'package:fantasy_cricket/repositories/team_repo.dart';
import 'package:flutter/material.dart';

// this enum will be used by TeamAddEditCubit() cubit to rebuild ui
//
// loading: fetching all players, adding and updating team to db, name checking
// 
// fetchError: failed to fetch all players from database
// 
// added: team added to db
// 
// updated: team update into db
// 
// duplicate: name already taken by one other team
// 
// failed: failed to add or update team
// 
// playerAdded: player added to team in the device, not in db
// 
// playerDelete: player deleted from team in the device, not in db
// 
// searched: players searching finished
// 
// validationError: team name is null or, '', or ' ',
// 
enum AddEditStatus {
  loading,
  fetchError,
  added,
  updated,
  duplicate,
  failed, 
  playerAdded,
  playerDeleted,
  searched,
  validationError,
}

class TeamAddEditCubit extends Cubit<AddEditStatus> {
  Team team;
  
  // all players form databse will be added here to search player to add to team
  final List<Player> allPlayers = [];

  TeamAddEditCubit(this.team) : super(null) {
    // emit state to show progress indicator because all players nedded to be
    // fetched from database
    emit(AddEditStatus.loading);

    // get all players from db and assign them to 'allPlayers' list
    PlayerRepo.assignAllPlayers(allPlayers)
      .catchError((dynamic error) => emit(AddEditStatus.fetchError))
      .then((void value) => emit(null));
  }

  // form key and controllers for handling the team add edit form from here
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController addPlayerController = TextEditingController();

  // all name matched player when searching will be added here then the list
  // will be shown as search result
  final List<Player> matchedPlayers = [];

  // this wil be used for generating add player field msg on the ui
  int get playersNeeded => 11 - team.playersNames.length;

  // this function deletes player from team, one at a time
  void deletePlayer(String playerName) {
    int playerNameIndex = team.playersNames.indexOf(playerName);
    
    team.playersNames.remove(playerName);
    team.playersRoles.removeAt(playerNameIndex);
    team.playerPhotos.removeAt(playerNameIndex);

    // emiiting same state doesn't rebuild ui, that's why different state will
    // be emitted everytime from here
    if (state == AddEditStatus.playerDeleted) {
      emit(null);
    } else {
      emit(AddEditStatus.playerDeleted);
    }
  }

  // this function adds player to the team, one at a time
  void addPlayer(Player player) {
    team.playersNames.add(player.name);
    team.playersRoles.add(player.role);
    team.playerPhotos.add(player.photo);
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
    // clear previous search matched players
    matchedPlayers.clear();
    
    if(name != null && name.trim().isNotEmpty) {
      name = name.trim().toLowerCase();

      allPlayers.forEach((Player player) {
        if(player.name.toLowerCase().contains(name) &&
          (team.playersNames.contains(player.name) == false)) {
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
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      // after emitting this state a progress animation will be shown on the ui
      emit(AddEditStatus.loading);

      // try catch block is used for handeling db functions exceptions
      try {
        if (await TeamRepo.checkTeamName(team)) {
          if (team.id == null) {
            await TeamRepo.addTeam(team);

            team = Team();
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
