import 'package:fantasy_cricket/pages/contests/contests_list.dart';
import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/pages/exchange/cubits/'
  'exchanges_list_cubit.dart';
import 'package:fantasy_cricket/pages/exchange/exchanges_list.dart';
import 'package:fantasy_cricket/pages/home/home.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/pages/player/player_list.dart';
import 'package:fantasy_cricket/pages/series/bloc/series_bloc.dart';
import 'package:fantasy_cricket/pages/series/bloc/series_event.dart';
import 'package:fantasy_cricket/pages/series/series_list.dart';
import 'package:fantasy_cricket/pages/team/bloc/team_bloc.dart';
import 'package:fantasy_cricket/pages/team/bloc/team_event.dart';
import 'package:fantasy_cricket/pages/team/team_list.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/contest_statuses.dart';
import 'package:fantasy_cricket/resources/route_names.dart';
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
      title: 'Fantasy Cricket - Admin',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: RouteNames.home,
    );
  }

  final ThemeData themeData = ThemeData(
    primaryColor: ColorPallate.pomegranate,
    accentColor: ColorPallate.pomegranate,
  );

  final Map<String, Widget Function(BuildContext)> routes = 
      <String, Widget Function(BuildContext)>{
    RouteNames.home: (BuildContext context) => Home(),

    RouteNames.playerList: (BuildContext context) => BlocProvider(
        create: (context) => PlayerBloc()..add(PlayerFetched()),
        child: PlayerList(),
      ),

    RouteNames.teamList: (BuildContext context) => BlocProvider(
        create: (context) => TeamBloc()..add(TeamFetched()),
        child: TeamList(),
      ),

    RouteNames.seriesList: (BuildContext context) => BlocProvider(
        create: (context) => SeriesBloc()..add(SeriesFetched()),
        child: SeriesList(),
      ),
    
    RouteNames.runningContestList: (BuildContext context) => 
      ContestsList(ContestsListCubit(), ContestStatuses.running),
    
    RouteNames.lockedContestList: (BuildContext context) => 
      ContestsList(ContestsListCubit(), ContestStatuses.locked),
    
    RouteNames.endedContestList: (BuildContext context) => 
      ContestsList(ContestsListCubit(), ContestStatuses.ended),
    
    RouteNames.exchangeList: (BuildContext context) => 
      ExchangesList(ExchangesListCubit()),
  };
}
