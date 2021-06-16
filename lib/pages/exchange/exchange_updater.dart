import 'package:fantasy_cricket/pages/exchange/cubits/exchange_updater_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeUpdater extends StatelessWidget {
  final ExchangeUpdaterCubit _cubit;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  ExchangeUpdater(this._cubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Update Exchange')),
            body: Form(
              key: formKey,
              child: ListView(
                padding: Paddings.pagePadding,
                children: [
                  getDetailsFormField(),
                  SizedBox(height: 10),
                  getIsFailedField(),
                  SizedBox(height: 20),
                  getFormSubmitButton(context),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Column getDetailsFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Details'),
        FormTextField(
          hintText: 'Enter details of exchange',
          initialValue: _cubit.exchange.details,
          onSaved: (String value) {
            _cubit.exchange.details = value.trim();
          },
        ),
      ],
    );
  }

  Row getIsFailedField() {
    return Row(children: [
      Checkbox(
        value: _cubit.isFailed,
        onChanged: (bool value) {
          _cubit.isFailed = value;
          _cubit.refreshUi();
        },
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: FormFieldTitle('Exchange Failed'),
      ),
    ]);
  }

  FormSubmitButton getFormSubmitButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Update Exchange',
      onPressed: () async {
        formKey.currentState.save();
        await _cubit.updateExchangeInDb();

        String msg;

        if(_cubit.state == CubitState.failed) {
          msg = 'Failed to update exchange.';
        } else if(_cubit.state == CubitState.updated) {
          msg = 'Exchange is updated successfully.';
        }

        if(msg != null) ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg))
        );
      },
    );
  }
}
