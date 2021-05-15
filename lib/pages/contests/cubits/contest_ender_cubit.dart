import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/report.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/models/win_info.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';
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
  final Series series;
  final int excerptIndex;
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

  ContestEnderCubit(this.series, this.excerptIndex) : super(null) {
    emit(CubitState.loading);
    
    ContestRepo.getContestById(series.matchExcerpts[excerptIndex].id)
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

  String mapKeyToFieldTitle(String mapKey) {
    int length = mapKey.length;
    String capitalized = mapKey[0].toUpperCase();

    for(int i = 1; i < length; i++) {
      int codeUnit = mapKey[i].codeUnits[0];
      
      if(codeUnit >= 65 && codeUnit <= 90) {
        capitalized += ' ';
      }
      
      capitalized += mapKey[i];
    }

    return capitalized;
  }

  Future<bool> endContest() async {
    if(formKey.currentState.validate()) {
      emit(CubitState.loading);
      formKey.currentState.save();

      // init contest's [playersPoints] && [playersReports] properties
      _setPlayersPoints();

      // update the status of the contest in series match excerpt
      series.matchExcerpts[excerptIndex].status = ContestStatuses.ended;
      
      try {
        // update contest and series's [ranks] property
        await _updateContestAndSeriesRanks();

        // give chips to contest winners and get them 
        List<User> contestWinners = await _getUpdatedContestWinners();
        
        // give chips to series winners and get them
        List<User> seriesWinners 
          = await _getUpdatedSeriesWinners(contestWinners);

        await ContestRepo.endContest(
          contest,
          series,
          contestWinners, 
          seriesWinners,
        );

        // if we don't emit [null] then if [failed] is emitted once, cubit  
        // state will reamin always [failed]
        emit(null);
      } catch(error) {
        series.matchExcerpts[excerptIndex].status = ContestStatuses.locked;
        emit(CubitState.failed);
      }
      
      return true;
    } else {
      return false;
    }
  }

  Future<void> _updateContestAndSeriesRanks() async {
    // get all contest fantasies
    List<Fantasy> contestFantasies
      = await FantasyRepo.getFantasiesByContestId(contest.id);

    contestFantasies.forEach((Fantasy fantasy) {
      double totalPoints = 0;

      // calculate total points of a fantasy
      fantasy.playerNames.forEach((String name) {
        int playerIndex = contest.playersNames.indexOf(name);
        double playerPoints = contest.playersPoints[playerIndex];

        if(name == fantasy.captain) {
          playerPoints *= 2;
        } else if(name == fantasy.viceCaptain) {
          playerPoints *= 1.5;
        }

        totalPoints += playerPoints;
      });

      // update contest rank's total points
      contest.ranks.firstWhere((Rank rank) {
        return rank.username == fantasy.username;
      }).totalPoints = totalPoints;

      // update series rank's total points
      series.ranks.firstWhere((Rank rank) {
        return rank.username == fantasy.username;
      }).totalPoints = totalPoints;
    });

    // sort contest ranks
    contest.ranks.sort((Rank a, Rank b) {
      if(a.totalPoints > b.totalPoints) {
        return -1;
      } else if(a.totalPoints == b.totalPoints) {
        return a.joinedAt.compareTo(b.joinedAt);
      } else {
        return 1;
      }
    });

    // sort series ranks
    series.ranks.sort((Rank a, Rank b) {
      if(a.totalPoints > b.totalPoints) {
        return -1;
      } else if(a.totalPoints == b.totalPoints) {
        return a.joinedAt.compareTo(b.joinedAt);
      } else {
        return 1;
      }
    });
  }

  Future<List<User>> _getUpdatedContestWinners() async {
    List<User> contestWinners = <User>[];
    int totalContestents = contest.ranks.length;
    int totalWinners = contest.chipsDistributes.last.to;
    int totalDistributes = contest.chipsDistributes.length;

    // get the contest winners
    for(int i = 0; i < totalWinners && i < totalContestents; i++) {
      contestWinners.add(
        await UserRepo.getUserByUsername(contest.ranks[i].username)
      );
    }

    // update the contest winners
    for(int i = 0; i < totalDistributes; i++) {
      Distribute distribute = contest.chipsDistributes[i];

      for(int j = distribute.from - 1; 
        j < distribute.to && j < totalContestents; j++)
      {
        contestWinners[j].earnedChips += distribute.chips;
        contestWinners[j].remainingChips += distribute.chips;
        contestWinners[j].earningHistory.add(WinInfo(
          date: Timestamp.fromDate(DateTime.now()),
          details: 'Match Prize',
          rank: j + 1,
          rewards: distribute.chips,
        ));
      }
    }

    return contestWinners;
  }

  Future<List<User>> _getUpdatedSeriesWinners(List<User> contestWinners) async {
    List<User> seriesWinners = [];
    int totalContestents = series.ranks.length;
    int totalWinners = series.chipsDistributes.last.to;
    int totalDistributes = series.chipsDistributes.length;

    // get series winners
    for(int i = 0; i < totalWinners && i < totalContestents; i++) {
      Rank seriesRank = series.ranks[i];
      int contestWinnerIndex = contestWinners.indexWhere((User user) {
        return user.username == seriesRank.username;
      });

      if(contestWinnerIndex == -1) {
        seriesWinners.add(
          await UserRepo.getUserByUsername(seriesRank.username)
        );
      } else {
        seriesWinners.add(null);
      }
    }

    // update series winners
    for(int i = 0; i < totalDistributes; i++) {
      Distribute distribute = series.chipsDistributes[i];

      for(int j = distribute.from - 1;
        j < distribute.to && j < totalContestents; j++)
      {
        if(seriesWinners[j] != null) {
          seriesWinners[j].earnedChips += distribute.chips;
          seriesWinners[j].remainingChips += distribute.chips;
          seriesWinners[j].earningHistory.add(WinInfo(
            date: Timestamp.fromDate(DateTime.now()),
            details: 'Series Prize',
            rank: j + 1,
            rewards: distribute.chips,
          ));
        } else {
          int contestWinnerIndex = contestWinners.indexWhere((User user) {
            return user.username == series.ranks[j].username;
          });

          contestWinners[contestWinnerIndex].earnedChips += distribute.chips;
          contestWinners[contestWinnerIndex].remainingChips += distribute.chips;
          contestWinners[contestWinnerIndex].earningHistory.add(WinInfo(
            date: Timestamp.fromDate(DateTime.now()),
            details: 'Series Prize',
            rank: j + 1,
            rewards: distribute.chips,
          ));
        }
      }
    }

    return seriesWinners;
  }

  void _setPlayersPoints() {
    contest.playersPoints = <double>[];

    contest.playersReports = playersReports.map((Map<String, dynamic> map) {
      contest.playersPoints.add(0);
      return Report.fromMap(map);
    }).toList();

    int totalPlayers = playersReports.length;
      
    switch(series.matchExcerpts[excerptIndex].type) {
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
