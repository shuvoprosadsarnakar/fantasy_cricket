import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/pages/player/player_list.dart';
import 'package:fantasy_cricket/pages/team/cubits/team_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/team/team_add_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    final GlobalKey<ScaffoldState> key = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PlayerBloc()..add(PlayerFetched()),
            child: PlayerList(),
          ),
        );
      case '/team':
        return MaterialPageRoute(
          builder: (_) => TeamAddEdit(
              TeamAddEditCubit(Team(
            id: '6IU4zbW3psbQaY9LsQ1C',
            name: 'Bangladesh',
            playerIds: ['RvLeWz8YfH8yhjiyaYIY'],
          )),
        ));
      default:
        return null;
    }
  }
}
