import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/pages/player/player_add_edit.dart';
import 'package:fantasy_cricket/pages/player/player_list.dart';
import 'package:fantasy_cricket/pages/team/team_add_edit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
      // home: BlocProvider(
      //   create:  (context) => PlayerBloc()..add(PlayerFetched()),
      //   child: PlayerList(),
      // ),
      home: TeamAddEdit(team: Team(
        id: '6IU4zbW3psbQaY9LsQ1C',
        name: 'Bangladesh',
        playerIds: ['RvLeWz8YfH8yhjiyaYIY'],  
      )),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorPallate.mercury,
        accentColor: ColorPallate.pomegranate,
        //canvasColor: ColorPallate.mercury,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
