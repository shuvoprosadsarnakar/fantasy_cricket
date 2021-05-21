
import 'package:fantasy_cricket/pages/auth/cubits/password_reset_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/sign_in_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/sign_up_cubit.dart';
import 'package:fantasy_cricket/pages/auth/cubits/verify_email_cubit.dart';
import 'package:fantasy_cricket/pages/auth/password_reset.dart';
import 'package:fantasy_cricket/pages/auth/sign_in.dart';
import 'package:fantasy_cricket/pages/auth/sign_up.dart';
import 'package:fantasy_cricket/pages/auth/verify_email.dart';
import 'package:fantasy_cricket/pages/contests/contests_list.dart';
import 'package:fantasy_cricket/pages/contests/cubits/contests_list_cubit.dart';
import 'package:fantasy_cricket/pages/home/admin_home.dart';
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
import 'package:fantasy_cricket/routing/routes.dart';
import 'package:fantasy_cricket/utils/contest_statuses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (_) => SignIn(SignInCubit()),
        );
      case signUp:
        return MaterialPageRoute(
          builder: (_) => SignUp(SignUpCubit()),
        );
      case verifyEmail:
        return MaterialPageRoute(
          builder: (_) => VerifyEmail(VerifyEmailCubit()),
        );
      case passwordReset:
        return MaterialPageRoute(
          builder: (_) => PasswordReset(PasswordResetCubit()),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case adminHome:
        return MaterialPageRoute(
          builder: (_) => AdminHome(),
        );
      case player:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PlayerBloc()..add(PlayerFetched()),
            child: PlayerList(),
          ),
        );
      case team:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
            create: (context) => TeamBloc()..add(TeamFetched()),
            child: TeamList(),
          ),
        );
      case series:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
            create: (context) => SeriesBloc()..add(SeriesFetched()),
            child: SeriesList(),
          ),
        );
      case runningContestList:
        return MaterialPageRoute(
            builder: (_) => ContestsList(ContestsListCubit(), ContestStatuses.running),
          
        );
      case lockedContestList:
        return MaterialPageRoute(
            builder: (_) => ContestsList(ContestsListCubit(), ContestStatuses.locked),
          
        );
      case endedContestList:
        return MaterialPageRoute(
            builder: (_) => ContestsList(ContestsListCubit(), ContestStatuses.ended),
          
        );
      default:
        return null;
    }
  }
}
