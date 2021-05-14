import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/repositories/exchange_repo.dart';
import 'package:fantasy_cricket/utils/exchange_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  failed,
  updated,
  refresh,
}

class ExchangeUpdaterCubit extends Cubit<CubitState> {
  final Exchange exchange;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isFailed;

  ExchangeUpdaterCubit(this.exchange) : super(null) {
    isFailed = exchange.status == ExchangeStatuses.failed ? true : false;
  }

  void refreshUi() {
    if(state == CubitState.refresh) {
      emit(null);
    } else {
      emit(CubitState.refresh);
    }
  }

  Future<void> updateExchange() async {
    emit(CubitState.loading);
    formKey.currentState.save();

    if(isFailed) {
      exchange.status = ExchangeStatuses.failed;
    } else {
      exchange.status = ExchangeStatuses.successfull;
    }

    try {
      await ExchangeRepo.updateExchange(exchange);
      emit(CubitState.updated);
    } catch(error) {
      emit(CubitState.failed);
    }
  }
}
