import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:fantasy_cricket/resources/player_roles.dart';
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
  final User user;
  final Series series;
  final Excerpt excerpt;

  Contest contest;
  Fantasy fantasy;
  List<String> oldPlayerNames;

  int team1TotalPlayers = 0;
  int team2TotalPlayers = 0;
  double creditsLeft = 100;
  int totalBatsmans = 0;
  int totalWicketKeepers = 0;
  int totalAllRounders = 0;
  int totalBowlers = 0;

  TeamManagerCubit(this.series, this.user, this.excerpt) : super(null) {
    emit(CubitState.loading);
    _getContestAndFantasy();
  }

  void _getContestAndFantasy() async {
    try {
      // we must not take the contest from [ContestDetails] page because we need 
      // to get the updated [playerPickedCounts] of [contest] after a fantasy 
      // add or update, so that we can update the player picked percentage on 
      // the UI
      contest = await ContestRepo.getContestById(excerpt.id);
      
      // fantasy will be null if user hasn't joined the contest
      fantasy = await FantasyRepo.getFantasy(user.username, contest.id);
      
      // to change the [CubitState.loading] state emitted by constructor
      emit(null);
    } catch(error) {
      emit(CubitState.fetchError);
    }


    if(fantasy != null) {
      // this will be used to update [playerPickedCounts] of [contest] at the 
      // time of team/fantasy update
      oldPlayerNames = List.of(fantasy.playerNames);

      fantasy.playerNames.forEach((String playerName) {
        _initCubitAtPlayerAdd(contest.playersNames.indexOf(playerName));
      });
    } else {
      fantasy = Fantasy();
      fantasy.contestId = contest.id;
      fantasy.username = user.username;
    }
  }

  void _initCubitAtPlayerAdd(int playerIndex) {
    if(playerIndex < contest.team1TotalPlayers) {
      team1TotalPlayers++;
    } else {
      team2TotalPlayers++;
    }

    creditsLeft -= contest.playersCredits[playerIndex];

    switch(contest.playersRoles[playerIndex]) {
      case BATSMAN:
        totalBatsmans++;
        break;
      case WICKET_KEEPER:
        totalWicketKeepers++;
        break;
      case ALL_ROUNDER:
        totalAllRounders++;
        break;
      case BOWLER:
        totalBowlers++;
    }
  }

  void addPlayer(int playerIndex) {
    fantasy.playerNames.add(contest.playersNames[playerIndex]);
    _initCubitAtPlayerAdd(playerIndex);
  }

  void removePlayer(int playerIndex) {
    String playerName = contest.playersNames[playerIndex];
    fantasy.playerNames.remove(playerName);

    if(playerName == fantasy.captain) {
      fantasy.captain = null;
    } else if(playerName == fantasy.viceCaptain) {
      fantasy.viceCaptain = null;
    }

    _initCubitAtPlayerRemove(playerIndex);
  }

  void _initCubitAtPlayerRemove(int playerIndex) {
    if(playerIndex < contest.team1TotalPlayers) {
      team1TotalPlayers--;
    } else {
      team2TotalPlayers--;
    }

    creditsLeft += contest.playersCredits[playerIndex];

    switch(contest.playersRoles[playerIndex]) {
      case BATSMAN:
        totalBatsmans--;
        break;
      case WICKET_KEEPER:
        totalWicketKeepers--;
        break;
      case ALL_ROUNDER:
        totalAllRounders--;
        break;
      case BOWLER:
        totalBowlers--;
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
    Series series;

    emit(CubitState.loading);
    try {
      series = await SeriesRepo.getSeriesById(contest.seriesId);
    } catch(error) {
      emit(CubitState.fetchError);
      return;
    }

    int excerptIndex = series.matchExcerpts.indexWhere((Excerpt excerpt) {
      return excerpt.id == this.excerpt.id;
    });
    String contestStatus 
      = series.matchExcerpts[excerptIndex].status;

    if(contestStatus == ContestStatuses.locked || 
      contestStatus == ContestStatuses.ended) 
    {
      emit(CubitState.timeOver);
    } else {
      // sort players by role so that at the time watching fantasy players 
      // points players reamin sorted by their role
      sortPlayersByRole();

      if(fantasy.id == null) {
        await _addFantasy();
      } else {
        await _updateFantasy();
      }
    }
  }

  Future<void> _addFantasy() async {
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

  Future<void> _updateFantasy() async {
    try {
      await FantasyRepo.updateFantasy(fantasy, oldPlayerNames);
      emit(CubitState.updated);
    } catch(error) {
      emit(CubitState.updateFailed);
    }
  }

  double getPlayerPickedPercentage(int playerIndex) {
    int totalContestants = contest.ranks.length;
    
    if(totalContestants != 0) {
      return (contest.playerPickedCounts[playerIndex] / totalContestants) * 100;
    } else {
      return 0;
    }
  }

  void sortPlayersByRole() {
    List<String> batsmanNames = <String>[];
    List<String> bowlerNames = <String>[];
    List<String> allRounderNames = <String>[];
    List<String> wicketKeeperNames = <String>[];

    for(int i = 0; i < 11; i++) {
      String playerName = fantasy.playerNames[i];
      int playerIndex = contest.playersNames.indexOf(playerName);
      String playerRole = contest.playersRoles[playerIndex]; 

      switch(playerRole) {
        case BATSMAN:
          batsmanNames.add(playerName);
          break;
        case BOWLER:
          bowlerNames.add(playerName);
          break;
        case ALL_ROUNDER:
          allRounderNames.add(playerName);
          break;
        case WICKET_KEEPER:
          wicketKeeperNames.add(playerName);
          break;
      }
    }

    int totalBatsmans = batsmanNames.length;
    int totalBowlers = bowlerNames.length;
    int totalAllRounders = allRounderNames.length;
    int totalWicketKeepers = wicketKeeperNames.length;
    int playerIndex = 0;

    for(int i = 0; i < totalBatsmans; i++, playerIndex++) {
      fantasy.playerNames[playerIndex] = batsmanNames[i];
    }

    for(int i = 0; i < totalWicketKeepers; i++, playerIndex++) {
      fantasy.playerNames[playerIndex] = wicketKeeperNames[i];
    }

    for(int i = 0; i < totalAllRounders; i++, playerIndex++) {
      fantasy.playerNames[playerIndex] = allRounderNames[i];
    }

    for(int i = 0; i < totalBowlers; i++, playerIndex++) {
      fantasy.playerNames[playerIndex] = bowlerNames[i];
    }
  }
}
