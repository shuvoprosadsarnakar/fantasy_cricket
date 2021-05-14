import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/repositories/exchange_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  loaded,
  fetchError,
}

class ExchangeHistoryCubit extends Cubit<CubitState> {
  final String userId;
  List<Exchange> exchanges = <Exchange>[];

  ExchangeHistoryCubit(this.userId) : super(null) {
    emit(CubitState.loading);

    ExchangeRepo.getExchangesByUserId(userId)
      .then((List<Exchange> exchanges) {
        this.exchanges = exchanges;
        emit(CubitState.loaded);
      })
      .catchError((dynamic error) {
        emit(CubitState.fetchError);
        return null;
      });
  }
}
