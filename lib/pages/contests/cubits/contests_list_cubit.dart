import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading, // fetching not ended serieses from db
  fetchError, // failed to fetch not ended serieses from db
  rebuild, // a contest is run or locked or updated
}

class ContestsListCubit extends Cubit<CubitState> {
  // this will be used to create [UpcomingContestsList] screen
  final List<Series> notEndedSerieses = <Series>[];
  
  ContestsListCubit() : super(null) {
    emit(CubitState.loading);
    
    SeriesRepo.assignNotEndedSerieses(notEndedSerieses)
      .catchError((dynamic error) => emit(CubitState.fetchError))
      .then((void value) => emit(null));
  }

  // this function emit a state to rebuild ui
  void rebuildUi() {
    if(state == CubitState.rebuild) {
      emit(null);
    } else {
      emit(CubitState.rebuild);
    }
  }
}
