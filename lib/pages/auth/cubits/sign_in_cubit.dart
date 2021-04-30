import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  validationError,
  signInError,
}

class SignInCubit extends Cubit<CubitState> {
  SignInCubit() : super(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  String email;
  String password;
  String errorMsg;

  Future<bool> signInUser() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      emit(CubitState.loading);

      try {
        await AuthRepo.signIn(email, password);
        // [true] is returned here instead of emitting state to go to the
        // next screen whithout rebuilding [SignIn] screen when everything
        // is successfully done
        return true;
      } catch(error) {
        errorMsg = error.message;
        emit(CubitState.signInError);
      }
    } else {
      emit(CubitState.validationError);
    }

    // this is only done to remove vs code editor suggestion, this is useless
    return false;
  }
}
