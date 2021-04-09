import 'package:fantasy_cricket/resources/colours/colour_pallate.dart';
import 'package:fantasy_cricket/screens/add_player/player_role_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final PlayerRoleCubit playerRoleCubit = PlayerRoleCubit();

    return Scaffold(
      appBar: AppBar(title: Text('Add Player')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 45,
          ),
          children: [
            // name field
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Name",
                style: TextStyle(
                  color: ColourPallate.ebonyClay,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColourPallate.mercury,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                child: TextFormField(
                  cursorColor: Colors.black38,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 16),
                    hintText: 'Enter name e.g. Sachin Tendulkar',
                  ),
                ),
              ),
            ),

            // space between two fields
            SizedBox(height: 14),
            
            // role field
            Padding(
              padding: EdgeInsets.all(4),
              child: Text(
                "Role",
                style: TextStyle(
                  color: ColourPallate.ebonyClay,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColourPallate.mercury,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                child: BlocBuilder<PlayerRoleCubit, String>(
                  bloc: playerRoleCubit,
                  builder: (BuildContext context, String state) {
                    return DropdownButton<String>(
                      value: playerRoleCubit.state,
                      isExpanded: true,
                      underline: Container(
                        height: 1,
                        color: ColourPallate.mercury,
                      ),
                      hint: Text('Enter role e.g. Batsman'),
                      items: playerRoleCubit.playerRoles.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        playerRoleCubit.emitState(value);
                      },
                    );
                  }
                )
              ),
            ),

            // space between two fields
            SizedBox(height: 18),

            // add player button
            TextButton(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Add Player',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Colors.white,
                backgroundColor: ColourPallate.pomegranate,
              ),
              onPressed: () {
                print('Pressed!');
              },
            )
          ],
        ),
      ),
    );
  }
}
