import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/user.dart' as model;
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  rebuild,
}

class ContestDetialsCubit extends Cubit<CubitState> {
  final Series series;
  final Excerpt excerpt;
  model.User user;
  Contest contest;

  ContestDetialsCubit(this.series, this.excerpt, [this.user]) : super(null) {
    emit(CubitState.loading);
    initCubit();
  }

  void initCubit() async {
    try{
      contest = await ContestRepo.getContestById(excerpt.id);
      
      if(user == null) {
        final String userId = FirebaseAuth.instance.currentUser.uid;
        user = await UserRepo.getUserById(userId);
      }
      
      emit(null);
    } catch(error) {
      emit(CubitState.fetchError);
    }
  }

  void rebuildUi() {
    if(state == CubitState.rebuild) {
      emit(null);
    } else {
      emit(CubitState.rebuild);
    }
  }
}
