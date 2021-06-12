import 'package:fantasy_cricket/helpers/points_calculator.dart';
import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/report.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  launchFailed,
}

class MatchLeaderBoardCubit extends Cubit<CubitState> {
  final Excerpt excerpt;
  final String username;
  Contest contest;
  
  MatchLeaderBoardCubit(this.excerpt, this.username) : super(null) {
    emit(CubitState.loading);
    
    ContestRepo.getContestById(excerpt.id)
      .then((Contest contest) async {
        this.contest = contest;
        
        if(contest.playersReports.isNotEmpty && 
          excerpt.status != ContestStatuses.ended) {
          _setPlayersPoints();
          await _updateContestRanks();
        }

        emit(null);
      })
      .catchError((error) => emit(CubitState.fetchError));
  }

  Future<void> _updateContestRanks() async {
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
  }

  void _setPlayersPoints() {
    int totalPlayers = contest.playersReports.length;
    String matchType = excerpt.type;
      
    for(int i = 0; i < totalPlayers; i++) {
      Report report = contest.playersReports[i];
      
      contest.playersPoints[i] 
        = PointsCalculator.getRunsTakenPoints(report.runsTaken)
        + PointsCalculator.getFoursHitPoints(report.foursHit)
        + PointsCalculator.getSixesHitPoints(report.sixesHit)
        + PointsCalculator.getHalfCenturyPoints(report.runsTaken, matchType)
        + PointsCalculator.getCenturyPoints(report.runsTaken, matchType)
        + PointsCalculator.getStrikeRatePoints(report.ballsFaced, 
          report.runsTaken, matchType)
        + PointsCalculator.getWicketsTakenPoints(report.wicketsTaken, matchType)
        + PointsCalculator.getFourWicketsPoints(report.wicketsTaken, matchType)
        + PointsCalculator.getFiveWicketsPoints(report.wicketsTaken, matchType)
        + PointsCalculator.getMaidenOversPoints(report.maidenOvers, matchType)
        + PointsCalculator.getEconomyRatePoints(report.ballsBowled, 
          report.runsGiven, matchType)
        + PointsCalculator.getCatchesPoints(report.catches)
        + PointsCalculator.getStumpingsPoints(report.stumpings)
        + PointsCalculator.getRunOutsPoints(report.runOuts)
        + PointsCalculator.getIsPlayingPoints(contest.isPlayings[i])
        + PointsCalculator.getPlayerOfTheMatchPoints(contest.playerOfTheMatch ==
          contest.playersNames[i]);
    }
  }
}
