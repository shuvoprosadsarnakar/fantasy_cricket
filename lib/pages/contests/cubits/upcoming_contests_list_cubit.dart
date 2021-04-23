import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:fantasy_cricket/repositories/team_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum States {
  loading,
  fetchError,
  loaded,
}

class UpcomingContestsListCubit extends Cubit<States> {
  // this will be used to create upcoming contests list ui item
  final List<Series> notEndedSerieses = <Series>[];
  
  // this will be used to get team names by team id to create upcoming contests 
  // list ui item
  final List<Team> allTeams = <Team>[];
  
  UpcomingContestsListCubit() : super(null) {
    emit(States.loading);
    
    SeriesRepo.assignNotEndedSerieses(notEndedSerieses)
      .catchError((error) => emit(States.fetchError))
      .then((void value) {
        TeamRepo.fetchAllTeams(allTeams)
          .catchError((error) => emit(States.fetchError))
          .then((void value) => emit(States.loaded));
      });
  }
}