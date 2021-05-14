import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/repositories/exchange_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  loaded,
  fetchError,
  refresh,
}

class ExchangesListCubit extends Cubit<CubitState> {
  List<Exchange> exchanges = <Exchange>[];

  ExchangesListCubit() : super(null) {
    emit(CubitState.loading);

    ExchangeRepo.getAllExchanges()
      .then((List<Exchange> exchanges) {
        this.exchanges = exchanges;
        emit(CubitState.loaded);
      })
      .catchError((dynamic error) {
        emit(CubitState.fetchError);
        return null;
      });
  }

  void refreshUi() {
    if(state == CubitState.refresh) {
      emit(null);
    } else {
      emit(CubitState.refresh);
    }
  }
}
