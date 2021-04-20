import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/pages/player/player_add_edit.dart';
import 'package:fantasy_cricket/pages/player/player_list.dart';
import 'package:fantasy_cricket/pages/team/team_add_edit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Cricket',
       onGenerateRoute: AppRouter.onGenerateRoute,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorPallate.mercury,
        accentColor: ColorPallate.pomegranate,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
