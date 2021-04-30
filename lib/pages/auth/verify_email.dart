import 'package:fantasy_cricket/pages/auth/cubits/verify_email_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmail extends StatelessWidget {
  static final String routeName = 'verify_email';
  final VerifyEmailCubit _cubit;
  final String msgForUser = 'A verification email is sent to your email ' +
      'account. Please verfiy your email amd then click the play button.';

  VerifyEmail(this._cubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if (state == CubitState.loading) {
          return Loading();
        } else {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: Paddings.pagePadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msgForUser,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    getPlayButton(context),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  FormSubmitButton getPlayButton(context) {
    return FormSubmitButton(
      title: 'Play',
      onPressed: () async {
        await _cubit.checkEmailStatus();

        if (_cubit.state == CubitState.emailVerified) {
          Navigator.popAndPushNamed(context, home);
          print('home page');
        } else {
          Navigator.popAndPushNamed(context, signIn);
        }
      },
    );
  }
}
