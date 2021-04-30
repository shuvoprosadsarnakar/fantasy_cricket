import 'package:fantasy_cricket/pages/auth/cubits/sign_in_cubit.dart';
import 'package:fantasy_cricket/pages/auth/password_reset.dart';
import 'package:fantasy_cricket/pages/auth/sign_up.dart';
import 'package:fantasy_cricket/pages/auth/verify_email.dart';
import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  static final String routeName = 'sign_in';
  final SignInCubit _cubit;

  SignIn(this._cubit);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        actions: [getSignUpButton(context)],
      ),
      body: Form(
        key: _cubit.formKey,
        child: ListView(
          padding: Paddings.pagePadding,
          children: [
            // email field
            FormFieldTitle('Email'),
            getEmailField(),
            SizedBox(height: 20),

            // password field
            FormFieldTitle('Password'),
            getPasswordField(),
            SizedBox(height: 30),

            // buttons
            getSignInButton(context),
            SizedBox(height: 10),
            getForgotPasswordButton(context),
          ],
        ),
      ),
    );
  }

  TextButton getSignUpButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.popAndPushNamed(context, SignUp.routeName),
      child: Text(
        'Sign Up',
        style: TextStyle(color: Colors.white),
      ),
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

  FormTextField getPasswordField() {
    return FormTextField(
      initialValue: _cubit.password,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (String value) {
        if(value.trim().isEmpty) {
          return 'Password is required.';
        } else {
          return null;
        }
      },
      onSaved: (String value) => _cubit.password = value,
    );
  }

  FormSubmitButton getSignInButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Sign In',
      onPressed: () async {
        if(await _cubit.signInUser()) {
          if(await AuthRepo.isEmailVerified()) {
            print('home page');
          } else {
            Navigator.popAndPushNamed(context, VerifyEmail.routeName);
          }
        } else if(_cubit.state == CubitState.signInError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_cubit.errorMsg)
          ));
        }
      },
    );
  }

  TextButton getForgotPasswordButton(BuildContext context) {
    return TextButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        Navigator.popAndPushNamed(context, PasswordReset.routeName);
      },
    );
  }
}
