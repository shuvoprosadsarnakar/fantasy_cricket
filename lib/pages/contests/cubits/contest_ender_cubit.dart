import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/report.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  failed,
}

class ContestEnderCubit extends Cubit<CubitState> {
  Contest contest;
  final List<Map<String, dynamic>> playersReports = <Map<String, dynamic>>[];
  final Series _series;
  final int _excerptIndex;

  ContestEnderCubit(this._series, this._excerptIndex) : super(null) {
    emit(CubitState.loading);
    
    ContestRepo.getContestById(_series.matchExcerpts[_excerptIndex].id)
      .catchError((dynamic error) {
        emit(CubitState.fetchError);
        return null;
      })
      .then((Contest contest) {
        this.contest = contest;
        contest.teamsScores = [null, null];
    
        final Report report = Report();
        
        contest.playersNames.forEach((element) {
          playersReports.add(report.toMap());
        });
        emit(null);
      });
  }

  final List<String> reportKeys = <String>[
    RUNS_TAKEN_KEY,
    FOURS_HIT_KEY,
    SIXES_HIT_KEY,
    BALLS_FACED_KEY,
    WICKETS_TAKEN_KEY,
    MAIDEN_OVERS_KEY,
    BALLS_BOWLED_KEY,
    RUNS_GIVEN_KEY,
    CATCHES_KEY,
    STUMPINGS_KEY,
    RUN_OUTS_KEY,
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String mapKeyToFieldTitle(String mapKey) {
    int length = mapKey.length;
    String capitalized = mapKey[0].toUpperCase();
    int codeUnit;

    for(int i = 1; i < length; i++) {
      codeUnit = mapKey[i].codeUnits[0];
      
      if(codeUnit >= 65 && codeUnit <= 90) {
        capitalized += ' ';
      }
      
      capitalized += mapKey[i];
    }

    return capitalized;
  }

  Future<bool> endContest() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();

      // update the status of the contest in series match excerpt
      _series.matchExcerpts[_excerptIndex].status = ContestStatuses.ended;

      contest.playersReports = playersReports.map((Map<String, dynamic> map) {
        return Report.fromMap(map);
      }).toList();

      try {
        await ContestRepo.updateSeriesAndContest(_series, contest);
        
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
