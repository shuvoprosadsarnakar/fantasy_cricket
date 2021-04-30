import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  validationError,
  sendEmailError,
  emailSent,
}

class PasswordResetCubit extends Cubit<CubitState> {
  PasswordResetCubit() : super(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  String email;
  String errorMsg;

  Future<void> sendPasswordResetEmail() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      emit(CubitState.loading);

      try {
        await AuthRepo.sendPasswordResetEmail(email);
        // [true] is returned here instead of emitting state to go to the
        // next screen whithout rebuilding [PasswordReset] screen when 
        // everything is successfully done
        emit(CubitState.emailSent);
      } catch(error) {
        errorMsg = error.message;
        emit(CubitState.sendEmailError);
      }
    } else {
      emit(CubitState.validationError);
    }
  }
}