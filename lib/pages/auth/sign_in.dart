import 'package:fantasy_cricket/pages/auth/cubits/sign_in_cubit.dart';
import 'package:fantasy_cricket/repositories/auth_repo.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  static final String routeName = 'sign_in';
  final SignInCubit _cubit;

  SignIn(this._cubit);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController myController; 
  @override
  void initState() {
    super.initState();
    myController = TextEditingController(); 
    loadSavedEmail();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: widget._cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Sign In'),
              actions: [getSignUpButton(context)],
            ),
            body: Form(
              key: widget._cubit.formKey,
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
      },
    );
  }

  loadSavedEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myController.text = prefs.getString('email') ?? '';
    });
  }

  saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  TextButton getSignUpButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.popAndPushNamed(context, signUp),
      child: Text(
        'Sign Up',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  FormTextField getEmailField() {
    return FormTextField(
      keyboardType: TextInputType.emailAddress,
      controller: myController,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Email is required.';
        } else {
          return null;
        }
      },
      onSaved: (String value) => widget._cubit.email = value,
    );
  }

  FormTextField getPasswordField() {
    return FormTextField(
      initialValue: widget._cubit.password,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Password is required.';
        } else {
          return null;
        }
      },
      onSaved: (String value) => widget._cubit.password = value,
    );
  }

  FormSubmitButton getSignInButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Sign In',
      onPressed: () async {
        if (await widget._cubit.signInUser()) {
          if (await AuthRepo.isEmailVerified()) {
            saveEmail(widget._cubit.email);
            Navigator.popAndPushNamed(context, home);
          } else {
            await AuthRepo.getCurrentUser().sendEmailVerification();
            Navigator.popAndPushNamed(context, verifyEmail);
          }
        } else if (widget._cubit.state == CubitState.signInError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(widget._cubit.errorMsg)));
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
        Navigator.popAndPushNamed(context, passwordReset);
      },
    );
  }
}
