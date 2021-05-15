import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/fantasy.dart';
import 'package:fantasy_cricket/models/rank.dart';
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
  Fantasy userFantasy;
  int userRank;
  int userRankIndex;

  MatchLeaderboardCubit(this.contest, this.user, this.contestStatus) : 
    super(null) 
  {
    emit(CubitState.loading);

    userRankIndex = contest.ranks.indexWhere((Rank rank) {
      return user.username == rank.username;
    });
    userRank = userRankIndex + 1;

    getUserFantasy();
  }

  void getUserFantasy() async {
    try {
      userFantasy = await FantasyRepo.getFantasyByUsername(user.username);
      emit(CubitState.fetched);
    } catch(error) {
      emit(CubitState.fetchError);
    }
  }
}
