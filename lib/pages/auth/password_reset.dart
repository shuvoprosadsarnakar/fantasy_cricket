import 'package:fantasy_cricket/pages/auth/cubits/password_reset_cubit.dart';
import 'package:fantasy_cricket/pages/auth/sign_in.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordReset extends StatelessWidget {
  final PasswordResetCubit _cubit;
  final String msgForUser = 'A password reset email is sent to your account. ' +
    'Reset your password and then sign in.';

  PasswordReset(this._cubit);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else if(state == CubitState.emailSent) {
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
                    getSignInButton(context),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Password Reset'),
              actions: [getSignInAppBarButton(context)],  
            ),
            body: Form(
              key: _cubit.formKey,
              child: ListView(
                padding: Paddings.pagePadding,
                children: [
                  FormFieldTitle('Email'),
                  getEmailField(),
                  SizedBox(height: 30),
                  getPasswordResetButton(context),
                ],
              ),
            ),
          ); 
        }
      },
    );
  }

  FormTextField getEmailField() {
    return FormTextField(
      initialValue: _cubit.email,
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if(value.trim().isEmpty) {
          return 'Email is required.';
        } else {
          return null;
        }
      },
      onSaved: (String value) => _cubit.email = value,
    );
  }

  FormSubmitButton getPasswordResetButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Send Password Reset Email',
      onPressed: () async {
        await _cubit.sendPasswordResetEmail();

        if(_cubit.state == CubitState.sendEmailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_cubit.errorMsg))
          );
        }
      },
    );
  }

  FormSubmitButton getSignInButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Sign In',
      onPressed: () => Navigator.popAndPushNamed(context, signIn),
    );
  }

  TextButton getSignInAppBarButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.popAndPushNamed(context, signIn),
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
