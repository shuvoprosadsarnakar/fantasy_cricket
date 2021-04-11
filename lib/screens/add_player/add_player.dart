import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/model/player.dart';
import 'package:fantasy_cricket/model/player_nr.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/screens/add_player/add_player_cubit.dart';
import 'package:fantasy_cricket/screens/add_player/player_role_cubit.dart';
import 'package:fantasy_cricket/services/database/player_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/addplayer_cubit.dart';

class AddPlayer extends StatelessWidget {
  final AddPlayerCubit addPlayerCubit = AddPlayerCubit();
  final List<String> playerRoles = <String>[
    'Batsman',
    'Wicket Keeper',
    'All Rounder',
    'Bowler',
  ];

  // dropdown item list for role field
  final List<DropdownMenuItem<String>> playerRoleDropdownList = [];
  
  @override
  Widget build(BuildContext context) {
    final AddPlayerCubit addPlayerCubit = AddPlayerCubit();
    final PlayerRoleCubit playerRoleCubit = PlayerRoleCubit();
    return Scaffold(
        appBar: AppBar(title: Text('Add Player')),
        body: BlocBuilder<AddplayersCubit, AddplayerState>(
          builder: (context, state) {
            if (state is AddplayerInitial) {
              return buildForm(addPlayerCubit, playerRoleCubit, context);
            } else if (state is AddplayerLoading) {
              print("AddplayerLoading");
              return buildLoading();
            } else if (state is AddplayerAdded) {
              print("AddplayerLoading");
              return buildLoading();
            } else {
              return buildForm(addPlayerCubit, playerRoleCubit, context);
            }
          },
        ));
  }

  Form buildForm(AddPlayerCubit addPlayerCubit, PlayerRoleCubit playerRoleCubit,
      BuildContext context) {
    return Form(
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
                color: ColorPallate.ebonyClay,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorPallate.mercury,
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
                  if (value.isEmpty) {
                    return 'Player name is required.';
                  } else
                    return null;
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
                color: ColorPallate.ebonyClay,
                fontSize: 20,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorPallate.mercury,
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
                        items: playerRoles.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          playerRoleCubit.emitState(value);
                        },
                        validator: (String value) {
                          if (value == null) {
                            return 'Select a player role.';
                          } else
                            return null;
                        },
                        onSaved: (String value) {
                          //addPlayerCubit.playerRole = value;
                        },
                      );
                    })),
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
              backgroundColor: ColorPallate.pomegranate,
            ),
            onPressed: () {
              Playernr player =
                  Playernr(name: 'Ronit prosad', role: 'Kisu parena');
              addPlayer(context, player);
            },
          )
        ],
      ),
    );
  }

  void addPlayer(BuildContext context, Playernr player) {
    final playerCubit = BlocProvider.of<AddplayersCubit>(context);
    playerCubit.addPlayer(player);
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }
}
