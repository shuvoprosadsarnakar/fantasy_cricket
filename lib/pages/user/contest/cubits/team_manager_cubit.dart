import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  fetched,
  rebuild,
  added,
  updated,
  addFailed,
  updateFailed,
  timeOver,
}

class TeamManagerCubit extends Cubit<CubitState> {
  final Contest contest;
  final User user;
  Fantasy fantasy;
  int team1TotalPlayers = 0;
  int team2TotalPlayers = 0;
  double creditsLeft = 100;
  int totalBatsmans = 0;
  int totalWicketKeepers = 0;
  int totalAllRounders = 0;
  int totalBowlers = 0;

  TeamManagerCubit(this.contest, this.user) : super(null) {
    emit(CubitState.loading);

    if(user.contestIds.contains(contest.id)) {
      FantasyRepo.getFantasyById(user.id + contest.id)
        .catchError((dynamic error) {
          emit(CubitState.fetchError);
          return null;
        })
        .then((Fantasy fantasy) {
          this.fantasy = fantasy;

          fantasy.playersNames.forEach((String playerName) {
            initCubitAtPlayerAdd(contest.playersNames.indexOf(playerName));
          });

          emit(CubitState.fetched);
        });
    } else {
      fantasy = Fantasy();
      fantasy.contestId = contest.id;
      fantasy.username = user.username;
      emit(null);
    }
  }

  void initCubitAtPlayerAdd(int playerIndex) {
    if(playerIndex < contest.team1TotalPlayers) {
      team1TotalPlayers++;
    } else {
      team2TotalPlayers++;
    }

    creditsLeft -= contest.playersCredits[playerIndex];

    switch(contest.playersRoles[playerIndex]) {
      case 'Batsman':
        totalBatsmans++;
        break;
      case 'Wicket Keeper':
        totalWicketKeepers++;
        break;
      case 'All Rounder':
        totalAllRounders++;
        break;
      case 'Bowler':
        totalBowlers++;
        break;
    }
  }

  void addPlayer(int playerIndex) {
    fantasy.playersNames.add(contest.playersNames[playerIndex]);
    initCubitAtPlayerAdd(playerIndex);
  }

  void removePlayer(int playerIndex) {
    fantasy.playersNames.remove(contest.playersNames[playerIndex]);
    initCubitAtPlayerRemove(playerIndex);
  }

  void initCubitAtPlayerRemove(int playerIndex) {
    if(playerIndex < contest.team1TotalPlayers) {
      team1TotalPlayers--;
    } else {
      team2TotalPlayers--;
    }

    creditsLeft += contest.playersCredits[playerIndex];

    switch(contest.playersRoles[playerIndex]) {
      case 'Batsman':
        totalBatsmans--;
        break;
      case 'Wicket Keeper':
        totalWicketKeepers--;
        break;
      case 'All Rounder':
        totalAllRounders--;
        break;
      case 'Bowler':
        totalBowlers--;
        break;
    }
  }

  void rebuildUi() {
    if(state == CubitState.rebuild) {
      emit(null);
    } else {
      emit(CubitState.rebuild);
    }
  }

  Future<void> addOrUpdateFantasy() async {
    emit(CubitState.loading);

    try {
      Series series = await SeriesRepo.getSeriesById(contest.seriesId);
      
      if(series.matchExcerpts[contest.excerptIndex].status == 'Locked' || 
        series.matchExcerpts[contest.excerptIndex].status == 'Ended') {
        emit(CubitState.timeOver);
      } else {
        if(fantasy.id == null) {
          user.contestIds.add(contest.id);
          
          if(user.seriesIds.contains(contest.seriesId) == false) {
            user.seriesIds.add(contest.seriesId);
          }
          
          fantasy.createdAt = Timestamp.fromDate(DateTime.now());
          
          try {
            await FantasyRepo.addFantasy(fantasy, user, contest.id);
            emit(CubitState.added);
          } catch(error) {
            user.contestIds.remove(contest.id);
            emit(CubitState.addFailed);
          }
        } else {
          try {
            await FantasyRepo.updateFantasy(fantasy);
            emit(CubitState.updated);
          } catch(error) {
            emit(CubitState.updateFailed);
          }
        }
      }
    } catch(error) {
      emit(CubitState.fetchError);
    }
  }
}
