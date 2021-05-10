import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/series_rank.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:fantasy_cricket/repositories/series_rank_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  fetched,
}

class SeriesLeaderboardCubit extends Cubit<CubitState> {
  Series series;
  User user;
  SeriesRank seriesRank;
  List<Fantasy> seriesFantasies = [];

  SeriesLeaderboardCubit(this.series, this.user) : super(null) {
    emit(CubitState.loading);
    initCubit();
  }

  void initCubit() async {
    try {
      seriesRank = await SeriesRankRepo.getSeriesRankById(user.id + series.id);
    } catch(error) {
      emit(CubitState.fetchError);
      return;
    }

    series.matchExcerpts.forEach((Excerpt excerpt) async {
      try {
        seriesFantasies.add(
          await FantasyRepo.getFantasyById(user.id + excerpt.id)
        );

        if(series.matchExcerpts.length == seriesFantasies.length) {
          emit(CubitState.fetched);
        }
      } catch(error) {
        emit(CubitState.fetchError);
      }
    });
  }
}
