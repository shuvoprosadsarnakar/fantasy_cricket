import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  fetchError,
  fetched,
  rebuild,
}

class ContestsListCubit extends Cubit<CubitState> {
  final List<Series> notEndedSerieses = <Series>[];
  
  ContestsListCubit() : super(null) {
    emit(CubitState.loading);
    _getNotEndedSeireses();
  }

  Future<void> _getNotEndedSeireses() async {
    try {
      await SeriesRepo.assignNotEndedSerieses(notEndedSerieses);
      emit(CubitState.fetched);
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
