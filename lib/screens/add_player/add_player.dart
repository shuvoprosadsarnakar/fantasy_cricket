import 'package:flutter/material.dart';

class AddPlayer extends StatefulWidget
{
  @override
  AddPlayerState createState() => AddPlayerState();
}

class AddPlayerState extends State<AddPlayer>
{
  var formKey = GlobalKey<FormState>();
  
  String name, bornDay, bornMonth, bornYear, nation, role, battingStyle, 
  bowlingStyle, description;

  List<String> bornDays = []; // needed for born field
  List<String> bornYears = []; // needed for born field

  List<String> roles = ['Batsman', 'Bowler', 'All Rounder', 'Wicket Keeper'];
  List<String> battingStyles = ['Right Handed Batsman', 'Left Handed Batsman'];
  List<String> bowlingStyles = ['Fast', 'Medium', 'Spin'];

  void initState()
  {
    super.initState();

    // init monthDays list
    for(int i = 1; i <= 31; i++) bornDays.add(i.toString());

    // init bornYears list
    int lastBornYear = DateTime.now().year - 17; // minimum player age is 17
    for(int i = 1980; i <= lastBornYear; i++) bornYears.add(i.toString());
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Player'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // name field
                  getTextFormField(
                    name: 'Name',
                    onSaved: (String value) => name = value,
                  ),

                  // born fields
                  Row(
                    children: [
                      Text('Born: '),
                      SizedBox(width: 10),

                      // born day field
                      Expanded(
                        child: getDropdownButtonFormField(
                          name: 'Day',
                          items: getDropdownButtonItems(bornDays),
                          onChanged: (value) => bornDay = value,
                        ),
                      ),
                      SizedBox(width: 10),

                      // born month field
                      Expanded(
                        child: getDropdownButtonFormField(
                          name: 'Month',
                          items: getBornMonthItems(),
                          onChanged: (value) => bornMonth = value,
                        ),
                      ),
                      SizedBox(width: 10),

                      // born year field
                      Expanded(
                        child: getDropdownButtonFormField(
                          name: 'Year',
                          items: getDropdownButtonItems(bornYears),
                          onChanged: (value) => bornYear = value,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: 10),
                  
                  // nation field
                  getTextFormField(
                    name: 'Nation',
                    onSaved: (String value) => nation = value,
                  ),

                  // role field
                  getDropdownButtonFormField(
                    name: 'Role',
                    items: getDropdownButtonItems(roles),
                    onChanged: (value) => role = value,
                  ),
                  SizedBox(height: 10),

                  // batting style field
                  getDropdownButtonFormField(
                    name: 'Batting style',
                    items: getDropdownButtonItems(battingStyles),
                    onChanged: (value) => battingStyle = value,
                  ),
                  SizedBox(height: 10),

                  // bowling style field
                  getDropdownButtonFormField(
                    name: 'Bowling style',
                    items: getDropdownButtonItems(bowlingStyles),
                    onChanged: (value) => bowlingStyle = value,
                  ),
                  SizedBox(height: 10),

                  // description field
                  getTextFormField(
                    name: 'Description (Optional)',
                    maxLines: 7,
                    maxLength: 10000,
                    onSaved: (String value) => description = value,
                    isRequired: false,
                  ),

                  // form buttons
                  Row(
                    children: [
                      // reset button
                      RaisedButton(
                        child: Text('Reset'),
                        onPressed: () => formKey.currentState.reset(),
                      ),
                      SizedBox(width: 10),

                      // submit button
                      RaisedButton(
                        child: Text('Submit'),
                        onPressed: () {
                          if(formKey.currentState.validate()) {
                            formKey.currentState.save();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column getTextFormField({String name, Function onSaved, int maxLength = 255, 
  int maxLines = 1, bool isRequired = true})
  {
    Function validator;

    if(isRequired) {
      validator = (String value) {
        if(value.length == 0) return '$name is required.';
      };
    } else validator = (String value) {};

    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(hintText: name),
          maxLength: maxLength,
          maxLines: maxLines,
          validator: validator,
          onSaved: onSaved,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  DropdownButtonFormField getDropdownButtonFormField({String name, List items, 
  Function onChanged})
  {
    return DropdownButtonFormField(
      hint: Text(name),
      items: items,
      onChanged: onChanged,
      validator: (value) {
        if(value == null) return '$name is required.';
      },
    );
  }

  List<DropdownMenuItem<String>> getDropdownButtonItems(List<String> items)
  {
    int itemsLength = items.length;
    List<DropdownMenuItem<String>> dropdownItems = [];

    for(int i = 0; i < itemsLength; i++)
    {
      dropdownItems.add(DropdownMenuItem(
        child: Text(items[i]),
        value: items[i],
      ));
    }

    return dropdownItems;
  }

  List<DropdownMenuItem<String>> getBornMonthItems()
  {
    List<String> monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 
    'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<DropdownMenuItem<String>> bornMonthItems = [];

    for(int i = 0; i < 12; i++)
    {
      bornMonthItems.add(DropdownMenuItem(
        child: Text(monthNames[i]),
        value: i.toString(),
      ));
    }

    return bornMonthItems;
  }
}