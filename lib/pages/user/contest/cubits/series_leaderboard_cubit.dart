import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
}

class SeriesLeaderboardCubit extends Cubit<CubitState> {
  final User user;
  Series series;
  List<Contest> seriesContests = <Contest>[];
  List<Rank> userContestRanks = <Rank>[];

  SeriesLeaderboardCubit(this.series, this.user) : super(null) {
    emit(CubitState.loading);

    SeriesRepo.getSeriesById(series.id)
      .catchError((error) {
        emit(CubitState.fetchError);
      })
      .then((Series series) {
        this.series = series;
        _getuserContestRanks();
      });
  }

  Future<void> _getuserContestRanks() async {
    int totalExcerpts = series.matchExcerpts.length;

    for(int i = 0; i < totalExcerpts; i++) {
      Excerpt excerpt = series.matchExcerpts[i];

      try {
        seriesContests.add(await ContestRepo.getContestById(excerpt.id));
      } catch(error) {
        emit(CubitState.fetchError);
        return;
      }
    }

    seriesContests.forEach((Contest contest) {
      userContestRanks.add(contest.ranks.firstWhere(
        (Rank rank) {
          return rank.username == user.username;
        },
        orElse: () => null,
      ));
    });

    emit(null);
  }

  static int getRank(int rankIndex) {
    return rankIndex + 1;
  }

  int get numberOfT20Matches {
    int totalMatches = 0;

    series.matchExcerpts.forEach((Excerpt excerpt) {
      if(excerpt.type == 'T20') totalMatches++;
    });

    return totalMatches;
  }

  int get numberOfOneDayMatches {
    int totalMatches = 0;

    series.matchExcerpts.forEach((Excerpt excerpt) {
      if(excerpt.type == 'One Day') totalMatches++;
    });

    return totalMatches;
  }

  int get numberOfTestMatches {
    int totalMatches = 0;

    series.matchExcerpts.forEach((Excerpt excerpt) {
      if(excerpt.type == 'Test') totalMatches++;
    });

    return totalMatches;
  }
}
