import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/rank.dart';
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
  final Series series;
  final Excerpt excerpt;

  Fantasy fantasy;
  int team1TotalPlayers = 0;
  int team2TotalPlayers = 0;
  double creditsLeft = 100;
  int totalBatsmans = 0;
  int totalWicketKeepers = 0;
  int totalAllRounders = 0;
  int totalBowlers = 0;

  TeamManagerCubit(this.series, this.contest, this.user, this.excerpt) : 
    super(null) 
  {
    emit(CubitState.loading);

    if(user.contestIds.contains(contest.id)) {
      FantasyRepo.getFantasy(user.username, contest.id)
        .catchError((dynamic error) {
          emit(CubitState.fetchError);
          return null;
        })
        .then((Fantasy fantasy) {
          this.fantasy = fantasy;

          fantasy.playerNames.forEach((String playerName) {
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
    fantasy.playerNames.add(contest.playersNames[playerIndex]);
    initCubitAtPlayerAdd(playerIndex);
  }

  void removePlayer(int playerIndex) {
    fantasy.playerNames.remove(contest.playersNames[playerIndex]);
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
    Series series;

    try {
      series = await SeriesRepo.getSeriesById(contest.seriesId);
    } catch(error) {
      emit(CubitState.fetchError);
      return;
    }

    String contestStatus = series.matchExcerpts[contest.excerptIndex].status;

    if(contestStatus == 'Locked' || contestStatus == 'Ended') {
      emit(CubitState.timeOver);
    } else {
      if(fantasy.id == null) {
        await addFantasy();
      } else {
        await updateFantasy();
      }
    }
  }

  Future<void> addFantasy() async {
    try {
      await FantasyRepo.addFantasy(fantasy, user.id, contest);
      emit(CubitState.added);
      
      // to remove the contest from running contests list and to show 
      // [Update Team] button instead of [Create Team] button on 
      // [ContestDetails] page
      user.contestIds.add(contest.id);
    } catch(error) {
      emit(CubitState.addFailed);
    }
  }

  Future<void> updateFantasy() async {
    try {
      await FantasyRepo.updateFantasy(fantasy);
      emit(CubitState.updated);
    } catch(error) {
      emit(CubitState.updateFailed);
    }
  }
}
