import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/report.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/series_rank.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/models/win_info.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:fantasy_cricket/repositories/series_rank_repo.dart';
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
      emit(CubitState.loading);

      // update the status of the contest in series match excerpt
      series.matchExcerpts[excerptIndex].status = ContestStatuses.ended;

      // init [contest]'s [playersPoints] && [playersReports] properties
      _setPlayersPoints();

      try {
        // update contestents fantasy and give chips to contest winners
        // update contestents seriesRank and give chips to series winners
        // update series and contest

        // get all contest fantasies, update fantasy total points and rank
        List<Fantasy> contestFantasies = await _getUpdatedContestFantasies();

        // get all series ranks, update series rank total points and rank
        List<SeriesRank> seriesRanks = await _getUpdatedSeriesRanks(
          contestFantasies);

        // get contest winner users, update earned chips and earning history
        List<User> contestWinnerUsers = await _getUpdatedContestWinnerUsers(
          contestFantasies);

        // get series winner users, update earned chips and earning history
        List<User> seriesWinnerUsers = await _getUpdatedSeriesWinnersUsers(
          seriesRanks, contestWinnerUsers);

        await ContestRepo.endContest(
          contest,
          series,
          contestFantasies,
          seriesRanks,
          contestWinnerUsers,
          seriesWinnerUsers,
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

  Future<List<Fantasy>> _getUpdatedContestFantasies() async {
    List<Fantasy> contestFantasies = 
      await FantasyRepo.getFantasiesByContestId(contest.id);
    int totalFantasies = contestFantasies.length;

    contestFantasies.forEach((Fantasy fantasy) {
      fantasy.playersNames.forEach((String name) {
        int playerIndex = contest.playersNames.indexOf(name);
        double playerPoints = contest.playersPoints[playerIndex];

        if(name == fantasy.captain) {
          playerPoints *= 2;
        } else if(name == fantasy.viceCaptain) {
          playerPoints *= 1.5;
        }

        fantasy.totalPoints += playerPoints;
      });
    });

    contestFantasies.sort((a, b) {
      if(a.totalPoints < b.totalPoints) {
        return -1;
      } else if(a.totalPoints == b.totalPoints) {
        return 0;
      } else {
        return 1;
      }
    });

    for(int i = 0; i < totalFantasies; i++) {
      contestFantasies[i].rank = i + 1;
    }

    return contestFantasies;
  }

  Future<List<SeriesRank>> _getUpdatedSeriesRanks(List<Fantasy> contestFantasies
    ) async {
    List<SeriesRank> seriesRanks = 
      await SeriesRankRepo.getSeriesRanksBySeriesId(series.id);
    int totalSeriesRanks = seriesRanks.length;

    seriesRanks.forEach((SeriesRank seriesRank) {
      int fantasyIndex = contestFantasies.indexWhere((Fantasy fantasy) {
        if(fantasy.username == seriesRank.username) {
          return true;
        } else {
          return false;
        }
      });

      if(fantasyIndex != -1) {
        seriesRank.totalPoints += 
          contestFantasies[fantasyIndex].totalPoints;
      }
    });

    seriesRanks.sort((a, b) {
      if(a.totalPoints < b.totalPoints) {
        return -1;
      } else if(a.totalPoints == b.totalPoints) {
        return 0;
      } else {
        return 1;
      }
    });

    for(int i = 0; i < totalSeriesRanks; i++) {
      seriesRanks[i].rank = i + 1;
    }

    return seriesRanks;
  }

  Future<List<User>> _getUpdatedContestWinnerUsers(
    List<Fantasy> contestFantasies) async {
    List<User> contestWinnerUsers = [];
    int totalWinners = 
      contestFantasies.length < contest.chipsDistributes.last.to ? 
      contestFantasies.length : contest.chipsDistributes.last.to;

    for(int i = 0; i < totalWinners; i++) {
      contestWinnerUsers.add(
        await UserRepo.getUserByUsername(contestFantasies[i].username)
      );
    }

    for(int i = 0; i < contest.chipsDistributes.length; i++) {
      Distribute distribute = contest.chipsDistributes[i];

      for(int j = distribute.from - 1; j < distribute.to && j < totalWinners; 
        j++) {
        contestWinnerUsers[j].earnedChips += distribute.chips;
        contestWinnerUsers[j].remainingChips += distribute.chips;
        contestWinnerUsers[j].earningHistory.add(WinInfo(
          date: Timestamp.fromDate(DateTime.now()),
          details: 'Match Prize',
          rank: j + 1,
          rewards: distribute.chips,
        ));
      }
    }

    return contestWinnerUsers;
  }

  Future<List<User>> _getUpdatedSeriesWinnersUsers(List<SeriesRank> seriesRanks, 
    List<User> contestWinnerUsers) async {
    List<User> seriesWinnerUsers = [];
    int totalWinners = 
      seriesRanks.length < series.chipsDistributes.last.to ? 
      seriesRanks.length : series.chipsDistributes.last.to;

    for(int i = 0; i < totalWinners; i++) {
      int contestWinnerIndex = contestWinnerUsers.indexWhere((User user) {
        if(user.username == seriesRanks[i].username) {
          return true;
        } else {
          return false;
        }
      });

      if(contestWinnerIndex == -1) {
        seriesWinnerUsers.add(
          await UserRepo.getUserByUsername(seriesRanks[i].username)
        );
      } else {
        seriesWinnerUsers.add(null);
      }
    }

    for(int i = 0; i < series.chipsDistributes.length; i++) {
      Distribute distribute = series.chipsDistributes[i];

      for(int j = distribute.from - 1; j < distribute.to && j < totalWinners; 
        j++) {
        if(seriesWinnerUsers[j] != null) {
          seriesWinnerUsers[j].earnedChips += distribute.chips;
          seriesWinnerUsers[j].remainingChips += distribute.chips;
          seriesWinnerUsers[j].earningHistory.add(WinInfo(
            date: Timestamp.fromDate(DateTime.now()),
            details: 'Series Prize',
            rank: j + 1,
            rewards: distribute.chips,
          ));
        } else {
          int index = contestWinnerUsers.indexWhere((User user) {
            if(user.username == seriesRanks[j].username) {
              return true;
            } else {
              return false;
            }
          });

          contestWinnerUsers[index].earnedChips += distribute.chips;
          contestWinnerUsers[index].remainingChips += distribute.chips;
          contestWinnerUsers[index].earningHistory.add(WinInfo(
            date: Timestamp.fromDate(DateTime.now()),
            details: 'Series Prize',
            rank: j + 1,
            rewards: distribute.chips,
          ));
        }
      }
    }

    return seriesWinnerUsers;
  }
}
