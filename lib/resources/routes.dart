import 'package:fantasy_cricket/pages/auth/cubits/password_reset_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/sign_in_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/sign_up_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/verify_email_cubit.dart';
import 'package:fantasy_cricket/pages/auth/password_reset.dart';
import 'package:fantasy_cricket/pages/auth/sign_in.dart';
import 'package:fantasy_cricket/pages/auth/sign_up.dart';
import 'package:fantasy_cricket/pages/auth/verify_email.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  SignUp.routeName: (BuildContext context) {
    return SignUp(SignUpCubit());
  },
  VerifyEmail.routeName: (BuildContext context) {
    return VerifyEmail(VerifyEmailCubit());
  },
  SignIn.routeName: (BuildContext context) {
    return SignIn(SignInCubit());
  },
  PasswordReset.routeName: (BuildContext context) {
    return PasswordReset(PasswordResetCubit());
  },
};