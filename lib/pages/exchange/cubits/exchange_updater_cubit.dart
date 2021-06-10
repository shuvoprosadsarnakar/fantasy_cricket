import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/exchange_repo.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';
import 'package:fantasy_cricket/resources/exchange_statuses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  failed,
  fetched,
  updated,
  refresh,
}

class ExchangeUpdaterCubit extends Cubit<CubitState> {
  final Exchange exchange;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isFailed;
  User user;

  ExchangeUpdaterCubit(this.exchange) : super(null) {
    isFailed = (exchange.status == ExchangeStatuses.failed) ? true : false;
    emit(CubitState.loading);
    
    UserRepo.getUserById(exchange.userId)
      .then((User user) {
        this.user = user;
        emit(CubitState.fetched);
      })
      .catchError((dynamic error) {
        emit(CubitState.failed);
      });
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

    try {
      await ExchangeRepo.updateExchange(exchange, user);
      emit(CubitState.updated);
    } catch(error) {
      emit(CubitState.failed);
    }
  }
}
