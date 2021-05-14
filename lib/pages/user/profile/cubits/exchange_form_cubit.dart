import 'package:fantasy_cricket/models/exchange.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/exchange_repo.dart';
import 'package:fantasy_cricket/utils/exchange_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  notValid,
  failed,
}

class ExchangeFormCubit extends Cubit<CubitState> {
  final User user;
  int minExchangeLimit = 1;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Exchange exchange = Exchange(
    status: ExchangeStatuses.processing,
    details: 'Please wait for the exchange.',
  );
  
  ExchangeFormCubit(this.user) : super(null) { 
    exchange.userId = user.id;
  }

  Future<void> exchangeChips() async {
    emit(CubitState.loading);

    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      user.remainingChips -= exchange.chips;

      try {
        // add exchange and update user
        await ExchangeRepo.addExchange(exchange, user);
      } catch(error) {
        user.remainingChips += exchange.chips;
        emit(CubitState.failed);
      }
    } else {
      emit(CubitState.notValid);
    }
  }
}
