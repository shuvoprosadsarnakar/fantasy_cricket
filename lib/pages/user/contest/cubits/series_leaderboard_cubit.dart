import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  loaded,
}

class SeriesLeaderboardCubit extends Cubit<CubitState> {
  final Series series;
  final User user;
  List<Contest> seriesContests = <Contest>[];
  List<Rank> userContestRanks = <Rank>[];

  SeriesLeaderboardCubit(this.series, this.user) : super(null) {
    emit(CubitState.loading);
    _getuserContestRanks();
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

    emit(CubitState.loaded);
  }

  static int getRank(int rankIndex) {
    return rankIndex + 1;
  }
}
