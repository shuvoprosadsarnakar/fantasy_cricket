import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
}

class MatchLeaderBoardCubit extends Cubit<CubitState> {
  Contest contest;
  final Excerpt excerpt;
  final User user;
  
  MatchLeaderBoardCubit(this.excerpt, this.user) : super(null) {
    emit(CubitState.loading);
    ContestRepo.getContestById(excerpt.id)
      .catchError((error) {
        emit(CubitState.fetchError);
      })
      .then((Contest contest) {
        this.contest = contest;
        emit(null);
      });
  }
}
