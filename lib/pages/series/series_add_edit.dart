import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/times.dart';
import 'package:fantasy_cricket/pages/series/cubits/series_add_edit_2_cubit.dart';
import 'package:fantasy_cricket/pages/series/cubits/series_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/series/series_add_edit_2.dart';
import 'package:fantasy_cricket/resources/paddings.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_integer_field.dart';
import 'package:fantasy_cricket/widgets/form_submit_button.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_time_picker/date_time_picker.dart';

class SeriesAddEdit extends StatelessWidget {
  // variable to manage the state of this screen
  final SeriesAddEditCubit _seriesAddEditCubit;

  // this will be true if a series is added successfully
  final bool _isSeriesAdded;
  
  SeriesAddEdit(this._seriesAddEditCubit, this._isSeriesAdded);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_seriesAddEditCubit.series.id == null ? 
        'Add Series' : 'Update Series')),
      body: Form(
        key: _seriesAddEditCubit.formKey,
        child: BlocBuilder<SeriesAddEditCubit, AddEditStatus>(
          bloc: _seriesAddEditCubit,
          builder: (BuildContext context, AddEditStatus addEditStatus) {
            if(_isSeriesAdded) {
              Future.delayed(Duration()).then((dynamic value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Series is added successfully.'))
                );
              });
            }

            return ListView(
              padding: Paddings.pagePadding,
              children: [
                // series name field
                getNameFieldWithTitle(),
                SizedBox(height: 20),

                // series photo field
                getPhotoFieldWithTitle(),
                SizedBox(height: 20),
                
                // chips distributes fields
                FormFieldTitle('Chips Distributes'),
                SizedBox(height: 15),
                getChipsDistributesSubtitles(),
                SizedBox(height: 5),
                getChipsDistributesFields(),
                SizedBox(height: 10),
                getChipsDistributesButtons(),
                SizedBox(height: 10),

                // date pickers
                FormFieldTitle('Times'),
                getDatePickers(),
                SizedBox(height: 30),

                // form submit button
                getFormSubmitButton(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Column getNameFieldWithTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Name'),
        FormTextField(
          hintText: 'Enter series name',
          initialValue: _seriesAddEditCubit.series.name,
          validator: (String value) {
            if (value == null || value.trim() == '') {
              return 'Series name is required.';
            } else {
              return null;
            }
          },
          onSaved: (String value) {
            _seriesAddEditCubit.series.name = value.trim();
          },
        ),
      ],
    );
  }

  Column getPhotoFieldWithTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Photo'),
        FormTextField(
          hintText: 'Enter series photo url',
          keyboardType: TextInputType.url,
          initialValue: _seriesAddEditCubit.series.photo,
          onSaved: (String value) {
            _seriesAddEditCubit.series.photo = value.trim();
          },
        ),
      ],
    );
  }

  Column getDatePickers() {
    Times times = _seriesAddEditCubit.series.times;
    
    return Column(children: [
      // start date picker
      DateTimePicker(
        type: DateTimePickerType.dateTime,
        initialValue: times.start == null ? DateTime.now().toString() : 
          times.start.toDate().toString(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2100),
        dateLabelText: 'Start Date',
        validator: (String value) {
          if(value == 'null') {
            return 'Start date is required.';
          } else {
            // this assignment done here instead inside [onSaved] to check that
            // if end date is before start date
            times.start = Timestamp.fromDate(DateTime.parse(value));
            return null;
          }
        },
      ),

      // space between date pickers
      SizedBox(height: 10),

      // end date picker
      DateTimePicker(
        type: DateTimePickerType.dateTime,
        initialValue: times.end == null ? DateTime.now().toString() : 
          times.end.toDate().toString(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2100),
        dateLabelText: 'End Date',
        validator: (String value) {
          if(value == 'null') {
            return 'End date is required.';
          } else {
            // this assignment done here instead inside [onSaved] to check that
            // if end date is before start date
            times.end = Timestamp.fromDate(DateTime.parse(value));

            if((times.start != null) && 
              (times.start.seconds > times.end.seconds)) {
              return 'End date is before start date.';
            } else {
              return null;
            }
          }
        },
      ),
    ]);
  }

  FormSubmitButton getFormSubmitButton(BuildContext context) {
    return FormSubmitButton(
      title: 'Submit',
      onPressed: () {
        if(_seriesAddEditCubit.validateSaveFirstForm()) {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return SeriesAddEdit2(SeriesAddEdit2Cubit(
                _seriesAddEditCubit.series));
            },
          ));
        }
      },
    );
  }

  Row getChipsDistributesSubtitles() {
    return Row(
      children: [
        Expanded(child: Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text('Chips'),
        )),
        Expanded(child: Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text('From'),
        )),
        Expanded(child: Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text('To'),
        )),
      ],
    );
  }

  Column getChipsDistributesFields() {
    List<Widget> chipsDistributesFields = [];
    
    _seriesAddEditCubit.series.chipsDistributes.forEach((Distribute distribute) {
      chipsDistributesFields.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // chips field
          Expanded(child: FormIntegerField(
            initialValue: distribute.chips == null ? null : 
              distribute.chips.toString(),
            onSaved: (String value) { 
              distribute.chips = int.parse(value);
            }
          )),
          SizedBox(width: 5),

          // from field
          Expanded(child: FormIntegerField(
            initialValue: distribute.from == null ? null : 
              distribute.from.toString(),
            onSaved: (String value) { 
              distribute.from = int.parse(value);
            }
          )),
          SizedBox(width: 5),

          // to field
          Expanded(child: FormIntegerField(
            initialValue: distribute.to == null ? null : 
              distribute.to.toString(),
            onSaved: (String value) { 
              distribute.to = int.parse(value);
            }
          )),
        ],
      ));

      chipsDistributesFields.add(SizedBox(height: 5));
    });

    return Column(children: chipsDistributesFields);
  }

  Row getChipsDistributesButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(_seriesAddEditCubit.series.chipsDistributes.length > 1)
          Column(children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: _seriesAddEditCubit.removeChipsDistribute,
            ),
            SizedBox(width: 30),
          ]),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _seriesAddEditCubit.addChipsDistribute,
        )
      ],
    );
  }
}
