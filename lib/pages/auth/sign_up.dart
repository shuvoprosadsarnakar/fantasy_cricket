import 'package:fantasy_cricket/pages/auth/cubits/sign_up_cubit.dart';
import 'package:fantasy_cricket/pages/auth/sign_in.dart';
import 'package:fantasy_cricket/pages/auth/verify_email.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  final SignUpCubit _cubit;

  SignUp(this._cubit);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
        actions: [getSignInButton(context)],  
      ),
      body: BlocBuilder(
        bloc: _cubit,
        builder: (BuildContext contest, CubitState state) {
          if(state == CubitState.loading) {
            return Loading();
          } else {
            return Form(
              key: _cubit.formKey,
              child: ListView(
                padding: Paddings.pagePadding,
                children: [
                  // username field
                  FormFieldTitle('Username'),
                  getUsernameField(),
                  SizedBox(height: 20),

                  // email field
                  FormFieldTitle('Email'),
                  getEmailField(),
                  SizedBox(height: 20),

                  // password field
                  FormFieldTitle('Password'),
                  getPasswordField(),
                  SizedBox(height: 30),

                  // sign up button
                  getSignUpButton(context),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  TextButton getSignInButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.popAndPushNamed(context, signIn),
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  FormTextField getUsernameField() {
    return FormTextField(
      initialValue: _cubit.user.username,
      keyboardType: TextInputType.name,
      validator: (String value) {
        if(value.trim().isEmpty) {
          return 'Username is required.';
        } else {
          return null;
        }
      },
      onSaved: (String value) => _cubit.user.username = value.trim(),
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

  FormSubmitButton getSignUpButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Sign Up',
      onPressed: () async {
        if(await _cubit.createUserAndVerifyEmail()) {
          Navigator.popAndPushNamed(context, verifyEmail);
        } else if(_cubit.state == CubitState.duplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Given username is alreday taken.'))
          );
        } else if(_cubit.state == CubitState.signUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_cubit.errorMsg))
          );
        }
      },
    );
  }
}
