import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  emailVerified,
}

class VerifyEmailCubit extends Cubit<CubitState> {
  VerifyEmailCubit() : super(null);
  
  Future<void> checkEmailStatus() async {
    emit(CubitState.loading);
    
    if(await AuthRepo.isEmailVerified()) {
      emit(CubitState.emailVerified);
    } else {
      emit(null);
    }
  }
}
