import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  fetched,
  rebuild,
}

class ContestDetialsCubit extends Cubit<CubitState> {
  final Series series;
  final Excerpt excerpt;
  final User user;
  Contest contest;

  ContestDetialsCubit(this.series, this.excerpt, this.user) : super(null) {
    emit(CubitState.loading);

    ContestRepo.getContestById(excerpt.id)
      .catchError((dynamic error) {
        emit(CubitState.fetchError);
      })
      .then((Contest contest) {
        this.contest = contest;
        emit(CubitState.fetched);
      });
  }

  void rebuildUi() {
    if(state == CubitState.rebuild) {
      emit(null);
    } else {
      emit(CubitState.rebuild);
    }
  }
}
