import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  fetched,
  rebuild,
}

class RunningContestsCubit extends Cubit<CubitState> { 
  List<Series> notEndedSerieses = <Series>[];
  User user;
  
  RunningContestsCubit() : super(null) {
    emit(CubitState.loading);
    getNotEndedSerieses();
  }

  void getNotEndedSerieses() async {
    String uid = AuthRepo.getCurrentUser().uid;

    try {
      user = await UserRepo.getUserById(uid);
      await SeriesRepo.assignNotEndedSerieses(notEndedSerieses);
      emit(CubitState.fetched);
    } catch(error) {
      print(error);
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

  static int getSeriesTotalChips(Series series) {
    int seriesTotalChips = 0;
    
    series.chipsDistributes.forEach((Distribute distribute) {
      seriesTotalChips 
        += distribute.chips * (distribute.to - distribute.from + 1);
    });

    return seriesTotalChips;
  }
}
