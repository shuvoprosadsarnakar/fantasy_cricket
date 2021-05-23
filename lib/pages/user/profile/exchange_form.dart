import 'package:fantasy_cricket/pages/user/profile/cubits/exchange_form_cubit.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/form_dropdown_field.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:fantasy_cricket/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeForm extends StatelessWidget {
  final ExchangeFormCubit _cubit;

  ExchangeForm(this._cubit);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (BuildContext context, CubitState state) {
        if(state == CubitState.loading) {
          return Loading();
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Exchange Chips')),
            body: Form(
              key: _cubit.formKey,
              child: ListView(
                padding: Paddings.pagePadding,
                children: [
                  getChipsField(),
                  SizedBox(height: 20),
                  getPaymentTypes(),
                  SizedBox(height: 20),
                  getMobileField(),
                  SizedBox(height: 25),
                  getFormSubmitButton(context),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Column getChipsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Chips'),
        FormTextField(
          hintText: 'Enter number of chips',
          keyboardType: TextInputType.number,
          validator: (String value) {
            if(value.trim() == '') {
              return 'Number of chips is required.';
            }

            int parsed;

            try {
              parsed = int.parse(value);
            } catch(error) {
              return 'Invalid chips value.';
            }

            if(parsed < _cubit.minExchangeLimit) {
              return '${_cubit.minExchangeLimit} chips is minimum.';
            } else if(parsed > _cubit.user.remainingChips) {
              return 'You have ${_cubit.user.remainingChips} chips left.';
            }

            return null;
          },
          onSaved: (String value) {
            _cubit.exchange.chips = int.parse(value);
          },
        ),
      ],
    );
  }

  Column getPaymentTypes() {
    List<String> paymentTypes = [
      'bKash',
      'Nagad',
      'Rocket',
      'Recharge',
    ];
    List<DropdownMenuItem<dynamic>> dropdownItems = paymentTypes.map(
      (String type) {
      return DropdownMenuItem<dynamic>(
        child: Text(type),
        value: type,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Payment Type'),
        FormDropdownField(
          hint: Text('Select a payment type'),
          items: dropdownItems,
          validator: (dynamic value) {
            if(value == null) {
              return 'Payment type is required.';
            } else {
              return null;
            }
          },
          onSaved: (dynamic value) {
            _cubit.exchange.paymentType = value;
          },
        ),
      ],
    );
  }

  Column getMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Mobile'),
        FormTextField(
          hintText: 'Enter a mobile number',
          keyboardType: TextInputType.phone,
          validator: (String value) {
            if(value.trim() == '') {
              return 'Mobile number is required.';
            } else {
              return null;
            }
          },
          onSaved: (String value) {
            _cubit.exchange.mobile = value.trim();
          },
        ),
      ],
    );
  }

  FormSubmitButton getFormSubmitButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Exchange',
      onPressed: () async {
        await _cubit.exchangeChips();

        if(_cubit.state != CubitState.notValid) {
          String snackBarText;

          if(_cubit.state == CubitState.failed) {
            snackBarText 
              = 'Failed to request for chips exchange, please try again.';
          } else {
            snackBarText = 'Chips exchange requested successfully.';
            Navigator.pop(context);
          }

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(snackBarText)
          ));
        }
      },
    );
  }
}
