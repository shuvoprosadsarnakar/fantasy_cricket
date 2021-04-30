import 'package:fantasy_cricket/pages/auth/cubits/password_reset_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/sign_in_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/verify_email_cubit.dart';
import 'package:fantasy_cricket/pages/auth/password_reset.dart';
import 'package:fantasy_cricket/pages/auth/sign_in.dart';
import 'package:fantasy_cricket/pages/auth/verify_email.dart';
import 'package:flutter/material.dart';

const String signIn = '/';
const String signUp = '/signup';
const String player = '/player';
const String team = '/team';
const String verifyEmail = '/verifyEmail';
const String passwordReset = '/passwordReset';
const String home = '/home';

final Map<String, WidgetBuilder> routes = {

  VerifyEmail.routeName: (BuildContext context) {
    return VerifyEmail(VerifyEmailCubit());
  },
  SignIn.routeName: (BuildContext context) {
    return SignIn(SignInCubit());
  }
};