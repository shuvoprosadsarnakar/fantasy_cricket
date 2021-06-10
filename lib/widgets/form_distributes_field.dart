import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/widgets/form_field_title.dart';
import 'package:fantasy_cricket/widgets/form_integer_field.dart';
import 'package:fantasy_cricket/widgets/form_text_field.dart';
import 'package:flutter/material.dart';

class FormDistributesField extends StatelessWidget {
  final List<Distribute> _chipsDistributes;
  final Function _removeChipsDistribute;
  final Function _addChipsDistribute;

  FormDistributesField(
    this._chipsDistributes,
    this._addChipsDistribute,
    this._removeChipsDistribute,  
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldTitle('Chips Distributes'),
        SizedBox(height: 15),
        getChipsDistributesSubtitles(),
        SizedBox(height: 5),
        getChipsDistributesFields(),
        SizedBox(height: 10),
        getChipsDistributesButtons(),
      ],
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
    
    _chipsDistributes.forEach((Distribute distribute) {
      chipsDistributesFields.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // chips field
          Expanded(
            child: FormTextField(
              initialValue: distribute.chips == null ? null : 
                distribute.chips.toString(),
              keyboardType: TextInputType.number,
              validator: (String value) {
                if (value == null || value.trim() == '') {
                  return 'Enter an integer.';
                }

                int parsed;

                try { 
                  parsed = int.parse(value);
                } catch(error) {
                  return 'Enter a valid integer.';
                }

                if(parsed <= 0) {
                  return 'Integer must be greater than zero.';
                } else {
                  return null;
                }
              },
              onSaved: (String value) { 
                distribute.chips = int.parse(value);
              },
            ),
          ),
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
        if(_chipsDistributes.length > 1) Column(children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: _removeChipsDistribute,
          ),
          SizedBox(width: 30),
        ]),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _addChipsDistribute,
        )
      ],
    );
  }
}
