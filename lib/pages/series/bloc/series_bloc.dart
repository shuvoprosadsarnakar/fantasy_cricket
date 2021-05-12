import 'dart:async';
import 'package:fantasy_cricket/pages/series/bloc/series_event.dart';
import 'package:fantasy_cricket/pages/series/bloc/series_state.dart';
import 'package:fantasy_cricket/repositories/team_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final int limit = 20;
  SeriesBloc() : super(SeriesInitial());

  @override
  Stream<Transition<SeriesEvent, SeriesState>> transformEvents(
    Stream<SeriesEvent> events,
    TransitionFunction<SeriesEvent, SeriesState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SeriesState> mapEventToState(SeriesEvent event) async* {
    final currentState = state;
    if (event is SeriesFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is SeriesInitial) {
          final teams = await TeamRepo.fetchTeams(0, limit);
          if (teams.length < limit)
            yield SeriesSuccess(series: teams, hasReachedMax: true);
          else
            yield SeriesSuccess(series: teams, hasReachedMax: false);
          return;
        }
        if (currentState is SeriesSuccess) {
          // final teams = await TeamRepo.fetchTeams(1, limit);
          // if (teams.length < limit)
          //   yield SeriesSuccess(
          //       series: currentState.s + teams, hasReachedMax: true);
          // else
          //   yield SeriesSuccess(
          //       series: currentState.teams + teams, hasReachedMax: false);
        }
      } catch (error) {
        print(error);
        yield SeriesFailure();
      }
    }
    if (event is SeriesSearched) {
      print("Team searched bloc");
      if (currentState is SeriesSuccess) {
        //final teams =await TeamRepo.searchTeams(event.searchKeyWord, limit);
        // if (teams != null) {
        //   if (teams.length < limit)
        //     yield SeriesSuccess(series: teams, hasReachedMax: true);
        //   else
        //     yield SeriesSuccess(series: teams, hasReachedMax: false);
        // }
      }
    }
    if (event is SeriesSearchClosed) {
      //    final teams = await TeamRepo.fetchTeams(0, limit);
      //       if (teams.length < limit)
      //         yield SeriesSuccess(teams: teams, hasReachedMax: true);
      //       else
      //         yield SeriesSuccess(teams: teams, hasReachedMax: false);
      // }
      if (event is SeriesDelete) {
        //TeamRepo.deleteTeam(event.team);
      }
    }
  }

  bool _hasReachedMax(SeriesState state) =>
      state is SeriesSuccess && state.hasReachedMax;
}
