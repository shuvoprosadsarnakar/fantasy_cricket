import 'package:fantasy_cricket/resources/colours/colour_pallate.dart';
import 'package:fantasy_cricket/screens/add_player/add_player_cubit.dart';
import 'package:fantasy_cricket/screens/add_player/player_role_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddPlayerCubit addPlayerCubit = AddPlayerCubit();
    final PlayerRoleCubit playerRoleCubit = PlayerRoleCubit();

    // login admin to insert player into firestore
    if(FirebaseAuth.instance.currentUser() == null) {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'ranganroy567@gmail.com',
        password: '1234567890',
      ).then((AuthResult authResult) => print(authResult));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add Player')),
      body: Form(
        key: addPlayerCubit.formKey,
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
                  initialValue: addPlayerCubit.playerName,
                  cursorColor: Colors.black38,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 16),
                    hintText: 'Enter name e.g. Sachin Tendulkar',
                  ),
                  validator: (String value) {
                    if(value.isEmpty) {
                      return 'Player name is required.';
                    } else  return null;
                  },
                  onSaved: (String value) {
                    addPlayerCubit.playerName = value;
                  },
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
                    return DropdownButtonFormField<String>(
                      value: playerRoleCubit.state,
                      isExpanded: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
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
                      validator: (String value) {
                        if(value == null) {
                          return 'Select a player role.';
                        } else return null;
                      },
                      onSaved: (String value) {
                        addPlayerCubit.playerRole = value;
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
                addPlayerCubit.addPlayerToDb(playerRoleCubit.state);
              },
            )
          ],
        ),
      ),
    );
  }
}
