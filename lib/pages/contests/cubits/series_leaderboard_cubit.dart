import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/rank.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
}

class SeriesLeaderboardCubit extends Cubit<CubitState> {
  final String username;
  Series series;
  List<Contest> seriesContests = <Contest>[];
  List<Rank> userContestRanks = <Rank>[];

  SeriesLeaderboardCubit(this.series, this.username) : super(null) {
    emit(CubitState.loading);

    SeriesRepo.getSeriesById(series.id)
      .then((Series series) {
        this.series = series;
        _getuserContestRanks();
      })
      .catchError((error) => emit(CubitState.fetchError));
  }

  Future<void> _getuserContestRanks() async {
    final int totalExcerpts = series.matchExcerpts.length;

    for(int i = 0; i < totalExcerpts; i++) {
      final Excerpt excerpt = series.matchExcerpts[i];

      if(excerpt.id == null) {
        seriesContests.add(null);
      } else {
        try {
          seriesContests.add(await ContestRepo.getContestById(excerpt.id));
        } catch(error) {
          emit(CubitState.fetchError);
          return;
        }
      }
    }

    seriesContests.forEach((Contest contest) {
      if(contest == null) {
        userContestRanks.add(null);
      } else {
        userContestRanks.add(contest.ranks.firstWhere(
          (Rank rank) {
            return rank.username == username;
          },
          orElse: () => null,
        ));
      }
    });

    emit(null);
  }
}
