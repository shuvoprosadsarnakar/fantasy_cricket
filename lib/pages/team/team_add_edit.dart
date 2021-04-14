import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';

class TeamAddEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add/Update Team')),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 45,
          vertical: 20,
        ),
        children: [
          // name field
          getNameField(),
          SizedBox(height: 15),

          // add player field, player search results and submit button
          Stack(
            clipBehavior: Clip.none,
            children: [
              // add player field and submit button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // add player field
                  getAddPlayerField(),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Add 11 more players.',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  ),
                  SizedBox(height: 20),

                  // submit button
                  SizedBox(
                    width: double.maxFinite,
                    child: getFormSubmitButton(context),
                  ),
                ],
              ),

              // // search results
              // Container(
              //   margin: EdgeInsets.only(top: 85),
              //   height: 300,
              //   width: double.maxFinite,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey,
              //         blurRadius: 5,
              //         offset: Offset(2, 2),
              //       ),
              //     ],
              //     color: Colors.white,
              //   ),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(10),
              //     child: ListView(
              //       children: [
              //         ListTile(
              //           title: Text('Shane Watson'),
              //           subtitle: Text('Batsman'),
              //         ),
              //         Divider(height: 1),
              //         ListTile(
              //           title: Text('Shane Watson'),
              //           subtitle: Text('Batsman'),
              //         ),
              //         Divider(height: 1),
              //         ListTile(
              //           title: Text('Shane Watson'),
              //           subtitle: Text('Batsman'),
              //         ),
              //         Divider(height: 1),
              //         ListTile(
              //           title: Text('Shane Watson'),
              //           subtitle: Text('Batsman'),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // returns field title
  Padding getFieldTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(4),
      child: Text(
        title,
        style: TextStyle(
          color: ColorPallate.ebonyClay,
          fontSize: 20,
        ),
      ),
    );
  }

  // returns name field with field title
  Column getNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitle('Name'),
        TextFormField(
          initialValue: '',
          cursorColor: Colors.black38,
          decoration: InputDecoration(
            fillColor: ColorPallate.mercury,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 6,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintStyle: TextStyle(fontSize: 16),
            hintText: 'Enter team name',
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Team name is required.';
            } else {
              return null;
            }
          },
          onSaved: (String value) {},
        ),
      ],
    );
  }

  // returns add player field with field title
  Column getAddPlayerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getFieldTitle('Add Player'),
        TextFormField(
          cursorColor: Colors.black38,
          decoration: InputDecoration(
            fillColor: ColorPallate.mercury,
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 6,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintStyle: TextStyle(fontSize: 16),
            hintText: 'Enter player name',
          ),
        ),
      ],
    );
  }

  // returns submit button
  TextButton getFormSubmitButton(BuildContext context) {
    return TextButton(
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 20),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        primary: Colors.white,
        backgroundColor: ColorPallate.pomegranate,
      ),
      onPressed: () async {

      },
    );
  }
}