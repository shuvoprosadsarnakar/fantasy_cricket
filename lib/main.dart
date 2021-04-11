import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/screens/add_player/add_player.dart';
import 'package:fantasy_cricket/screens/add_player/cubit/addplayer_cubit.dart';
import 'package:fantasy_cricket/screens/home/home.dart';
import 'package:fantasy_cricket/services/database/player_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
      home: BlocProvider(
        create: (context) => AddplayersCubit(FsPlayerRepository()),
        child: AddPlayer(),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorPallate.mercury,
        accentColor: ColorPallate.pomegranate,
        canvasColor: ColorPallate.mercury
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
