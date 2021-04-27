import 'package:fantasy_cricket/models/chips_distribute.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:fantasy_cricket/repositories/team_repo.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  distributeAdded,
  distributeRemoved,
  isPlayingChanged,
  failed,
}

class ContestManagerCubit extends Cubit<CubitState> {
  Contest contest;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Series _series;
  final int _excerptIndex;

  ContestManagerCubit(this._series, this._excerptIndex) : super(null) {
    if(_series.matchExcerpts[_excerptIndex].id == null) {
      contest = Contest();
      contest.seriesId = _series.id;
      contest.seriesName = _series.name;
      contest.teamsNames = _series.matchExcerpts[_excerptIndex].teamsNames;
      contest.matchType = _series.matchExcerpts[_excerptIndex].type;
      contest.noByType = _series.matchExcerpts[_excerptIndex].no;
      contest.startTime = _series.matchExcerpts[_excerptIndex].startTime;
      contest.excerptIndex = _excerptIndex;
      contest.chipsDistributes = [ChipsDistribute()];

      // fetch the two team's players and set players needed info
      setPlayersInfo(_series.matchExcerpts[_excerptIndex].teamsIds);
    } else {
      ContestRepo.getContestById(_series.matchExcerpts[_excerptIndex].id)
        .catchError((dynamic error) {
          emit(CubitState.fetchError);
          return null;
        })
        .then((Contest contest) {
          this.contest = contest;
          emit(null);
        });
    }

    // to show [loading] widget on the screen because we need fetch the two 
    // team's players or the contest from database
    emit(CubitState.loading);
  }

  // fetches the two teams's players from db and set contest's players names, 
  // roles, initial credits and initial 'is playing' status
  Future<void> setPlayersInfo(List<String> teamsIds) async {
    Team team1, team2;
    
    try {
      team1 = await TeamRepo.getTeamById(teamsIds[0]);
      team2 = await TeamRepo.getTeamById(teamsIds[1]);
    } catch(error) {
      emit(CubitState.fetchError);
    }

    contest.playersNames = [];
    contest.playersRoles = [];
    contest.playersCredits = [];
    contest.isPlayings = [];
    contest.team1TotalPlayers = team1.playersNames.length;
    
    team1.playersNames.forEach((String name) {
      contest.playersNames.add(name);
    });

    team1.playersRoles.forEach((String role) {
      contest.playersRoles.add(role);
    });

    team2.playersNames.forEach((String name) {
      contest.playersNames.add(name);
    });

    team2.playersRoles.forEach((String role) {
      contest.playersRoles.add(role);
    });

    int totalPlayers = contest.playersNames.length;

    for(int i = 0; i < totalPlayers; i++) {
      contest.playersCredits.add(null);
      contest.isPlayings.add(false);
    }

    emit(null);
  }

  // adds a [ChipsDistribute] class object to [contest] object's 
  // [chipsDistributes] list
  void addChipsDistribute() {
    contest.chipsDistributes.add(ChipsDistribute());

    // to rebuild the UI
    if(state == CubitState.distributeAdded) {
      emit(null);
    } else {
      emit(CubitState.distributeAdded);
    }
  }

  // removes a [ChipsDistribute] class object from [contest] object's 
  // [chipsDistributes] list
  void removeChipsDistribute() {
    contest.chipsDistributes.removeLast();
    
    // to rebuild the UI
    if(state == CubitState.distributeRemoved) {
      emit(null);
    } else {
      emit(CubitState.distributeRemoved);
    }
  }

  void changeIsPlaying() {
    if(state == CubitState.isPlayingChanged) {
      emit(null);
    } else {
      emit(CubitState.isPlayingChanged);
    }
  }

  bool validateAndSaveForm() {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> runContest() async {
    if(validateAndSaveForm()) {
      try {
        await ContestRepo.addContest(contest, _series, _excerptIndex);
        
        // to remove this contest from [UpcomingContestsList] screen when we go
        // back to that screen and rebuild it
        _series.matchExcerpts.removeAt(_excerptIndex);
        
        // if we don't emit [null] then if [failed] is emitted once, cubit  
        // state will reamin always [failed]
        emit(null);
      } catch(error) {
        emit(CubitState.failed);
      }

      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateContest() async {
    if(validateAndSaveForm()) {
      
      try {
        await ContestRepo.updateContest(contest);
        
        // if we don't emit [null] then if [failed] is emitted once, cubit  
        // state will reamin always [failed]
        emit(null);
      } catch(error) {
        emit(CubitState.failed);
      }
      
      return true;
    } else {
      return false;
    }
  }

  Future<bool> lockContest() async {
    if(validateAndSaveForm()) {
      _series.matchExcerpts[_excerptIndex].status = ContestStatuses.locked;

      try {
        await SeriesRepo.updateSeries(_series);
        
        // to remove this contest from [ContestsList] screen when we go back to
        // that screen and rebuild it
        _series.matchExcerpts.removeAt(_excerptIndex);

        // if we don't emit [null] then if [failed] is emitted once, cubit  
        // state will reamin always [failed]
        emit(null);
      } catch(error) {
        emit(CubitState.failed);
      }
      
      return true;
    } else {
      return false;
    }
  }
}
