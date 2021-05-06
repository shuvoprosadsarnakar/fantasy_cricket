import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/fantasy_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  fetched,
}

class MatchLeaderboardCubit extends Cubit<CubitState> {
  final Contest contest;
  final User user;
  final String contestStatus;
  List<Fantasy> matchFantasies;

  MatchLeaderboardCubit(this.contest, this.user, this.contestStatus) : 
    super(null) {
    emit(CubitState.loading);
    getAllMatchFantasies();
  }

  void getAllMatchFantasies() async {
    try {
      matchFantasies = await FantasyRepo.getFantasiesByContestId(contest.id);
      emit(CubitState.fetched);
    } catch(error) {
      emit(CubitState.fetchError);
    }
  }
}
