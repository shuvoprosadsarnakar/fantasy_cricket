import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetched,
  fetchError,
}

class FantasyPlayerPointsCubit extends Cubit<CubitState> {
  final Contest contest;
  final String username;
  Fantasy fantasy;
  
  FantasyPlayerPointsCubit(this.contest, this.username) : super(null) {
    emit(CubitState.loading);
    
    FantasyRepo.getFantasy(username, contest.id)
      .then((Fantasy fantasy) {
        this.fantasy = fantasy;
        emit(CubitState.fetched);
      })
      .catchError((dynamic error) {
        emit(CubitState.fetchError);
        return null;
      });
  }
}
