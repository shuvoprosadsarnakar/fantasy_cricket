import 'package:fantasy_cricket/pages/contests/contests_list.dart';
import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/cubits/running_contests_cubit.dart';
import 'package:fantasy_cricket/pages/user/contest/match_leaderboard.dart';
import 'package:fantasy_cricket/pages/user/contest/my_contests.dart';
import 'package:fantasy_cricket/pages/user/contest/running_contests.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/routing/app_router.dart';
import 'package:fantasy_cricket/utils/contest_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      home: MyContests(RunningContestsCubit()),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ColorPallate.pomegranate,
        accentColor: ColorPallate.pomegranate,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
