import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  loaded,
  fetchError,
}

class ProfileCubit extends Cubit<CubitState> {
  User user;
  
  ProfileCubit() : super(null) {
    emit(CubitState.loading);

    String userId = AuthRepo.getCurrentUser().uid;

    UserRepo.getUserById(userId)
      .then((User user) {
        this.user = user;
        emit(CubitState.loaded);
      })
      .catchError((dynamic error) {
        emit(CubitState.fetchError);
        return null;
      });
  }

  int getExchangedChips() {
    return user.earnedChips - user.remainingChips;
  }
}
