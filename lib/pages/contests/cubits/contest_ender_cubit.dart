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

      // init [contest]'s [playersPoints] && [playersReports] properties
      setPlayersPoints();

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

  void setPlayersPoints() {
    contest.playersPoints = <double>[];

    contest.playersReports = playersReports.map((Map<String, dynamic> map) {
      contest.playersPoints.add(0);
      return Report.fromMap(map);
    }).toList();

    int totalPlayers = playersReports.length;
      
    switch(_series.matchExcerpts[_excerptIndex].type) {
      case 'T20':
        for(int i = 0; i < totalPlayers; i++) {
          Report report = contest.playersReports[i];
          
          // batting points
          contest.playersPoints[i] += 
            report.runsTaken * 0.5 + 
            report.foursHit * 0.5 +
            report.sixesHit * 1 +
            (report.runsTaken >= 50 && report.runsTaken < 100 ? 4 : 0) +
            (report.runsTaken >= 100 ? 8 : 0);
          
          if(report.ballsFaced >= 10) {
            double strikeRate = report.runsTaken / report.ballsFaced * 100;
            int point;
            
            if(strikeRate <= 50) {
              point = -3;
            } else if(strikeRate <= 60) {
              point = -2;
            } else if(strikeRate <= 70) {
              point = -1;
            }

            contest.playersPoints[i] += point;
          }
          
          // bowiling points
          contest.playersPoints[i] +=
            report.wicketsTaken * 10 +
            report.maidenOvers * 4 +
            (report.wicketsTaken == 4 ? 4 : 0) +
            (report.wicketsTaken >= 5 ? 8 : 0);
          
          if(report.ballsBowled >= 12) {
            double economyRate = report.runsGiven / (report.ballsBowled / 6);
            int point;

            if(economyRate <= 4) {
              point = 3;
            } else if(economyRate <= 5) {
              point = 2;
            } else if(economyRate <= 7) {
              point = 1;
            } else if(economyRate <= 9) {
              point = -1;
            } else if(economyRate <= 11) {
              point = -2;
            } else {
              point = -3;
            }

            contest.playersPoints[i] += point;
          }

          // fielding points
          contest.playersPoints[i] += 
            report.catches * 4 + 
            report.stumpings * 6 + 
            report.runOuts * 4;

          // other points
          contest.playersPoints[i] +=
            (contest.isPlayings[i] ? 2 : 0) +
            (contest.playerOfTheMatch == contest.playersNames[i] ? 10 : 0);
        }
      break;

      case 'One Day':
        for(int i = 0; i < totalPlayers; i++) {
          Report report = contest.playersReports[i];
        
          // batting points
          contest.playersPoints[i] += 
            report.runsTaken * 0.5 + 
            report.foursHit * 0.5 +
            report.sixesHit * 1 +
            (report.runsTaken >= 50 && report.runsTaken < 100 ? 2 : 0) +
            (report.runsTaken >= 100 ? 4 : 0);
          
          if(report.ballsFaced >= 20) {
            double strikeRate = report.runsTaken / report.ballsFaced * 100;
            int point;
            
            if(strikeRate <= 40) {
              point = -3;
            } else if(strikeRate <= 50) {
              point = -2;
            } else if(strikeRate <= 60) {
              point = -1;
            }

            contest.playersPoints[i] += point;
          }
          
          // bowiling points
          contest.playersPoints[i] +=
            report.wicketsTaken * 12 +
            (report.wicketsTaken == 4 ? 2 : 0) +
            (report.wicketsTaken >= 5 ? 4 : 0) + 
            report.maidenOvers * 2;
          
          if(report.ballsBowled >= 12) {
            double economyRate = report.runsGiven / (report.ballsBowled / 6);
            int point;

            if(economyRate <= 2.5) {
              point = 3;
            } else if(economyRate <= 3.5) {
              point = 2;
            } else if(economyRate <= 4.5) {
              point = 1;
            } else if(economyRate >= 7 && economyRate <= 8) {
              point = -1;
            } else if(economyRate > 8 && economyRate <= 9) {
              point = -2;
            } else if(economyRate > 9) {
              point = -3;
            }

            contest.playersPoints[i] += point;
          }

          // fielding points
          contest.playersPoints[i] += 
            report.catches * 4 + 
            report.stumpings * 6 + 
            report.runOuts * 4;

          // other points
          contest.playersPoints[i] +=
            (contest.isPlayings[i] ? 2 : 0) +
            (contest.playerOfTheMatch == contest.playersNames[i] ? 10 : 0);
        }
      break;

      case 'Test':
        for(int i = 0; i < totalPlayers; i++) {
          Report report = contest.playersReports[i];

          // batting points
          contest.playersPoints[i] += 
            report.runsTaken * 0.5 + 
            report.foursHit * 0.5 +
            report.sixesHit * 1 +
            (report.runsTaken >= 50 && report.runsTaken < 100 ? 2 : 0) +
            (report.runsTaken >= 100 ? 4 : 0);
          
          // bowiling points
          contest.playersPoints[i] +=
            report.wicketsTaken * 10 +
            (report.wicketsTaken == 4 ? 2 : 0) +
            (report.wicketsTaken >= 5 ? 4 : 0);

          // fielding points
          contest.playersPoints[i] += 
            report.catches * 4 + 
            report.stumpings * 6 + 
            report.runOuts * 4;

          // other points
          contest.playersPoints[i] +=
            (contest.isPlayings[i] ? 2 : 0) +
            (contest.playerOfTheMatch == contest.playersNames[i] ? 10 : 0);
        }
      break;
    }
  }
}
