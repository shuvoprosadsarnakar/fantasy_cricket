import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/exchange_repo.dart';
import 'package:fantasy_cricket/resources/exchange_statuses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  failed,
  updated,
  refresh,
}

class ExchangeUpdaterCubit extends Cubit<CubitState> {
  final Exchange exchange;
  bool isFailed;

  ExchangeUpdaterCubit(this.exchange) : super(null) {
    isFailed = (exchange.status == ExchangeStatuses.failed) ? true : false;
  }

  void refreshUi() {
    if(state == CubitState.refresh) {
      emit(null);
    } else {
      emit(CubitState.refresh);
    }
  }

  void updateUserAndExchange(User user) {
    if(isFailed) {
      if(exchange.status != ExchangeStatuses.failed) {
        exchange.status = ExchangeStatuses.failed;
        user.remainingChips += exchange.chips;
      }
    } else {
      if(exchange.status == ExchangeStatuses.failed) {
        exchange.status = ExchangeStatuses.successfull;
        user.remainingChips -= exchange.chips;
      } else if(exchange.status == ExchangeStatuses.processing) {
        exchange.status = ExchangeStatuses.successfull;
      }
    }
  }

  Future<void> updateExchangeInDb() async {
    try {
      await ExchangeRepo.updateExchange(exchange, updateUserAndExchange);
      emit(CubitState.updated);
    } catch(error) {
      emit(CubitState.failed);
    }
  }
}
