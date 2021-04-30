import 'package:fantasy_cricket/models/user.dart' as model;
import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:fantasy_cricket/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CubitState {
  loading,
  signUpError,
  duplicate,
  validationError,
}

class SignUpCubit extends Cubit<CubitState> {
  SignUpCubit() : super(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final model.User user = model.User();
  
  String email;
  String password;
  String errorMsg;

  Future<bool> createUserAndVerifyEmail() async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      emit(CubitState.loading);

      if(await UserRepo.checkUsername(user.username)) {
        try {
          UserCredential cred = await AuthRepo.createUser(email, password);
          user.id = cred.user.uid;
          try {
            await UserRepo.addUser(user);
            await cred.user.sendEmailVerification();
            // [true] is returned here instead of emitting state to go to the
            // [VerifyEmail] screen whithout rebuilding [SignUp] screen when 
            // everything is successfully done
            return true;
          } catch(error) {
            await cred.user.delete().catchError((error) => null);
            errorMsg = error.message;
            emit(CubitState.signUpError);
          }
        } catch(error) {
          errorMsg = error.message;
          emit(CubitState.signUpError);
        }
      } else {
        emit(CubitState.duplicate);
      }
    } else {
      emit(CubitState.validationError);
    }

    // this is only done to remove vs code editor suggestion, this is useless
    return false;
  }
}
